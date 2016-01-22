#!/bin/bash
#############################################################################
#
#      parametrized script for DIRAC buildup in the grid environment
#
#############################################################################

# check parameter - VO name

if [[ $1 != "voce" && $1 != "compchem" && $1 != "isragrid" && $1 != "osg" ]]; then
 echo -e "\n wrong parameter - VO name : $1 "
 exit -12
else
 VO=$1
 echo -e "OK, you specified properly VO=$VO, continuing"
fi

echo -e "\n *** Working host is: "; hostname -f

##################################################
# fill the PATH to be the same as in online mode
##################################################
#export PATH=/usr/kerberos/bin:/opt/d-cache/srm/bin:/opt/d-cache/dcap/bin:/opt/edg/bin:/opt/lcg/bin:/usr/local/bin:/bin:/usr/bin:$PATH
# rather do the sourcing ...
source /etc/bashrc
source ~/.bash_profile
#source ~/.bashrc


source $HOME/intel/bin/compilervars.sh intel64
echo "Intel Fortran/C/C++ noncommercial compilers with MKL library activated."
# My own OpenMPI Intel static
export PATH=/home/ilias/bin/openmpi_i32lp64_intel_static/bin:$PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi_i32lp64_intel_static/lib:$LD_LIBRARY_PATH
# my cmake stuff
export PATH=/home/ilias/bin/cmakestatic/bin:$PATH
echo "My own CMake is in PATH."
#my git in PATH
#export PATH=/home/ilias/bin/git/git-1.7.11.7:$PATH
# my most recent python 2.7.1 #
#export PATH=/people/disk2/ilias/bin/python/Python-2.7.1:$PATH

echo "My PATH=$PATH"
#echo "which make:"; which make
echo -e "\n\n set:"; set

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo "Running DIRAC cdash buildup at "$timestamp

DIRAC=/home/ilias/qch_work/software/dirac_git/trunk_current
#

#unset DO_UPDATE
DO_UPDATE=1

cd $DIRAC

if [[ -n $DO_UPDATE ]]; then

export MATH_ROOT=$HOME/intel/mkl; echo "Activated MATH_ROOT=$MATH_ROOT"

# update the local trunk...
#echo -e "\n updating the local $DIRAC"
#git pull

BUILD=build_Intel_OpenMPI_MKL_ILP64_STATIC
if [[ -d "$BUILD" ]]; then
   echo "removing previous build directory $BUILD"
  /bin/rm -rf $BUILD
fi
./setup --fc=/home/ilias/bin/openmpi_1.6.4_ilp64_intel_static/bin/mpif90 --cc=/home/ilias/bin/openmpi_1.6.4_ilp64_intel_static/bin/mpicc --cxx=/home/ilias/bin/openmpi_1.6.4_ilp64_intel_static/bin/mpiCC --static --mpi -D BUILDNAME="grid3_savba_ompi_intel_mkl_ilp64_STATIC" --int64 -D DART_TESTING_TIMEOUT=99999 -D ENABLE_OLD_LINKER=ON $BUILD
 cd $BUILD
 ctest -D ExperimentalUpdate  --track Grid
 ctest -D ExperimentalConfigure  --track Grid
 ctest -D ExperimentalBuild  --track Grid
 ctest -D ExperimentalTest -R cosci_energy --track Grid
 ctest -D ExperimentalSubmit --track Grid

 ls -lt $DIRAC/$BUILD/dirac.x
 ldd $DIRAC/$BUILD/dirac.x
 cmake .. > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build 1 - Intel-OpenMPI,MKL,static - finished at $timestamp \n"

cd $DIRAC
BUILD_SERIAL=build_Intel_serial_MKL_ILP64_STATIC
if [[ -d "$BUILD_SERIAL" ]]; then
   echo "removing previous build directory $BUILD_SERIAL"
  /bin/rm -rf $BUILD_SERIAL
fi
./setup --fc=ifort --cc=icc --cxx=icpc --static -D BUILDNAME="grid3_savba_serial_intel_mkl_ilp64_STATIC" --int64 -D DART_TESTING_TIMEOUT=99999 -D ENABLE_OLD_LINKER=ON $BUILD_SERIAL
 cd $BUILD_SERIAL
 ctest -D ExperimentalUpdate  --track Grid
 ctest -D ExperimentalConfigure  --track Grid
 ctest -D ExperimentalBuild  --track Grid
 ctest -D ExperimentalTest -R cosci_energy  --track Grid
 ctest -D ExperimentalSubmit  --track Grid

 ls -lt $DIRAC/$BUILD_SERIAL/dirac.x
 ldd $DIRAC/$BUILD_SERIAL/dirac.x
 cmake .. > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build 2 - Intel,MKL,serial,static - finished at $timestamp \n"

# cancel the variable #
 unset MATH_ROOT
 cd $DIRAC
 BUILD_GNU_SERIAL=build_GNU_serial_ILP64_STATIC
 if [[ -d "$BUILD_GNU_SERIAL" ]]; then
   echo "removing previous build directory $BUILD_GNU_SERIAL"
  /bin/rm -rf $BUILD_GNU_SERIAL
 fi
./setup --fc=gfortran44 --cc=gcc44 --cxx=g++44 --static -D BUILDNAME="grid3_savba_serial_GNU_ilp64_STATIC" --int64 -D DART_TESTING_TIMEOUT=99999 -D ENABLE_OLD_LINKER=ON $BUILD_GNU_SERIAL
 cd $BUILD_GNU_SERIAL
 ctest -D ExperimentalUpdate  --track Grid
 ctest -D ExperimentalConfigure  --track Grid
 ctest -D ExperimentalBuild  --track Grid
 ctest -D ExperimentalTest -R cosci_energy  --track Grid
 ctest -D ExperimentalSubmit --track Grid

 ls -lt $DIRAC/$BUILD_GNU_SERIAL/dirac.x
 ldd $DIRAC/$BUILD_GNU_SERIAL/dirac.x
 cmake .. > VERSION_cmake  2>&1  # get version

 timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
 echo -e "\n build 3 - GNU,serial,static -  finished at $timestamp \n"

#################################################
### continue with the launching for the grid  ###
#################################################

# create the reduced tar-file containing all important stuff ...
cd $DIRAC

# copy there the mpirun static with related directpries & files
cp    /home/ilias/bin/openmpi_i32lp64_intel_static/bin/mpirun         $DIRAC/$BUILD/.
/bin/rm -rf $BUILD/share
mkdir $BUILD/share
cp -R -P /home/ilias/bin/openmpi_i32lp64_intel_static/share/openmpi   $DIRAC/$BUILD/share/.
cp -R  /home/ilias/bin/openmpi_i32lp64_intel_static/etc               $DIRAC/$BUILD/.

# problems with "--exclude test/*/*.out"  - so remove them as such
/bin/rm test/*/*.out.*
/bin/rm -r test/*/compare

echo -e "\n\n packing fat DIRAC suite for grid computations..."
echo -e "\n packing done, we have tar-ball dirac_grid_suite.tgz file ready for grid-computing : "
ls -lt dirac_grid_suite.tgz

#another packing - only main stuff - test, runtest, pam, dirac.x execes, and static mpirun stuff
echo -e "\n\n packing slim DIRAC suite for grid computations..."
tar czf dirac_grid_suite_slim.tgz  pam  VERSION test  basis  basis_dalton basis_ecp  $BUILD/dirac.x $BUILD/VERSION_cmake $BUILD/etc $BUILD/share $BUILD/mpirun  $BUILD_SERIAL/dirac.x $BUILD_SERIAL/VERSION_cmake $BUILD_GNU_SERIAL/dirac.x $BUILD_GNU_SERIAL/VERSION_cmake  maintenance/grid_computing/diracrc_grid /home/ilias/bin/cmakestatic
echo -e "\n packing done, we have tar-ball dirac_grid_suite_slim.tgz file ready to be stored for grid-computing : "
ls -lt dirac_grid_suite_slim.tgz
echo -e "\n Done. Tarball with static execs ready."

else
  echo -e "\n\n ===  No local buildup of DIRAC done ! ==== "
  echo -e "Using the last tar-ball of  :"; ls -lt dirac_grid_suite.tgz
  echo -e "\n\n"
fi # of DO_UPDATE

# exit here, don't do other stuff
echo -e "leaving here, you will have to upload tarball onto SE"
exit 0

################################################################################ 
#
#      initialize your certificate from grid computing
#
#  voms-proxy-init --voms voce -hours 24 -vomslife 24:00 
#  voms-proxy-init --voms compchem -hours 24 -vomslife 24:00 
# 
################################################################################ 

echo -e "\n ---  My valid certificate (voms-proxy-info --all)  ---"
voms-proxy-info --all 

### define variable for access to SE ###
if [[ $VO == "voce" || $VO == "compchem" ]]; then
   export LFC_HOST=`lcg-infosites --vo $VO lfc`
   echo -e "\n defined variable LFC_HOST=$LFC_HOST"
   echo "VO_VOCE_DEFAULT_SE=$VO_VOCE_DEFAULT_SE"
   echo "VO_COMPCHEM_DEFAULT_SE=$VO_COMPCHEM_DEFAULT_SE"
   # get list of SE with the command: lcg-infosites -vo compchem se
   if [[  $VO == "compchem" ]]; then
      #VO_SE="aliserv6.ct.infn.it" - does not work, try other SE...
      VO_SE="grid2.fe.infn.it"
      echo "set storage element of $VO, VO_SE=$VO_SE"
   fi
   if [[  $VO == "voce" ]]; then
      VO_SE="se.ui.savba.sk"
      echo "set storage element of $VO, VO_SE=$VO_SE"
   fi
fi
# delete the old package from the SE
echo -e "\n deleting the previous file, lcg-del -a -v lfn:/grid/$VO/ilias/dirac_grid_suite.tgz ...."
lcg-del --force -a -v lfn:/grid/$VO/ilias/dirac_grid_suite.tgz || { echo "FYI: did not succeed in deleting, maybe the file is already deleted...";}
echo -e "\n Then (possibly after deleting), checking emptyness of VO's storage space; lcg-ls -l lfn://grid/$VO/ilias"
lcg-ls -l lfn://grid/$VO/ilias || { echo "lcg-ls command somehow failed, once again..."; lcg-ls -l lfn://grid/$VO/ilias;  }

# upload the fresh tar-ball onto the SE
echo -e "\n uploading lcg-cr -d $VO_SE  -v file:$PWD/dirac_grid_suite.tgz -l lfn://grid/$VO/ilias/dirac_grid_suite.tgz...."
lcg-cr -d $VO_SE  file:$PWD/dirac_grid_suite.tgz  -l lfn://grid/$VO/ilias/dirac_grid_suite.tgz || { echo "Error exit, the uploading failed"; exit -4; }

###   Check your copied file on the grid SE:  ###
echo -e "\n After uploading, list of files on grid SE, lcg-ls -l lfn://grid/$VO/ilias/dirac_grid_suite.tgz"
lcg-ls -l lfn://grid/$VO/ilias/dirac_grid_suite.tgz
#  lcg-ls lfn://grid/compchem/ilias
echo -e "\n File attributes lcg-lr  lfn://grid/$VO/ilias/dirac_grid_suite.tgz:"
lcg-lr    lfn://grid/$VO/ilias/dirac_grid_suite.tgz
#  do also uberftp se.ui.savba.sk "ls /dpm/ui.savba.sk/home...."

##############################################################################################
# change the ACL attributes, see https://edms.cern.ch/file/722398/1.4/gLite-3-UserGuide.pdf
##############################################################################################
lfc-setacl -m group::0,other:0  /grid/$VO/ilias
# control output of ACL attributes
echo -e "\n ACL attributes of /grid/$VO/ilias:"
lfc-getacl /grid/$VO/ilias

##########################################################################
#             submit external launching script with glite                #
##########################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n going to launch jobs for grid, with timestamp=$timestamp..."
cd maintenance/grid_computing
echo -e "Now I am in the directory $PWD"

# launch through the cycle #
for i in {1..8} 
do
  glite-wms-job-submit -o JOB_$VO.$timestamp.no$i -a submit_$VO.jdl
  sleep 5 # wait after each launch
done

echo -e "\n Done, script finished."

exit 0

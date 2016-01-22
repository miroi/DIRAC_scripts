#!/bin/sh
#######################################################################################################
#
#
#               short script for copying and launching the DIRAC testing machinery
#
#
#######################################################################################################

echo -e "\n --- Hostname: \c"; hostname -f; echo
echo -e " ---------  I am here: ---------  $PWD "
echo -e "---  My space: "; df -h .

echo -e  "\n files on my OSG space srm://red-srm1.unl.edu:8443/srm/v2/server?SFN=/mnt/hadoop/public/milias"
#lcg-ls -l lfn://grid/voce/ilias

 lcg-ls -l -D srmv2 -b  srm://red-srm1.unl.edu:8443/srm/v2/server?SFN=/mnt/hadoop/public/milias

echo " "

#####################################
###  copy files to the current CE ###
#####################################
export rundir=`pwd`
#lcg-cp lfn://grid/voce/ilias/dirac_test_suite.tgz  file://$rundir/dirac_test_suite.tgz  ||  { echo "Exiting...no dirac_test_suite.tgz found..." ; exit 3; }
#lcg-cp lfn://grid/voce/ilias/dirac_current.tgz  file://$rundir/dirac_current.tgz  ||  { echo "Exiting...no dirac_current.tgz  found..." ; exit -1; }
lcg-cp -D srmv2 -b srm://red-srm1.unl.edu:8443/srm/v2/server?SFN=/mnt/hadoop/public/milias/dirac_current.tgz file:$PWD/dirac_current.tgz

##########################################
##  make it executable and finally launch
##########################################
echo -e "\n Job started at : \c"; date

echo -e "\n server Python version \c"; python -V

echo -e "\n"

 # directory with all static executables - dirac.x, cmake, ctest, mpirun - and related directories
 export BUILD_EXECS=build_imported_static
 export BUILD=build

 export OPAL_PREFIX=$PWD/$BUILD
 echo -e "OPAL_PREFIX=$OPAL_PREFIX"
 
 export PATH=$PWD/$BUILD:$PATH
 echo -e "modified PATH=$PATH"
 echo -e "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

echo -e "\n ---- server environment ---- set :"
set

echo -e "\n ---- server CPU equipment, /proc/cpuinfo ----"
cat /proc/cpuinfo

echo -e "\n Number of CPUs :\c";cat /proc/cpuinfo | grep processor | wc -l

echo -e "\n ---- server memory equipment ----"
cat /proc/meminfo

echo -e "\n ---- DIRAC unpacking ---- \n"
tar --version
tar xvfz dirac_current.tgz

#/bin/rm -rf $BUILD
#mv $BUILD_EXECS  $BUILD
#chmod  u+x  $BUILD/dirac.x  $BUILD/mpirun  $BUILD/cmake  $BUILD/ctest  pam  runtest
chmod  u+x  $BUILD/dirac.x   $BUILD/cmake  $BUILD/ctest  pam  runtest

# create diracrc file for paralle run on the grid CE
#cp maintenance/grid_testing/diracrc_grid  diracrc
#echo -e "\n ---- diracrc created ---- \n"

echo -e "\n --- Launching simple pam test  --- \n "; 

#python ./pam --inp=test/fscc/fsccsd_IH.inp --mol=test/fscc/Mg.mol  --mw=92 --scratch=$PWD --outcmo --mpi=2
python ./pam --inp=test/fscc/fsccsd_IH.inp --mol=test/fscc/Mg.mol  --mw=92 --scratch=$PWD --outcmo 

#####################################################################

echo -e "\n --- Launching quick runtest --- \n "; 

#python ./runtest --verbose --tests=quick --mpi=2   # works ...
#python ./runtest --verbose --tests="cosci_energy fscc acmoin" --mpi=2 # works
#python ./runtest --verbose --quick --mpi=2  #  works
#python ./runtest --verbose --quick   #  works
#python ./runtest --verbose --all  # works

#############################################################
#               check own static cmake stuff
#############################################################
 cd $BUILD
 ./cmake  -DVERBOSE_OUTPUT=ON -DBUILDNAME="$HOSTNAME.grid_test_ompi_static" -DENABLE_MPI=ON -DRUNTEST_NR_PROC=2 -DRUNTEST_TIMEOUT="00:18:00" -DDART_TESTING_TIMEOUT=99999 ..
 make ExperimentalConfigure
 make ExperimentalStart
# make ExperimentalTest
 make ExperimentalSubmit
## return back into main directory
 cd ..

# ------------
echo -e "\n --- Packing all wanted stuff from the grid CE  --- \n "; 
ls -lt
tar --version
#tar --help
echo " "
tar cvzf dirac_suite_back.tgz test *.out *.tgz

############################
#  print out some info .. 
############################
echo -e "\n -------------------------------------------------------"
echo -e "Job finished at: \c"; date
echo -e "I am here: \c"; pwd
echo -e "My space: "; df -h .
echo -e "\n All files:"; ls -lt
echo -e "Total occupied space: \c"; du -h -s .

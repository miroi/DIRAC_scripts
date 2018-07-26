#!/bin/sh
#######################################################################################################
#
#
#   Script for downloading, upacking and launching the DIRAC4Grid suite on some grid CE of given VO.
#
#
#######################################################################################################

# check the parameter - VO name
if [[ $1 != "voce" && $1 != "compchem" && $1 != "isragrid" && $1 != "osg" && $1 != "sivvp.slovakgrid.sk"  && $1 != "enmr.eu" ]]; then
 echo -e "\n wrong parameter - VO name : $1 "
 exit 12
else
 VO=$1
 echo -e "\n OK, you specified properly the VO=$VO, continuing \n"
fi


# include all external functions from  file copied onto current CE
if [ -e "UtilsCE.sh" ]
then
  source ./UtilsCE.sh
else
  echo -e "\n Source file UtilsCE not found! Error exit 13 ! \n"
  exit 13
fi

# name of Dirac package distributed over grid clusters
package="DIRAC4Grid_suite.tgz"

print_CE_info
querry_CE_attributes $VO
check_file_on_SE $VO $package
# download & unpack tar-file onto CE - MUST be successfull or exit
download_from_SE $VO $package

# get number of procs #
unset nprocs
get_nprocs_CE nprocs
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 5
echo -e "\n Number of #CPU obtained from the function: $nprocs \n"

#
# Unpack the downloaded DIRAC tar-ball
#
unpack_DIRAC $package
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 6

#-----------------------------------------------
#  specify the scratch space for DIRAC runs    #
#-----------------------------------------------
#echo "--scratch=\$PWD/DIRAC_scratch" >  ~/.diracrc
#echo -e "\n\n The ~/.diracrc file was created, containing: "; cat ~/.diracrc

##########################################
#      set build dirs and paths          #
##########################################

# directories with all static executables - dirac.x and OpenMPI
export PATH_SAVED=$PATH
export LD_LIBRARY_PATH_SAVED=$LD_LIBRARY_PATH

# set the Dirac basis set library path for pam
export BASDIR_PATH=$PWD/basis:$PWD/basis_dalton:$PWD/basis_ecp

export BUILD_MPI1=$PWD/build_intelmkl_openmpi-1.10.1_i8_static
export BUILD_MPI2=$PWD/build_openmpi_gnu_i8_openblas_static

export BUILD1=$PWD/build_intelmkl_i8_static
export BUILD2=$PWD/build_gnu_i8_openblas_static

export PAM_MPI1=$BUILD_MPI1/pam
export PAM_MPI2=$BUILD_MPI2/pam
export PAM1=$BUILD1/pam
export PAM2=$BUILD2/pam

# take care of unique nodes ...
UNIQUE_NODES="`cat $PBS_NODEFILE | sort | uniq`"
UNIQUE_NODES="`echo $UNIQUE_NODES | sed s/\ /,/g `"
echo -e "\n Unique nodes for parallel run (from PBS_NODEFILE):  $UNIQUE_NODES"

echo "PBS_NODEFILE=$PBS_NODEFILE"
echo "PBS_O_QUEUE=$PBS_O_QUEUE"
echo "PBS_O_WORKDIR=$PBS_O_WORKDIR"


#####################################################################
#                    Run few control tests
#####################################################################

  export DIRTIMEOUT="25m"
  echo -e "\n Time limit for running DIRAC tests, DIRTIMEOUT=$DIRTIMEOUT "
  echo -e "When you finish running tests, set it to other value, according to size of your jobs !"

  echo -e "\n\n --- Going to launch parallel Dirac - OpenMPI+Intel+MKL+i8 - with few tests  --- \n "; date 

#----------------------------------------------------------
#   Main cycle over OpenMPI-OpenMP number of tasks/threads
#----------------------------------------------------------
#for ij in 1-1 1-6 1-12 2-1 2-6 6-1 6-2 12-1; do
for ij in 1-1 1-6 1-12 1-24 2-1 2-6 2-12 6-1 6-2 6-4 12-1 12-2 24-1; do

  set -- ${ij//-/ }
  npn=$1
  nmkl=$2
  
  echo -e "\n \n ==========   Hybrid OpenMPI-OpenMP run on 1 node ======== #OpenMPI=$npn #OpenMP=$nmkl "

  # set MKL envirovariables
  unset MKL_NUM_THREADS
  export MKL_NUM_THREADS=$nmkl
  echo -e "\n Updated MKL_NUM_THREADS=$MKL_NUM_THREADS"
  echo -e "MKL_DYNAMIC=$MKL_DYNAMIC"
  echo -e "OMP_NUM_THREADS=$OMP_NUM_THREADS"
  echo -e "OMP_DYNAMIC=$OMP_DYNAMIC"
  # set OpenMPI variables 
  unset PATH
  export PATH=$BUILD_MPI1/bin:$PATH_SAVED
  export LD_LIBRARY_PATH=$BUILD_MPI1/lib:$LD_LIBRARY_PATH_SAVED
  unset OPAL_PREFIX
  export OPAL_PREFIX=$BUILD_MPI1
  echo -e "\n The modified PATH=$PATH"
  echo -e "The LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
  echo -e "The variable OPAL_PREFIX=$OPAL_PREFIX"
  echo -e "\n The mpirun in PATH ... \c"; which mpirun; mpirun --version
  export DIRAC_MPI_COMMAND="mpirun -H ${UNIQUE_NODES} -npernode $npn --prefix $BUILD_MPI1"
  echo -e "\n The DIRAC_MPI_COMMAND=${DIRAC_MPI_COMMAND} \n"

  #time test/cosci_energy/test -b $BUILD_MPI1 -d -v
  time test/cc_energy_and_mp2_dipole/test -b $BUILD_MPI1 -d -v
  time test/cc_linear/test -b $BUILD_MPI1 -d -v
  time test/fscc/test -b $BUILD_MPI1  -d -v
  #time test/fscc_highspin/test -b $BUILD_MPI1  -d -v

  # set OpenBLAS enviro-variables
  unset OPENBLAS_NUM_THREADS
  export OPENBLAS_NUM_THREADS=$nmkl
  echo -e "\n Updated OPENBLAS_NUM_THREADS=${OPENBLAS_NUM_THREADS}"
  # set OpenMPI variables
  unset PATH
  export PATH=$BUILD_MPI2/bin:$PATH_SAVED
  export LD_LIBRARY_PATH=$BUILD_MPI2/lib:$LD_LIBRARY_PATH_SAVED
  unset OPAL_PREFIX
  export OPAL_PREFIX=$BUILD_MPI2
  echo -e "\n The modified PATH=$PATH"
  echo -e "The LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
  echo -e "The variable OPAL_PREFIX=$OPAL_PREFIX"
  echo -e "\n The mpirun in PATH ... \c"; which mpirun; mpirun --version
  export DIRAC_MPI_COMMAND="mpirun -H ${UNIQUE_NODES} -npernode $npn --prefix $BUILD_MPI2"
  echo -e "\n The DIRAC_MPI_COMMAND=${DIRAC_MPI_COMMAND} \n"

  #time test/cosci_energy/test -b $BUILD_MPI2 -d -v
  time test/cc_energy_and_mp2_dipole/test -b $BUILD_MPI2 -d -v
  time test/cc_linear/test -b $BUILD_MPI2 -d -v
  time test/fscc/test -b $BUILD_MPI2  -d -v
  #time test/fscc_highspin/test -b $BUILD_MPI2 -d -v

done

#
# Individual runs
#
#echo -e "\n --- Launching simple parallel pam test  --- \n "; 
#python ./pam --inp=test/fscc/fsccsd_IH.inp --mol=test/fscc/Mg.mol  --mw=92 --outcmo --mpi=$nprocs --dirac=$BUILD/dirac.x


##############################################################
#                                                            #
#      pack selected files to get them back from CE          #
#                                                            #
##############################################################
echo -e "\n --------------------------------- \n "; 
# delete old tar-ball first
#ls -lt DIRAC_grid_suite.tgz
#echo -e "\n deleting the old DIRAC_grid_suite.tgz..."
#rm dirac_grid_suite.tgz
#echo "check files..."
#ls -lt

#echo -e "\n --- Packing all wanted stuff back from the grid CE  --- "; 
#tar --version
#echo -e "\n we have to pack (ls -lt) :"
#ls -lt
#echo " "
#tar czf DIRAC_grid_suite_back.tgz test *.out
#echo -e "\n selected directories/files of the DIRAC suite packed back, ls -lt DIRAC_grid_suite_back.tgz:";ls -lt DIRAC_grid_suite_back.tgz

# upload final tarball onto SE so that you can dowload it later
# upload_to_SE $VO

#############################################
#### flush out some good-bye message ... ####
#############################################
final_message

exit 0

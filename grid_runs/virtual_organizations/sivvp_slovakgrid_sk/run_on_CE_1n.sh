#!/bin/sh
#######################################################################################################
#
#
#   Script for downloading, upacking and launching the DIRAC4Grid suite on some grid CE of given VO.
#
#
#######################################################################################################

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
# set the name of the virtual organization
VO="sivvp.slovakgrid.sk"

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
echo "--scratch=\$PWD/DIRAC_scratch" >  ~/.diracrc
echo -e "\n\n The ~/.diracrc file was created, containing: "; cat ~/.diracrc

##########################################
#      set build dirs and paths          #
##########################################

# directories with all static executables - dirac.x and OpenMPI
export PATH_SAVED=$PATH
export LD_LIBRARY_PATH_SAVED=$LD_LIBRARY_PATH

# set the Dirac basis set library path for pam
export BASDIR_PATH=$PWD/basis:$PWD:basis_dalton:$PWD:basis_ecp

export BUILD_MPI1=$PWD/build_intelmkl_openmpi-1.10.1_i8_static
export BUILD_MPI2=$PWD/build_openmpi_gnu_i8_openblas_static

export BUILD1=$PWD/build_intelmkl_i8_static
export BUILD2=$PWD/build_gnu_i8_openblas_static

export PAM_MPI1=$BUILD_MPI1/pam
export PAM_MPI2=$BUILD_MPI2/pam
export PAM1=$BUILD1/pam
export PAM2=$BUILD2/pam

export PATH=$BUILD_MPI1/bin:$PATH_SAVED
export LD_LIBRARY_PATH=$BUILD_MPI1/lib:$LD_LIBRARY_PATH_SAVED
echo -e "Modified PATH=$PATH"
echo -e "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo -e "own mpirun in PATH ?\c"; which mpirun; mpirun --version

#####################################################################
#                    Run few control tests
#####################################################################

  echo -e "\n\n --- Going to launch parallel runtest - OpenMPI+Intel+MKL+i8 - with few tests  --- \n "; date 
  export DIRAC_MPI_COMMAND="mpirun -np 4"
  time test/cosci_energy/test -b $BUILD_MPI1 -d -v
  time test/cc_energy_and_mp2_dipole/test -b $BUILD_MPI1 
  time test/fscc/test -b $BUILD_MPI1 
  time test/fscc_highspin/test -b $BUILD_MPI1 

  echo -e "\n\n --- Going to launching selected serial runtest - Intel+MKL+i8 - with few tests --- \n "; date 
  unset DIRAC_MPI_COMMAND
  export MKL_DOMAIN_NUM_THREADS=4
  #test/cosci_energy/test -b $BUILD1 -d -v
  time test/cc_linear/test -b $BUILD1 

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

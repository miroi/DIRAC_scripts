#!/bin/sh
#######################################################################################################
#
#
#   Script for downloading, upacking and launching the DIRAC4Grid suite on some grid CE of given VO.
#
#
#######################################################################################################

# include all external functions - directory on ilias-et-grid.ui.savba.sk
RoutinesDir=/scratch/milias/Work/qch/software/My_scripts/grid_runs/common_bash_routines
if [ -e "$RoutinesDir/UtilsCE.sh" ]
then
  source $RoutinesDir/UtilsCE.sh
else
  echo -e "\n Source file $RoutinesDir/UtilsCE not found! Error exit 13 ! \n"
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

# specify the scratch space for DIRAC runs #
echo "--scratch=\$PWD/DIRAC_scratch" >  ~/.diracrc
echo -e "\n\n The ~/.diracrc file was created, containing: "; cat ~/.diracrc

##########################################
#      set build dirs and paths          #
##########################################

# directories with all static executables - dirac.x and OpenMPI
export BUILD=build_intelmkl_openmpi-1.10.1_i8_static
export BUILD_SERIAL=build_intelmkl_i8_static

unset OPAL_PREFIX
export OPAL_PREFIX=$PWD/$BUILD
echo -e "Variable OPAL_PREFIX=$OPAL_PREFIX"
export PATH=$PWD/$BUILD:$PATH
#export PATH=$PWD/$BUILD_SERIAL:$PWD/$BUILD:$PATH
echo -e "Modified PATH=$PATH"
#echo -e "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

#############################################################
#               check own static mpirun stuff               #
#############################################################
echo -e "\n\n"
echo -e "own mpirun in PATH ?\c"; which mpirun; mpirun --version


#####################################################################
#                    Run few control tests
#####################################################################

  echo -e "\n\n --- Going to launch parallel runtest - OpenMPI+Intel+MKL - with few tests  --- \n "; date 
  export DIRAC_MPI_COMMAND="mpirun -np 4"
  test/cosci_energy/test -b $PWD/$BUILD -d -v

  echo -e "\n\n --- Going to launching selected serial runtest - Intel+MKL - with few tests --- \n "; date 
  unset DIRAC_MPI_COMMAND
  unset OPAL_PREFIX
  test/cosci_energy/test -b $PWD/$BUILD_SERIAL -d -v

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

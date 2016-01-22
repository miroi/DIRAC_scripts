#!/bin/sh
#######################################################################################################
#
#
#           Script for copying and launching the DIRAC suite on grid CE
#
#
#######################################################################################################

# check the parameter - VO name
if [[ $1 != "voce" && $1 != "compchem" && $1 != "isragrid" && $1 != "osg" && $1 != "sivvp.slovakgrid.sk" ]]; then
 echo -e "\n wrong parameter - VO name : $1 "
 exit 12
else
 VO=$1
 echo -e "OK, you specified properly the VO=$VO, continuing \n"
fi

# include all external functions
if [ -e "UtilsCE.sh" ]
then
  source ./UtilsCE.sh
  #declare -F # list function
else
  echo "Source file UtilsCE not found! Error exit !"
  exit 333
fi

print_CE_info
querry_CE_attributes $VO
check_file_on_SE $VO
# download & unpack tar-file onto CE - MUST be successfull or exit
download_from_SE $VO "dirac_grid_suite.tgz"
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 4

# get number of procs #
unset nprocs
get_nprocs_CE nprocs
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 5
echo -e "\n Number of #CPU obtained from the function: $nprocs \n"

##########################################
#      set build dirs and paths          #
##########################################
# directory with all static executables - dirac.x, cmake, ctest, mpirun - and related directories
export BUILD=build_Intel_OpenMPI_MKL_ILP64_STATIC
export BUILD_SERIAL=build_Intel_serial_MKL_ILP64_STATIC
export BUILD_GNU_SERIAL=build_GNU_serial_ILP64_STATIC

unset OPAL_PREFIX
export OPAL_PREFIX=$PWD/$BUILD
echo -e "Variable OPAL_PREFIX=$OPAL_PREFIX"
export PATH=$PWD/$BUILD:$PATH
#export PATH=$PWD/$BUILD_SERIAL:$PWD/$BUILD:$PATH
echo -e "Modified PATH=$PATH"
echo -e "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

unpack_DIRAC
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 6

#############################################################
#           check own static cmake, mpirun stuff
#############################################################
echo -e "\n\n"
echo -e "own cmake in PATH ? \c"; which cmake; cmake --version
echo -e "own ctest in PATH ? \c"; which ctest; ctest --version
echo -e "own mpirun in PATH ?\c"; which mpirun; mpirun --version

#
#



echo -e "\n\n === Job started at : \c"; date

echo -e "\n --- Launching simple parallel pam test  --- \n "; 
python ./pam --inp=test/fscc/fsccsd_IH.inp --mol=test/fscc/Mg.mol  --mw=92 --outcmo --mpi=$nprocs --dirac=$BUILD/dirac.x

#####################################################################
#           specify tests for two runtest runs
#####################################################################

regular_subset='fscc fscc_highspin fscc_intensities krci_energy krci_properties_omega_tdm krci_properties_perm_dipmom cosci_energy acmoin gaunt basis_automatic_augmentation basis_input bss_energy density_at_nuclei dft_ac dft_ao_eval dft_response_symmetry fde_static-vemb_dipole lucita_large lucita_short  mcscf_energy  molecular_mean_field_hamiltonian_schemes mp2_energy mp2_properties  projection_analysis response_lao_shield  symmetry_recognition symmetry_scf_energy visual_lao_shielding ecp'

benchmark_subset='cc_benchmark cc_linear fscc_intensities gaunt mcscf_energy moltra_4or6'

#######################################################################################
#unset DO_CMAKE
DO_CMAKE=1
if [[ -n $DO_CMAKE ]]; then
  echo -e "\n\n===== Performing false configuration setup in order to enable tests running with static mpirun,dirac.x ===== \n"
  cd $BUILD
  echo -e "\n I am in build-directory  $PWD \n"
  #echo -e "--- Directory $BUILD content ---:"; ls -lt
# FIX THIS  ERROR:
# CMake Error: The current CMakeCache.txt directory /tmp/ilias_OUWzTUf41_ntFwYFY3Pk7Q/build/CMakeCache.txt is different than the directory /home/ilias/qch_work/software/dirac_git/trunk_current/build where CMakeCache.txt was created. This may result in binaries being created in the wrong place. If you are not sure, reedit the CMakeCache.txt
#CMake Error: The source "/tmp/ilias_OUWzTUf41_ntFwYFY3Pk7Q/CMakeLists.txt" does not match the source "/home/ilias/qch_work/software/dirac_git/trunk_current/CMakeLists.txt" used to generate cache.  Re-run cmake with a different source directory.
  mv CMakeCache.txt CMakeCache.txt_STORED
#note: make  -DENABLE_MPI=OFF in order to avoid cmake's MPI configuration on an unknown grid's CE
  cmake  -DVERBOSE_OUTPUT=ON -DBUILDNAME="$THIS_HOSTNAME.grid_ompi_intel_mkl_static" -DENABLE_MPI=OFF  -DRUNTEST_NR_PROC=$nprocs -DRUNTEST_TIMEOUT="00:18:00" -DDART_TESTING_TIMEOUT=99999  ..
# make ExperimentalConfigure
  make ExperimentalStart
  make ExperimentalTest
  make ExperimentalSubmit
## return back into main directory
  cd ..
  echo -e "\n Now I am in main directory: $PWD \n"
  date
fi

  echo -e "\n\n --- Going to launch parallel runtest - OpenMPI+Intel+MKL - with quick tests suite  --- \n "; date 
 # python ./runtest  --verbose --backup --binary=$PWD/$BUILD/dirac.x --mpi=$nprocs --tests="$regular_subset"
  python ./runtest  --verbose --backup --builddir=$PWD/$BUILD --mpi=$nprocs --quick

  #echo -e "\n\n --- Launching benchmark parallel runtest - OpenMPI+Intel+MKL --- \n "; date 
  #python ./runtest --benchmark --verbose --backup --binary=$PWD/$BUILD/dirac.x --mpi=$nprocs  --tests="$benchmark_subset"


if [[ -n $DO_CMAKE ]]; then
  echo -e "\n\n===== Performing false configuration setup in order to enable tests running with static Intel, serial dirac.x ===== \n"
### Again, do the buildup using serial standalone executable ###
# http://software.intel.com/en-us/articles/recommended-settings-for-calling-intelr-mkl-routines-from-multi-threaded-applications/
# set MKL threads
  let nprocsm1=$nprocs-1
  export MKL_NUM_THREADS=$nprocsm1; echo -e "MKL threads, MKL_NUM_THREADS=$MKL_NUM_THREADS" 
  cd $BUILD_SERIAL
  echo -e "\n I am in build-directory $PWD \n"
  echo -e "--- Directory $BUILD_SERIAL content ---:"; ls -lt
  mv CMakeCache.txt CMakeCache.txt_STORED
  #note: make  -DENABLE_MPI=OFF in order to avoid cmake's MPI configuration on an unknown grid's CE
  cmake  -DVERBOSE_OUTPUT=ON -DBUILDNAME="$THIS_HOSTNAME.grid_serial_intel_mkl_static" -DENABLE_MPI=OFF -DRUNTEST_TIMEOUT="00:18:00" -DDART_TESTING_TIMEOUT=99999 ..
  make ExperimentalStart
  make ExperimentalTest
  make ExperimentalSubmit
## return back into main directory
  cd ..
  echo -e "\n I am again in the main directory $PWD \n"
  date
fi

  echo -e "\n\n --- Going to launching selected serial runtest - Intel+MKL - with quick test suite --- \n "; date 
  #python ./runtest --verbose --backup --binary=$PWD/$BUILD_SERIAL/dirac.x --tests="$regular_subset"
  python ./runtest --verbose --backup --builddir=$PWD/$BUILD_SERIAL  --quick

  #echo -e "\n\n --- Launching benchmark serial runtest - Intel+MKL --- \n "; date 
  #python ./runtest --all --benchmark --verbose --backup --binary=$PWD/$BUILD_SERIAL/dirac.x --tests="$benchmark_subset"

### Again, do the buildup using serial standalone executable ###
if [[ -n $DO_CMAKE ]]; then
  echo -e "\n\n===== Performing false configuration setup in order to enable tests running with static, GNU, serial dirac.x ===== \n"
  cd $BUILD_GNU_SERIAL
  echo -e "\n I am in build-directory $PWD \n"
  echo -e "--- Directory $BUILD_GNU_SERIAL content ---:"; ls -lt
  mv CMakeCache.txt CMakeCache.txt_STORED
  #note: make  -DENABLE_MPI=OFF in order to avoid cmake's MPI configuration on an unknown grid's CE
  cmake  -DVERBOSE_OUTPUT=ON -DBUILDNAME="$THIS_HOSTNAME.grid_serial_GNU_static" -DENABLE_MPI=OFF -DRUNTEST_TIMEOUT="00:18:00" -DDART_TESTING_TIMEOUT=99999  ..
  make ExperimentalStart
  make ExperimentalTest
  make ExperimentalSubmit
## return back into main directory
  cd ..
  echo -e "\n I am again in the main directory $PWD \n"
  date
fi

  echo -e "\n\n --- Goind to launching serial runtest - GNU - with selected tests  --- \n "; date
 # python ./runtest  --verbose --backup --binary=$PWD/$BUILD_GNU_SERIAL/dirac.x --tests="$regular_subset"
  python ./runtest  --verbose --backup --builddir=$PWD/$BUILD_GNU_SERIAL --quick

 # echo -e "\n\n --- Launching benchmark serial runtest - GNU  --- \n "; date 
 # python ./runtest --all --benchmark --verbose --backup --binary=$PWD/$BUILD_GNU_SERIAL/dirac.x --tests="$benchmark_subset"


# ----------------------------------------- #
# ---- try own buildup on the grid CE ----- #
# ----------------------------------------- #

 echo -e "\n\n\n ==== Try own buildup on the host server (in build directory) ==== \n "

 unset FC
 if [[ -n `which pgf90` ]]; then
   FC=`which pgf90`
   echo -e "\n pgf90 ? $FC ";
   pgf90 -V
 elif [[ -n `which ifort` ]]; then
   FC=`which ifort`
   echo -e "\n ifort ? $FC"; 
   ifort --version
 elif [[ -n `which lfc` ]]; then
   FC=`which lfc`
   lfc --version
   echo -e "\n lfc ? $FC "; 
 elif [[ -n  `which gfortran44` ]]; then
   FC=`which gfortran44`
   echo -e "\n gfortran44 ? $FC "; 
   gfortran44 --version
 elif [[ -n  `which gfortran` ]]; then
   FC=`which gfortran`
   echo -e "\n gfortran ? $FC "; 
   gfortran --version
 else
   echo -e "\n No suitable Fortran compiler found..."
 fi

 unset CC
 if [[ -n `which pgcc` ]]; then
   CC=`which pgcc`
   pgcc -V
   echo -e "\n pgcc ? $CC ";
 elif [[ -n `which icc` ]]; then
   CC=`which icc`
   echo -e "\n icc ? $CC"; 
   icc --version
 elif [[ -n `which fcc` ]]; then
   CC=`which fcc`
   echo -e "\n fcc ? $CC ";
   fcc --version 
 elif [[ -n  `which gcc44` ]]; then
   CC=`which gcc44`
   echo -e "\n gcc44 ? $CC "; 
   gcc44 --version
 elif [[ -n  `which gcc` ]]; then
   CC=`which gcc`
   echo -e "\n gcc ? $CC "; 
   gcc --version
 else
   echo -e "\n No suitable C compiler found..."
 fi

 unset CXX
 if [[ -n `which pgCC` ]]; then
   CXX=`which pgCC`
   pgCC -V
   echo -e "\n pgCC ? $CXX ";
 elif [[ -n `which icpc` ]]; then
   CXX=`which icpc`
   echo -e "\n iccpc ? $CXX"; 
   icpc --version
 elif [[ -n `which fcc` ]]; then
   CXX=`which fcc`
   echo -e "\n fcc ? $CXX ";
   fcc --version 
 elif [[ -n  `which g++44` ]]; then
   CXX=`which g++44`
   echo -e "\n g++44 ? $CXX "; 
   g++44 --version
 elif [[ -n  `which g++` ]]; then
   CXX=`which g++`
   echo -e "\n g++ ? $CXX "; 
   g++ --version
 else
   echo -e "\n No suitable C++ compiler found !"
 fi

 if [[ -n $MKLROOT ]]; then
    echo -e "\n ===  Found Intel MKL library, MKLROOT=$MKLROOT === \n"
    export MATH_ROOT=$MKLROOT ; echo "MATH_ROOT variable activated"
 fi

##########################################################
## check first envirinment variables related to OpenMPI ##
##########################################################
 if [[ -n $MPI_OPENMPI_PATH ]]; then
   echo -e "\n Active MPI_OPENMPI_PATH=$MPI_OPENMPI_PATH !"
   ls -lt $MPI_OPENMPI_PATH
   #export PATH=$MPI_OPENMPI_PATH/bin:$PATH
   #export LD_LIBRARY_PATH=$MPI_OPENMPI_PATH/lib:$LD_LIBRARY_PATH
   # lets try
   module load openmpi
   echo "Extended variable PATH=$PATH"
   echo "Extended variable LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
 fi

### check presence of parallel MPI compilers ###
 MPISWITCH='off'; MPISWITCH_F90='off'; MPISWITCH_CC='off'; MPISWITCH_CXX='off';
 if [[ -n `which mpif90` ]]; then
    echo -e "\n Is there mpif90 ? \c"; which mpif90
    mpif90 --showme
    mpif90 --version
    MPISWITCH_F90='on'
 fi
 if [[ -n `which mpicc` ]]; then
    echo -e "\n Is there mpicc ? \c";  which mpicc
    mpicc --showme
    mpicc --version
    MPISWITCH_CC='on'
 fi
 if [[ -n `which mpiCC` ]]; then
    echo -e "\n Is there mpiCC ? \c";  which mpiCC
    mpiCC --showme
    mpiCC --version
    MPISWITCH_CXX='on'
 fi
 if [[ $MPISWITCH_F90 == 'on' && $MPISWITCH_CC == 'on' && $MPISWITCH_CXX == 'on' ]]; then
    if [[ -n `which mpirun` ]]; then
        echo -e "\n Is there mpirun ? \c";  which mpirun
        mpirun --version
        MPISWITCH='on'
    fi
 fi

 ######################################
 #### Assign build name of grid CE ####
 ######################################
 BUILD_NAME="$THIS_HOSTNAME.CEownbuild"
 echo "Assigned BUILD NAME=$BUILD_NAME"

 if [[ -n $FC  && -n $CC  && -n $CXX ]]; then
    echo "buildup with selected FC=$FC, CC=$CC and CXX=$CXX :"
    python ./setup --fc=$FC --cc=$CC --cxx=$CXX -D VERBOSE_OUTPUT=ON --int64=on --mpi=off -D BUILDNAME=$BUILD_NAME -D RUNTEST_TIMEOUT="00:40:00" -D DART_TESTING_TIMEOUT=99999 
 elif [[ -n $FC  && -n $CC ]]; then
    echo "buildup with selected FC=$FC and CC=$CC :"
    python ./setup --fc=$FC --cc=$CC -D VERBOSE_OUTPUT=ON --int64=on --mpi=off -D BUILDNAME=$BUILD_NAME -D RUNTEST_TIMEOUT="00:40:00" -D DART_TESTING_TIMEOUT=99999 
 elif [[ -n $FC  && -z $CC ]]; then
    echo "buildup with selected FC=$FC :"
    python ./setup --fc=$FC  -D VERBOSE_OUTPUT=ON --int64=on --mpi=off -D BUILDNAME=$BUILD_NAME -D RUNTEST_TIMEOUT="00:40:00" -D DART_TESTING_TIMEOUT=99999 
 elif [[ -z $FC  && -n $CC ]]; then
    echo "buildup with selected CC=$CC :"
    python ./setup --cc=$CC -D VERBOSE_OUTPUT=ON --int64=on --mpi=off -D BUILDNAME=$BUILD_NAME -D RUNTEST_TIMEOUT="00:40:00" -D DART_TESTING_TIMEOUT=99999 
 elif [[ -z $FC  && -z $CC ]]; then
    echo "buildup with cmake automatic selection of compilers :"
    python ./setup -D VERBOSE_OUTPUT=ON --int64=on --mpi=off -D BUILDNAME=$BUILD_NAME -D RUNTEST_TIMEOUT="00:40:00" -D DART_TESTING_TIMEOUT=99999 
 fi

 unset BUILD_LOCAL
 if [ -d "build" ]; then
   echo -e "\n own created build directory exists, going to perform make Experimental in steps ..."
   cd build
   #make Experimental
   make ExperimentalConfigure
   make ExperimentalBuild
   #
   echo -e "\n Locally prepared executable dirac.x created ?"
   ls -lt ./dirac.x
   if [ -f "./dirac.x" ]; then
      BUILD_LOCAL=build
   fi
   #
   make ExperimentalTest
   make ExperimentalSubmit
   # return to the main directory
   cd ..
 fi

 if [ -f "$BUILD_LOCAL" ]; then
   echo -e "\n\n --- Launching  runtest - selected tests - of own dirac.x generated on grid CE --- \n "; date
   #python ./runtest --verbose --backup --binary=$dirac_file --tests="$regular_subset"
   python ./runtest --verbose --backup --builddir=$PWD/$BUILD_LOCAL --quick
 else
   echo -e "\n own buildup of dirac.x failed, no tests run \n"
 fi 

##############################################################
#                                                            #
#      pack selected files to get them back from CE          #
#                                                            #
##############################################################
echo -e "\n --------------------------------- \n "; 
# delete old tar-ball first
ls -lt dirac_grid_suite.tgz
echo -e "\n deleting the old dirac_grid_suite.tgz..."
rm dirac_grid_suite.tgz
echo "check files..."
ls -lt
echo -e "\n --- Packing all wanted stuff back from the grid CE  --- "; 
tar --version
echo -e "\n we have to pack (ls -lt) :"
ls -lt
echo " "
#tar cvzf dirac_suite_back.tgz test *
#tar czf dirac_grid_suite_back.tgz test $BUILD_LOCAL *.out
tar czf dirac_grid_suite_back.tgz test *.out
echo -e "\n selected directories/files of the DIRAC suite packed back , ls -lt dirac_grid_suite_back.tgz:";ls -lt dirac_grid_suite_back.tgz

# upload final tarball onto SE so that you can dowload it later
# upload_to_SE $VO

#############################################
#### flush out some good-bye message ... ####
#############################################
final_message

exit 0


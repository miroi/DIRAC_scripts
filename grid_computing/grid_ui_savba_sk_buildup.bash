#!/bin/bash
#############################################################################
#
#      parametrized script for DIRAC buildup in the grid environment
#
#############################################################################

##################################################
# fill the PATH to be the same as in online mode
##################################################
export PATH=/usr/lib64/qt-3.3/bin:/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

#MiroD advice
source $HOME/.bash_profile

source /usr/share/Modules/init/bash

module avail

# Intel compilers
#source $HOME/intel/bin/compilervars.sh intel64
module unload intel/2015
module load intel/2015
echo "Intel Fortran/C/C++ commercial compilers with MKL library activated."

# PGI compilers
module unload pgi/13.10
module load pgi/13.10
echo "PGI commercial compilers activated."
module list

#
# My own OpenMPI Intel static

# my STATIC cmake stuff
#export PATH=/home/ilias/bin/cmakestatic/bin:$PATH
#echo "My own static CMake is in PATH."

# my own binutils-gold
#export LIBDIR=/home/ilias/bin/binutils-gold/lib:$LIBDIR
#export LD_LIBRARY_PATH=$LIBDIR:$LD_LIBRARY_PATH
#export LD_RUN_PATH=$LIBDIR:$LD_RUN_PATH
#export PATH=/home/ilias/bin/binutils-gold/binutils-master/gold:$PATH

# select my "private" CDash 
export CTEST_PROJECT_NAME=DIRACext

echo "My PATH=$PATH"
#echo "which make:"; which make
echo -e "\n set:"; set

# very important - set running time for tests !
export DIRTIMEOUT="8m"

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo "Running DIRAC cdash buildup at "$timestamp

DIRAC=/home/ilias/Work/qch/software/trunk

cd $DIRAC
git clean -f -d -x

# submodule update
git submodule update --init --recursive

export MATH_ROOT=/opt/intel/mkl
echo -e  "\n Activated MATH_ROOT=$MATH_ROOT ! \n"

# update the local trunk...
#echo -e "\n updating the local $DIRAC"
#git pull

###################################################################################
cd $DIRAC
# My own MPICH Intel static
export PATH=/home/ilias/bin/mpich-3.2-intel-static/bin:$PATH
export LD_LIBRARY_PATH=/home/ilias/bin/mpich-3.2-intel-static/lib:$LD_LIBRARY_PATH
#
BUILD_MPICH_INTEL=build_intelmkl_mpich_static
if [[ -d "$BUILD_MPICH_INTEL" ]]; then
   echo "removing previous build directory $BUILD_MPICH_INTEL"
  /bin/rm -rf $BUILD_MPICH_INTEL
fi
# deactivate interest module !
python ./setup --mpi  --fc=/home/ilias/bin/mpich-3.2-intel-static/bin/mpif90 --cc=/home/ilias/bin/mpich-3.2-intel-static/bin/mpicc --cxx=/home/ilias/bin/mpich-3.2-intel-static/bin/mpicxx --static --int64 --cmake-options="-D BUILDNAME='grid_savba_mpich_intel_mkl_i8_STATIC'  -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF"  $BUILD_MPICH_INTEL
 cd $BUILD_MPICH_INTEL
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild  
 export DIRAC_MPI_COMMAND="/home/ilias/bin/mpich-3.2-intel-static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_MPICH_INTEL/dirac.x
 ldd $DIRAC/$BUILD_MPICH_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-MPICH,MKL,i8,static - finished at $timestamp \n"


###################################################################################
cd $DIRAC
# My own OpenMPI Intel static
export PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/bin:$PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/lib:$LD_LIBRARY_PATH
#
BUILD_OMPI_INTEL=build_intelmkl_openmpi-1.10.1_i8_static
if [[ -d "$BUILD_OMPI_INTEL" ]]; then
   echo "removing previous build directory $BUILD_OMPI_INTEL"
  /bin/rm -rf $BUILD_OMPI_INTEL
fi
# deactivate interest module !
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpif90 --cc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicxx --static --int64 --cmake-options="-D BUILDNAME='grid_savba_ompi_intel_mkl_i8_STATIC'  -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='MKL' "  $BUILD_OMPI_INTEL
 cd $BUILD_OMPI_INTEL
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild  
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R dft
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_OMPI_INTEL/dirac.x
 ldd $DIRAC/$BUILD_OMPI_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-OpenMPI_1.10.1,MKL,i8,static - finished at $timestamp \n"

sleep 30

##
##  Intel + MKL + i8 + static
##
cd $DIRAC
BUILD_SERIAL_INTEL=build_intelmkl_i8_static
if [[ -d "$BUILD_SERIAL_INTEL" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_INTEL"
  /bin/rm -rf $BUILD_SERIAL_INTEL
fi

python ./setup --fc=ifort --cc=icc --cxx=icpc --static --int64 --cmake-options="-D BUILDNAME='grid_savba_intel_mkl_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='MKL' "  $BUILD_SERIAL_INTEL
 cd $BUILD_SERIAL_INTEL
 ctest -D ExperimentalUpdate  
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_INTEL/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build- Intel,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10

##
## Intel + ownmath + i8 + static
##
cd $DIRAC
BUILD_SERIAL_INTEL1=build_intel_ownmath_i8_static
if [[ -d "$BUILD_SERIAL_INTEL1" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_INTEL1"
  /bin/rm -rf $BUILD_SERIAL_INTEL1
fi
python ./setup --fc=ifort --cc=icc --cxx=icpc  --int64 --static --cmake-options="-D BUILDNAME='grid_savba_intel_ownmath_i8_STATIC' -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF"  $BUILD_SERIAL_INTEL1
 cd $BUILD_SERIAL_INTEL1
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cosci_energy  
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_INTEL1/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_INTEL1/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel,ownmath,i8,serial,static - finished at $timestamp \n"

sleep 10


##
## Intel + OpenBLAS + i8 + static
##
cd $DIRAC
BUILD_SERIAL_INTEL2=build_intel_openblas_i8_static
if [[ -d "$BUILD_SERIAL_INTEL2" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_INTEL2"
  /bin/rm -rf $BUILD_SERIAL_INTEL2
fi
python ./setup --static --fc=ifort --cc=icc --cxx=icpc --int64   --cmake-options="-D BUILDNAME='grid_savba_intel_openblas_i8_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=ON -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_SERIAL_INTEL2
 cd $BUILD_SERIAL_INTEL2
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_INTEL2/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_INTEL2/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel,OpenBLAS,i8,serial,static - finished at $timestamp \n"

sleep 10


######################
# PGI + MKL - static #
######################
cd $DIRAC
BUILD_PGI=build_pgi_mkl_i8_static
if [[ -d "$BUILD_PGI" ]]; then
   echo "removing previous build directory $BUILD_PGI"
  /bin/rm -rf $BUILD_PGI
fi
#module load pgi
python ./setup --fc=pgf90 --cc=pgcc --cxx=pgCC  --int64 --static --cmake-options="-D BUILDNAME='grid_savba_pgi_mkl_i8_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='MKL' "  $BUILD_PGI
 cd $BUILD_PGI
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI/dirac.x
 ldd $DIRAC/$BUILD_PGI/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - PGI,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10


#
# PGI + OWNMATH - static 
#
cd $DIRAC
BUILD_PGI1=build_pgi_ownnath_i8_static
if [[ -d "$BUILD_PGI1" ]]; then
   echo "removing previous build directory $BUILD_PGI1"
  /bin/rm -rf $BUILD_PGI1
fi
python ./setup --fc=pgf90 --cc=pgcc --cxx=pgCC  --int64 --static  --cmake-options="-D BUILDNAME='grid_savba_pgi_ownmath_i8_STATIC' -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF"  $BUILD_PGI1
 cd $BUILD_PGI1
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI1/dirac.x
 ldd $DIRAC/$BUILD_PGI1/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build  - PGI,ownmath,i8,serial,static - finished at $timestamp \n"

sleep 10

#
# PGI + OpenBLAS - static 
#
cd $DIRAC
BUILD_PGI2=build_pgi_openblas_static
if [[ -d "$BUILD_PGI2" ]]; then
   echo "removing previous build directory $BUILD_PGI2"
  /bin/rm -rf $BUILD_PGI2
fi
python ./setup --fc=pgf90 --cc=pgcc --cxx=pgCC  --static --cmake-options="-D BUILDNAME='grid_savba_pgi_openblas_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=ON -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_PGI2
 cd $BUILD_PGI2
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI2/dirac.x
 ldd $DIRAC/$BUILD_PGI2/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build  - PGI,openblas,serial,static - finished at $timestamp \n"

sleep 10


#####################
##  GNU+MKL STATIC ##
#####################
cd $DIRAC
BUILD_SERIAL_GNU=build_gnumkl_i8_static
if [[ -d "$BUILD_SERIAL_GNU" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_GNU"
  /bin/rm -rf $BUILD_SERIAL_GNU
fi
python ./setup --fc=gfortran --cc=gcc --cxx=g++ --static --int64 --cmake-options="-D BUILDNAME='grid_savba_gnu_mkl_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='MKL'"  $BUILD_SERIAL_GNU
 cd $BUILD_SERIAL_GNU
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure   
 ctest -j4 -D ExperimentalBuild    
 ctest -j4 -D ExperimentalTest -R  cc
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_GNU/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_GNU/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10

#########################
##  GNU+OWNMATH STATIC ##
#########################
cd $DIRAC
BUILD_SERIAL_GNU1=build_gnu_ownmath_i8_static
if [[ -d "$BUILD_SERIAL_GNU1" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_GNU1"
  /bin/rm -rf $BUILD_SERIAL_GNU1
fi
python ./setup --int64 --fc=gfortran --cc=gcc --cxx=g++ --static --cmake-options="-D BUILDNAME='grid_savba_serial_gnu_ownmath_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF"  $BUILD_SERIAL_GNU1
 cd $BUILD_SERIAL_GNU1
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild  
 ctest -j4 -D ExperimentalTest -R cosci_energy    
 ctest -D ExperimentalSubmit  

 ls -lt $DIRAC/$BUILD_SERIAL_GNU1/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_GNU1/dirac.x
# python binary_info.py  > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,ownmath,i8,serial,static - finished at $timestamp \n"
sleep 10


##########################
##  GNU+OPENBLAS STATIC ##
##########################
cd $DIRAC
BUILD_SERIAL_GNU2=build_gnu_openblas_static
if [[ -d "$BUILD_SERIAL_GNU2" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_GNU2"
  /bin/rm -rf $BUILD_SERIAL_GNU2
fi
python ./setup  --fc=gfortran --cc=gcc --cxx=g++ --static --cmake-options="-D BUILDNAME='grid_savba_serial_gnu_openblas_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=ON -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_SERIAL_GNU2
 cd $BUILD_SERIAL_GNU2
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild  
 ctest -j4 -D ExperimentalTest -R cosci_energy    
 ctest -D ExperimentalSubmit  

 ls -lt $DIRAC/$BUILD_SERIAL_GNU2/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_GNU2/dirac.x
# python binary_info.py  > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,OpenBLAS,serial,static - finished at $timestamp \n"
sleep 10


#################################################
### continue with the packing for grid servers ##
#################################################

# create the reduced tar-file containing all important stuff ...
cd $DIRAC

# copy there the mpirun static with related directories & files
cp    /home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpirun            $DIRAC/$BUILD_OMPI_INTEL/.
/bin/rm -rf $BUILD_OMPI_INTEL/share
mkdir $BUILD_OMPI_INTEL/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_intel_static/share/openmpi     $DIRAC/$BUILD_OMPI_INTEL/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_intel_static/etc               $DIRAC/$BUILD_OMPI_INTEL/.
# don't forget export OPAL_PREFIX=$PWD/$BUILD 

# problems with "--exclude test/*/*.out"  - so remove them as such
/bin/rm    test/*/*.out
/bin/rm -r test/*/compare

packed_dirac=DIRAC_grid_suite.tgz
echo -e "\n\n Packing slim DIRAC suite (executables,basis sets and tests) for grid computations ! \n"
#     
tar czf $packed_dirac  test  basis  basis_dalton  basis_ecp \
$BUILD_OMPI_INTEL/dirac.x $BUILD_OMPI_INTEL/pam $BUILD_OMPI_INTEL/etc $BUILD_OMPI_INTEL/share $BUILD_OMPI_INTEL/mpirun  \
$BUILD_SERIAL_INTEL/dirac.x $BUILD_SERIAL_INTEL/pam  \
$BUILD_SERIAL_INTEL1/dirac.x $BUILD_SERIAL_INTEL1/pam  \
$BUILD_SERIAL_INTEL2/dirac.x $BUILD_SERIAL_INTEL2/pam  \
$BUILD_SERIAL_GNU/dirac.x $BUILD_SERIAL_GNU/pam  \
$BUILD_SERIAL_GNU1/dirac.x $BUILD_SERIAL_GNU1/pam  \
$BUILD_SERIAL_GNU2/dirac.x $BUILD_SERIAL_GNU2/pam  \
$BUILD_PGI/dirac.x $BUILD_PGI/pam \
$BUILD_PGI1/dirac.x $BUILD_PGI1/pam \
$BUILD_PGI2/dirac.x $BUILD_PGI2/pam \
maintenance/grid_computing/diracrc_grid 

echo -e "\n packing done, we have tar-ball file ready to be placed on SE for grid-computing : "
ls -lt $packed_dirac
echo -e "\n Done. Tarball with static execs ready."

# exit here, don't do other stuff
echo -e "\n Leaving here, you will have to upload the tarball manually onto your SE."
exit 0

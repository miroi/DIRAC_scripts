#!/bin/bash
#############################################################################
#
#   Script for static DIRAC buildups for the grid environment
#
#
# Written by Miro Ilias, Matej Bel University, Slovakia
#                        GSI, Germany
#
#############################################################################

##################################################
# fill the PATH to be the same as in online mode
##################################################

#  enable the newest GNU compilers
scl enable devtoolset-3 bash

export PATH=/home/ilias/bin/cmake/cmake-3.3.0-Linux-x86_64/bin:/usr/lib64/qt-3.3/bin:/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
# add i8-openblas
export PATH=/scratch/milias/bin/openblas_i8:$PATH

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

# newest GNU suite
module unload devtoolset/4
module load devtoolset/4

echo -e "\n All loaded modules"
module list

#
# save PATH with all modules for later modifications
#

export PATH_SAVED=$PATH
export LD_LIBRARY_PATH_SAVED=$LD_LIBRARY_PATH

echo "My PATH=$PATH"
echo -e "cmake --version :\c"; cmake --version

#echo "which make:"; which make
#echo -e "\n set:"; set

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

# very important - set running time for tests !
export DIRTIMEOUT="8m"

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo "Running DIRAC cdash buildup at "$timestamp

#DIRAC=/home/ilias/Work/qch/software/trunk
DIRAC=/scratch/milias/Work/qch/software/trunk

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
#
# Intel-MPICH,MKL,i8,static
#
###################################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel-MPICH,MKL,i8,static - at $timestamp \n"

cd $DIRAC
# My own MPICH Intel static
unset PATH
export PATH=/home/ilias/bin/mpich-3.2-intel-static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/mpich-3.2-intel-static/lib:$LD_LIBRARY_PATH_SAVED
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
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/mpich-3.2-intel-static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_MPICH_INTEL/dirac.x
 ldd $DIRAC/$BUILD_MPICH_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-MPICH,MKL,i8,static - finished at $timestamp \n"


###################################################################################
#
#                     Intel-MPICH,OWNMATH,i8,static
#
###################################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel-MPICH,OWNMATH,i8,static - at $timestamp \n"

cd $DIRAC
# My own MPICH Intel static
unset PATH
export PATH=/home/ilias/bin/mpich-3.2-intel-static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/mpich-3.2-intel-static/lib:$LD_LIBRARY_PATH_SAVED
#
BUILD_MPICH_INTEL1=build_intelownmath_mpich_static
if [[ -d "$BUILD_MPICH_INTEL1" ]]; then
   echo "removing previous build directory $BUILD_MPICH_INTEL1"
  /bin/rm -rf $BUILD_MPICH_INTEL1
fi
# deactivate interest module !
python ./setup --mpi  --fc=/home/ilias/bin/mpich-3.2-intel-static/bin/mpif90 --cc=/home/ilias/bin/mpich-3.2-intel-static/bin/mpicc --cxx=/home/ilias/bin/mpich-3.2-intel-static/bin/mpicxx --static --int64 --cmake-options="-D BUILDNAME='grid_savba_mpich_intel_ownmath_i8_STATIC'  -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON"  $BUILD_MPICH_INTEL1
 cd $BUILD_MPICH_INTEL1
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/mpich-3.2-intel-static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_MPICH_INTEL1/dirac.x
 ldd $DIRAC/$BUILD_MPICH_INTEL1/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-MPICH, OWNMATH, i8,static - finished at $timestamp \n"


###################################################################################
##
##  Intel-OpenMPI_1.10.1,MKL,i8,static
##
###################################################################################

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel-OpenMPI_1.10.1,MKL,i8,static - at $timestamp \n"

cd $DIRAC
BUILD_OMPI_INTEL=build_intelmkl_openmpi-1.10.1_i8_static
# My own OpenMPI Intel static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/lib:$LD_LIBRARY_PATH_SAVED
#
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
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

#
# copy there related OpenMPI directories 
cp  -R   /home/ilias/bin/openmpi-1.10.1_intel_static/bin            $DIRAC/$BUILD_OMPI_INTEL/.
cp  -R   /home/ilias/bin/openmpi-1.10.1_intel_static/lib            $DIRAC/$BUILD_OMPI_INTEL/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_INTEL/share
mkdir $DIRAC/$BUILD_OMPI_INTEL/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_intel_static/share/openmpi     $DIRAC/$BUILD_OMPI_INTEL/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_intel_static/etc               $DIRAC/$BUILD_OMPI_INTEL/.
# don't forget export OPAL_PREFIX=$PWD/$BUILD 
#

 ls -lt $DIRAC/$BUILD_OMPI_INTEL/dirac.x
 ldd $DIRAC/$BUILD_OMPI_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-OpenMPI_1.10.1,MKL,i8,static - finished at $timestamp \n"

sleep 10

###################################################################################
##
##  Intel-OpenMPI_1.10.1,OWNMATH,i8,static
##
###################################################################################

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel-OpenMPI_1.10.1,OWNMATH,i8,static - at $timestamp \n"

cd $DIRAC
BUILD_OMPI_INTEL1=build_intel_ownmath_openmpi-1.10.1_i8_static
# My own OpenMPI Intel static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/lib:$LD_LIBRARY_PATH_SAVED
#
if [[ -d "$BUILD_OMPI_INTEL1" ]]; then
   echo "removing previous build directory $BUILD_OMPI_INTEL1"
  /bin/rm -rf $BUILD_OMPI_INTEL1
fi
# deactivate interest module !
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpif90 --cc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicxx --static --int64 --cmake-options="-D BUILDNAME='grid_savba_ompi_intel_ownmath_i8_STATIC'  -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON "  $BUILD_OMPI_INTEL1
 cd $BUILD_OMPI_INTEL1
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R  cosci_energy
 ctest -D ExperimentalSubmit 

#
# copy there related OpenMPI directories 
cp -R    /home/ilias/bin/openmpi-1.10.1_intel_static/bin            $DIRAC/$BUILD_OMPI_INTEL1/.
cp -R    /home/ilias/bin/openmpi-1.10.1_intel_static/lib            $DIRAC/$BUILD_OMPI_INTEL1/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_INTEL1/share
mkdir $DIRAC/$BUILD_OMPI_INTEL1/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_intel_static/share/openmpi     $DIRAC/$BUILD_OMPI_INTEL1/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_intel_static/etc               $DIRAC/$BUILD_OMPI_INTEL1/.
# don't forget export OPAL_PREFIX=$PWD/$BUILD 

 ls -lt $DIRAC/$BUILD_OMPI_INTEL1/dirac.x
 ldd $DIRAC/$BUILD_OMPI_INTEL1/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-OpenMPI_1.10.1,OWNMATH,i8,static - finished at $timestamp \n"

sleep 10

###################################################################################
##
##                Intel-OpenMPI_1.10.1,OPENBLAS,i8,static
##
###################################################################################

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel-OpenMPI_1.10.1,OPENBLAS,i8,static - at $timestamp \n"

cd $DIRAC
BUILD_OMPI_INTEL2=build_intel_openblas_openmpi-1.10.1_i8_static
# My own OpenMPI Intel static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_intel_static/lib:$LD_LIBRARY_PATH_SAVED
#
if [[ -d "$BUILD_OMPI_INTEL2" ]]; then
   echo "removing previous build directory $BUILD_OMPI_INTEL2"
  /bin/rm -rf $BUILD_OMPI_INTEL2
fi
# deactivate interest module !
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpif90 --cc=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpicxx --static --int64 --cmake-options="-D BUILDNAME='grid_savba_ompi_intel_openblas_i8_STATIC'  -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS'  -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF  "  $BUILD_OMPI_INTEL2
 cd $BUILD_OMPI_INTEL2
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure 
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_intel_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R  cosci_energy
 ctest -D ExperimentalSubmit 

# copy there related OpenMPI directories
cp -R /home/ilias/bin/openmpi-1.10.1_intel_static/bin            $DIRAC/$BUILD_OMPI_INTEL2/.
cp -R /home/ilias/bin/openmpi-1.10.1_intel_static/lib            $DIRAC/$BUILD_OMPI_INTEL2/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_INTEL2/share
mkdir $DIRAC/$BUILD_OMPI_INTEL2/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_intel_static/share/openmpi     $DIRAC/$BUILD_OMPI_INTEL2/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_intel_static/etc               $DIRAC/$BUILD_OMPI_INTEL2/.
# don't forget export OPAL_PREFIX=$PWD/$BUILD 
#

 ls -lt $DIRAC/$BUILD_OMPI_INTEL2/dirac.x
 ldd $DIRAC/$BUILD_OMPI_INTEL2/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel-OpenMPI_1.10.1,OpenBLAS,i8,static - finished at $timestamp \n"

sleep 10

##############################################################################
##  Intel + MKL + i8 + static
##############################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build- Intel,MKL,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_INTEL/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_INTEL/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build- Intel,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10

#######################################################################################
## Intel + ownmath + i8 + static
#######################################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel,ownmath,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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


#############################################################################
##
## Intel + OpenBLAS + i8 + static
##
#############################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - Intel,OpenBLAS,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
cd $DIRAC
BUILD_SERIAL_INTEL2=build_intel_openblas_i8_static
if [[ -d "$BUILD_SERIAL_INTEL2" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_INTEL2"
  /bin/rm -rf $BUILD_SERIAL_INTEL2
fi
python ./setup --static --fc=ifort --cc=icc --cxx=icpc --int64   --cmake-options="-D BUILDNAME='grid_savba_intel_openblas_i8_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_SERIAL_INTEL2
 cd $BUILD_SERIAL_INTEL2
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_INTEL2/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_INTEL2/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - Intel,OpenBLAS,i8,serial,static - finished at $timestamp \n"

sleep 10


######################
# PGI + MKL - static #
######################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - PGI,MKL,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI/dirac.x
 ldd $DIRAC/$BUILD_PGI/dirac.x
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - PGI,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10


############################################################################
# PGI + OWNMATH - static 
############################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build  - PGI,ownmath,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI1/dirac.x
 ldd $DIRAC/$BUILD_PGI1/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build  - PGI,ownmath,i8,serial,static - finished at $timestamp \n"

sleep 10

################################################################################
#
# PGI + OpenBLAS - static 
#
################################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build  - PGI,i8,openblas,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
cd $DIRAC
BUILD_PGI2=build_pgi_openblas_static
if [[ -d "$BUILD_PGI2" ]]; then
   echo "removing previous build directory $BUILD_PGI2"
  /bin/rm -rf $BUILD_PGI2
fi
python ./setup --fc=pgf90 --cc=pgcc --cxx=pgCC  --static --cmake-options="-D BUILDNAME='grid_savba_pgi_openblas_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_PGI2
 cd $BUILD_PGI2
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI2/dirac.x
 ldd $DIRAC/$BUILD_PGI2/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build  - PGI,i8,openblas,serial,static - finished at $timestamp \n"

sleep 10


####################################################################
##
# PGI + i8 + OpenBLAS - static 
##
####################################################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build  - PGI,openblas,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
cd $DIRAC
BUILD_PGI3=build_pgi_openblas_i8_static
if [[ -d "$BUILD_PGI2" ]]; then
   echo "removing previous build directory $BUILD_PGI2"
  /bin/rm -rf $BUILD_PGI2
fi
python ./setup --int64 --fc=pgf90 --cc=pgcc --cxx=pgCC  --static --cmake-options="-D BUILDNAME='grid_savba_pgi_openblas_i8_STATIC' -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D DART_TESTING_TIMEOUT=99999 -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' "  $BUILD_PGI3
 cd $BUILD_PGI3
 ctest -D ExperimentalUpdate   
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild   
 ctest -j4 -D ExperimentalTest -R cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_PGI3/dirac.x
 ldd $DIRAC/$BUILD_PGI3/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build  - PGI,openblas,i8,serial,static - finished at $timestamp \n"

sleep 10


#####################
##  GNU+MKL STATIC ##
#####################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,MKL,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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
 ctest -j4 -D ExperimentalTest -R  cosci_energy
 ctest -D ExperimentalSubmit 

 ls -lt $DIRAC/$BUILD_SERIAL_GNU/dirac.x
 ldd $DIRAC/$BUILD_SERIAL_GNU/dirac.x

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,MKL,i8,serial,static - finished at $timestamp \n"

sleep 10

#########################
##  GNU+OWNMATH STATIC ##
#########################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,ownmath,i8,serial,static - at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
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
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,i8,OpenBLAS,serial,static at $timestamp \n"
unset PATH
export PATH=$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_SAVED
unset DIRAC_MPI_COMMAND
cd $DIRAC
BUILD_SERIAL_GNU2=build_gnu_i8_openblas_static
if [[ -d "$BUILD_SERIAL_GNU2" ]]; then
   echo "removing previous build directory $BUILD_SERIAL_GNU2"
  /bin/rm -rf $BUILD_SERIAL_GNU2
fi
python ./setup  --fc=gfortran --cc=gcc --cxx=g++ --static --cmake-options="-D BUILDNAME='grid_savba_serial_gnu_openblas_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' " --int64  $BUILD_SERIAL_GNU2
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


#################################
##                             ##
## OPENMPI GNU+OPENBLAS STATIC ##
##                             ##
#################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,i8,OpenBLAS,OpenMPI 1.10.1,static - at $timestamp \n"

# My own OpenMPI GNU static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/lib:$LD_LIBRARY_PATH_SAVED
cd $DIRAC
BUILD_OMPI_GNU3=build_openmpi_gnu_i8_openblas_static
if [[ -d "$BUILD_OMPI_GNU3" ]]; then
   echo "removing previous build directory $BUILD_OMPI_GNU3"
  /bin/rm -rf $BUILD_OMPI_GNU3
fi
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpif90  --cc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicxx --static --cmake-options="-D BUILDNAME='grid_savba_ompi_gnu_openblas_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='OPENBLAS' " --int64   $BUILD_OMPI_GNU3
 cd $BUILD_OMPI_GNU3
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy    
 ctest -D ExperimentalSubmit  
#
# copy there related OpenMPI directories
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/bin            $DIRAC/$BUILD_OMPI_GNU3/.
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/lib            $DIRAC/$BUILD_OMPI_GNU3/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_GNU3/share
mkdir $DIRAC/$BUILD_OMPI_GNU3/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_gnu_static/share/openmpi     $DIRAC/$BUILD_OMPI_GNU3/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_gnu_static/etc               $DIRAC/$BUILD_OMPI_GNU3/.
#
# don't forget export OPAL_PREFIX=$PWD/$BUILD  !
#

 ls -lt $DIRAC/$BUILD_OMPI_GNU3/dirac.x
 ldd $DIRAC/$BUILD_OMPI_GNU3/dirac.x
# python binary_info.py  > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,OpenBLAS,OpenMPI 1.10.1,static - finished at $timestamp \n"
sleep 10


#################################
##                             ##
## OPENMPI GNU+OWNMATH  STATIC ##
##                             ##
#################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,OWNMATH,OpenMPI,static - at $timestamp \n"

# My own OpenMPI GNU static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/lib:$LD_LIBRARY_PATH_SAVED
cd $DIRAC
BUILD_OMPI_GNU4=build_openmpi_gnu_ownmath_static
if [[ -d "$BUILD_OMPI_GNU4" ]]; then
   echo "removing previous build directory $BUILD_OMPI_GNU4"
  /bin/rm -rf $BUILD_OMPI_GNU4
fi
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpif90  --cc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicxx --static --cmake-options="-D BUILDNAME='grid_savba_ompi_gnu_ownmath_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=ON -D ENABLE_BUILTIN_LAPACK=ON -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF " --int64   $BUILD_OMPI_GNU4
 cd $BUILD_OMPI_GNU4
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy    
 ctest -D ExperimentalSubmit  
#
# copy there related OpenMPI directories
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/bin            $DIRAC/$BUILD_OMPI_GNU4/.
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/lib            $DIRAC/$BUILD_OMPI_GNU4/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_GNU4/share
mkdir $DIRAC/$BUILD_OMPI_GNU4/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_gnu_static/share/openmpi     $DIRAC/$BUILD_OMPI_GNU4/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_gnu_static/etc               $DIRAC/$BUILD_OMPI_GNU4/.
#
# don't forget export OPAL_PREFIX=$PWD/$BUILD  !
#

 ls -lt $DIRAC/$BUILD_OMPI_GNU4/dirac.x
 ldd $DIRAC/$BUILD_OMPI_GNU4/dirac.x
# python binary_info.py  > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,OWNMATH,OpenMPI 1.10.1,static - finished at $timestamp \n"
sleep 10


#################################
##                             ##
##  OPENMPI GNU+MKL STATIC     ##
##                             ##
#################################
timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n Starting build - GNU,i8,MKL,OpenMPI 1.10.1,static - at $timestamp \n"

# My own OpenMPI GNU static
unset PATH
export PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin:$PATH_SAVED
unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ilias/bin/openmpi-1.10.1_gnu_static/lib:$LD_LIBRARY_PATH_SAVED

cd $DIRAC
BUILD_OMPI_GNU5=build_openmpi_gnu_mkl_static
if [[ -d "$BUILD_OMPI_GNU5" ]]; then
   echo "removing previous build directory $BUILD_OMPI_GNU5"
  /bin/rm -rf $BUILD_OMPI_GNU5
fi
#
python ./setup --mpi  --fc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpif90  --cc=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicc --cxx=/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpicxx --static --cmake-options="-D BUILDNAME='grid_savba_ompi_gnu_mkl_i8_STATIC' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BUILTIN_BLAS=OFF -D ENABLE_BUILTIN_LAPACK=OFF -D ENABLE_PCMSOLVER=ON -D ENABLE_STIELTJES=OFF -D MATH_LIB_SEARCH_ORDER='MKL' " --int64   $BUILD_OMPI_GNU5
 cd $BUILD_OMPI_GNU5
 ctest -D ExperimentalUpdate     
 ctest -D ExperimentalConfigure  
 ctest -j4 -D ExperimentalBuild  
 unset DIRAC_MPI_COMMAND
 export DIRAC_MPI_COMMAND="/home/ilias/bin/openmpi-1.10.1_gnu_static/bin/mpirun -np 2"
 ctest -j2 -D ExperimentalTest -R cosci_energy    
 ctest -D ExperimentalSubmit  
#
# copy there related OpenMPI directories
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/bin            $DIRAC/$BUILD_OMPI_GNU5/.
cp  -R  /home/ilias/bin/openmpi-1.10.1_gnu_static/lib            $DIRAC/$BUILD_OMPI_GNU5/.
/bin/rm -rf $DIRAC/$BUILD_OMPI_GNU5/share
mkdir $DIRAC/$BUILD_OMPI_GNU5/share
cp -R -P  /home/ilias/bin/openmpi-1.10.1_gnu_static/share/openmpi     $DIRAC/$BUILD_OMPI_GNU5/share/.
cp -R     /home/ilias/bin/openmpi-1.10.1_gnu_static/etc               $DIRAC/$BUILD_OMPI_GNU5/.
#
# don't forget export OPAL_PREFIX=$PWD/$BUILD  !
#

 ls -lt $DIRAC/$BUILD_OMPI_GNU5/dirac.x
 ldd $DIRAC/$BUILD_OMPI_GNU5/dirac.x
# python binary_info.py  > VERSION_cmake  2>&1  # get version

timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
echo -e "\n build - GNU,i8,MKL,OpenMPI 1.10.1,static - finished at $timestamp \n"
sleep 10


#################################################
### continue with the packing for grid servers ##
#################################################

# create the reduced tar-file containing all important stuff ...
cd $DIRAC

echo -e "\n removing: /bin/rm    test/*/*.out; /bin/rm -r test/*/compare "
# problems with "--exclude test/*/*.out"  - so remove them as such
/bin/rm    test/*/*.out
/bin/rm -r test/*/compare

packed_dirac=DIRAC4Grid_suite.tgz
##
echo -e "\n\n Packing slim DIRAC suite (static dirac.x binaries, basis sets and test suite) for grid computations ! \n"
##     
#
# No empty lines between tar command parameters(lines) !
#
##
tar czf $packed_dirac  test  basis  basis_dalton  basis_ecp \
$BUILD_OMPI_INTEL/dirac.x     $BUILD_OMPI_INTEL/pam  $BUILD_OMPI_INTEL/etc  $BUILD_OMPI_INTEL/share  $BUILD_OMPI_INTEL/bin  $BUILD_OMPI_INTEL/lib   \
$BUILD_OMPI_INTEL1/dirac.x    $BUILD_OMPI_INTEL1/pam $BUILD_OMPI_INTEL1/etc $BUILD_OMPI_INTEL1/share $BUILD_OMPI_INTEL1/bin  $BUILD_OMPI_INTEL1/lib  \
$BUILD_OMPI_INTEL2/dirac.x    $BUILD_OMPI_INTEL2/pam $BUILD_OMPI_INTEL2/etc $BUILD_OMPI_INTEL2/share $BUILD_OMPI_INTEL2/bin  $BUILD_OMPI_INTEL2/lib  \
$BUILD_SERIAL_INTEL/dirac.x   $BUILD_SERIAL_INTEL/pam   \
$BUILD_SERIAL_INTEL1/dirac.x  $BUILD_SERIAL_INTEL1/pam  \
$BUILD_SERIAL_INTEL2/dirac.x  $BUILD_SERIAL_INTEL2/pam  \
$BUILD_SERIAL_GNU/dirac.x     $BUILD_SERIAL_GNU/pam    \
$BUILD_SERIAL_GNU1/dirac.x    $BUILD_SERIAL_GNU1/pam  \
$BUILD_SERIAL_GNU2/dirac.x    $BUILD_SERIAL_GNU2/pam  \
$BUILD_OMPI_GNU3/dirac.x      $BUILD_OMPI_GNU3/pam  $BUILD_OMPI_GNU3/etc  $BUILD_OMPI_GNU3/share  $BUILD_OMPI_GNU3/bin  $BUILD_OMPI_GNU3/lib  \
$BUILD_OMPI_GNU4/dirac.x      $BUILD_OMPI_GNU4/pam  $BUILD_OMPI_GNU4/etc  $BUILD_OMPI_GNU4/share  $BUILD_OMPI_GNU4/bin  $BUILD_OMPI_GNU4/lib  \
$BUILD_OMPI_GNU5/dirac.x      $BUILD_OMPI_GNU5/pam  $BUILD_OMPI_GNU5/etc  $BUILD_OMPI_GNU5/share  $BUILD_OMPI_GNU5/bin  $BUILD_OMPI_GNU5/lib  \
$BUILD_PGI/dirac.x $BUILD_PGI/pam   \
$BUILD_PGI1/dirac.x $BUILD_PGI1/pam \
$BUILD_PGI2/dirac.x $BUILD_PGI2/pam \
$BUILD_PGI3/dirac.x $BUILD_PGI3/pam 

echo -e "\n DIRAC-for-grid packing done, we have tar-ball file ready to be placed on SE for grid-computing : "
ls -lt $packed_dirac
echo -e "\n Done. Tarball with static execs is ready."

# exit here, don't do other stuff
echo -e "\n Leaving here, you will have to upload the tarball manually onto your SE."
exit 0

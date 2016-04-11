@echo off

rem Testing script for Cygwin which can be (directly) run from Windows Task Scheduler
rem /home/milias/test directory must exist before script is run
rem /home/milias/cdash-testing.log file contains log from previous run
rem this script can be placed everywhere you want and does not need any arguments

rem initialize the cygserver (important for DIRAC parallel runs)
cd C:\cygwin64\bin
cygstart.exe  --action=runas  C:\cygwin64\usr\sbin\cygserver.exe

rem unset PUTTYs environment variable (it makes problems to Cygwin git)
set GIT_SSH=

rem set CDash project
set CTEST_PROJECT_NAME=DIRACext

rem delete old /home/milias/cdash-testing.log
C:\cygwin64\bin\sh --login -c "rm -f /home/milias/cdash-testing.log"

rem delete previously downloaded sources and old builds
C:\cygwin64\bin\sh --login -c "(echo -e \" deleting sources..\" && rm -rf /home/milias/test/trunk_cloned) 2>&1 | tee -a /home/milias/cdash-testing.log"

rem clone sources from gitlab
C:\cygwin64\bin\sh --login -c "(echo -e \"\n cloning sources..\" && cd /home/milias/test && git clone --recursive git@gitlab.com:dirac/dirac.git trunk_cloned) 2>&1 | tee -a /home/milias/cdash-testing.log"

rem update submodules
C:\cygwin64\bin\sh --login -c "(echo -e \"\n updating submodules..\" && cd /home/milias/test/trunk_cloned && git submodule update --init --recursive) 2>&1 | tee -a /home/milias/cdash-testing.log" 

rem configure setup : 64-bit with Open MPI and OpenBLAS (builtin Lapack)
rem define ZLIB_ROOT to find correct zlib library
rem compiled Boost for Cygwin is installed in /cygdrive/c/libraries/Cygwin_Boost (C:\libraries\Cygwin_Boost)
rem CMAKE_LEGACY_CYGWIN_WIN32=0 to accept that Cygwin is not WIN32
C:\cygwin64\bin\sh --login -c "(echo -e \"\n running setup..\" && cd /home/milias/test/trunk_cloned && python setup  --int64 --mpi --cc=mpicc --cxx=mpicxx --fc=mpifort --cmake-options="-D CMAKE_LEGACY_CYGWIN_WIN32=0 -D BUILDNAME=\'WinS12-cygwin-i8-openmpi-openblas\' -D BOOST_INCLUDEDIR=/cygdrive/c/libraries/Cygwin_Boost/include/ -D BOOST_LIBRARYDIR=/cygdrive/c/libraries/Cygwin_Boost/lib/ -D ZLIB_ROOT=/usr/lib -D ENABLE_BUILTIN_LAPACK=ON" --blas=off --lapack=off --explicit-libs=/usr/bin/cygblas-0.dll build) 2>&1 | tee -a /home/milias/cdash-testing.log"

rem export DIRAC_MPI_COMMAND, export OPENBLAS_NUM_THREADS and configure, build, test and submit in one command
C:\cygwin64\bin\sh --login -c "(echo -e \"\n Experimental..\" && export DIRAC_MPI_COMMAND=\"mpirun -np 2\" && export OPENBLAS_NUM_THREADS=3 && cd /home/milias/test/trunk_cloned/build && ctest -j 2 -D Experimental) 2>&1 | tee -a /home/milias/cdash-testing.log"

rem wait for user input to close this terminal window
rem pause

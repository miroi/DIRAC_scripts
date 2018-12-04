@ECHO OFF
cls

rem set proxy
set HTTP_PROXY=http://194.160.44.44:3128

rem set number of threads for OpenBLAS
rem 24GB RAM,8 CPU
set OPENBLAS_NUM_THREADS=2

rem source files directories
set DIRAC=C:\Users\milias\Documents\work\software\dirac\trunk
set TMP=C:\Users\milias\Documents\work\software\dirac

rem set LOG file and testing timeout
set LOG=%DIRAC%\buildup.log
set DIRTIMEOUT="12m"

set CTEST_PROJECT_NAME=DIRACext

rem REMOVE THIS LINES?
rem "C:\Program Files (x86)\PuTTY\pageant.exe" "C:\Users\milias\Documents\milias_private_key.ppk"
rem try plink command to activate agent
rem "C:\Program Files (x86)\PuTTY\plink.exe" -agent git@gitlab.com
rem "C:\Program Files (x86)\PuTTY\plink.exe" -i "C:\Users\milias\Documents\milias_private_key.ppk" git@repo.ctcc.no
rem "C:\Program Files (x86)\PuTTY\plink.exe"  -v  -pgpfp

rem write timestamp as the first entry into the empty log file
echo %DATE% %TIME% 1>%LOG% 2>&1

rem test connection on native Windows
rem "C:\Program Files (x86)\PuTTY\plink.exe" -agent git@gitlab.com 1>>%LOG% 2>&1
"C:\Program Files\PuTTY\plink.exe" -agent git@gitlab.com 1>>%LOG% 2>&1

rem go to the local DIRAC directory
cd %DIRAC%
git clean -f -d -x
git submodule update --init --recursive
set BUILD=build_mingw64_i8_tests
if exist %BUILD% rmdir /S /Q %BUILD%
python setup --int64  --blas=off --lapack=off ^
 --explicit-libs="C:/libraries/OpenBLAS/OpenBLAS-v0.2.14-Win64-int64/bin/libopenblas.dll" ^
 --cmake-options="-D ZLIB_ROOT='C:\libraries\zlib' -D BOOST_INCLUDEDIR='C:\libraries\Boost\include' -D BOOST_LIBRARYDIR='C:\libraries\Boost\lib' -D BUILDNAME='WinS12_MinGW64_i8_OpenBLAS_parallel' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BENCHMARKS=OFF -D ENABLE_TUTORIALS=ON -D ENABLE_UNIT_TESTS=ON -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D ENABLE_BUILTIN_LAPACK=ON" ^
 --generator="MinGW Makefiles" %BUILD% 1>>%LOG% 2>&1
cd %BUILD%
ctest      -D ExperimentalUpdate       1>>%LOG%  2>&1
ctest      -D ExperimentalConfigure    1>>%LOG%  2>&1
ctest -j 8 -D ExperimentalBuild        1>>%LOG%  2>&1
rem no tests here ! do only the compilation, tests are running in following buildup
ctest -j 4 -D ExperimentalTest  -R cosci_energy dft   1>>%LOG%  2>&1
ctest      -D ExperimentalSubmit       1>>%LOG%  2>&1

rem write timestamp
echo %DATE% %TIME% 1>>%LOG% 2>&1

rem wait 20 seconds
rem timeout 20

rem write timestamp
echo %DATE% %TIME% 1>>%LOG% 2>&1

cd %TMP%
set CTEST_PROJECT_NAME=DIRAC
set CLONED=trunk_cloned
if exist %CLONED% rmdir /S /Q %CLONED% 1>>%LOG% 2>&1
git clone --recursive git@gitlab.com:dirac/dirac.git %CLONED% 1>>%LOG% 2>&1
cd %CLONED%
git config --global http.proxy http://194.160.44.44:3128
git submodule update --init --recursive
set BUILD=build_mingw64_i8_tests_rtcheck
if exist %BUILD% rmdir /S /Q %BUILD%
rem split setup command line
python setup --check --int64 --blas=off --lapack=off ^
 --explicit-libs="C:/libraries/OpenBLAS/OpenBLAS-v0.2.14-Win64-int64/bin/libopenblas.dll" ^
 --cmake-options="-D ZLIB_ROOT='C:\libraries\zlib' -D BOOST_INCLUDEDIR='C:\libraries\Boost\include' -D BOOST_LIBRARYDIR='C:\libraries\Boost\lib' -D BUILDNAME='WinS12_MinGW64_i8_OpenBLAS_parallel_cloned' -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BENCHMARKS=OFF -D ENABLE_TUTORIALS=ON -D ENABLE_UNIT_TESTS=ON -D ENABLE_PCMSOLVER=OFF -D ENABLE_STIELTJES=OFF -D ENABLE_BUILTIN_LAPACK=ON" ^
 --generator="MinGW Makefiles" %BUILD% 1>>%LOG% 2>&1
cd %BUILD%
rem ctest      -D NightlyConfigure  --track Miro  1>>%LOG%  2>&1
rem ctest -j 8 -D NightlyBuild      --track Miro  1>>%LOG%  2>&1
rem ctest -j 4 -D NightlyTest       --track Miro  1>>%LOG%  2>&1
rem ctest      -D NightlySubmit     --track Miro  1>>%LOG%  2>&1
rem use one compact command
ctest -j 4 -D Nightly  --track master  1>>%LOG%  2>&1

rem write timestamp
echo %DATE% %TIME% 1>>%LOG% 2>&1

rem POWEROFF OPTIONS
rem turn the hibernation off
rem powercfg -h off
rem make the computer sleep 
rem rundll32.exe powrprof.dll,SetSuspendState 0,1,0
rem kill the pageant task
rem taskkill /f /im pageant.exe
rem switch off Desktop PC Windows after 10 seconds
rem shutdown /s /t 10
rem restart PC
rem shutdown /r

rem wait 1 minute
rem timeout 60 

rem close this cmd window
exit

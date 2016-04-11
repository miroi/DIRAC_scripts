@ECHO OFF
cls

set DIRAC=C:\Users\milias\Documents\Dirac\software\devel_trunk

set LOG=%DIRAC%\buildup.log
set DIRTIMEOUT="14m"


rem "C:\Program Files (x86)\PuTTY\pageant.exe" "C:\Users\milias\Documents\milias_private_key.ppk"
rem try plink command to activate agent

rem "C:\Program Files (x86)\PuTTY\plink.exe" -agent git@repo.ctcc.no
rem "C:\Program Files (x86)\PuTTY\plink.exe" -i "C:\Users\milias\Documents\milias_private_key.ppk" git@repo.ctcc.no
rem "C:\Program Files (x86)\PuTTY\plink.exe"  -v  -pgpfp

rem go to the local DIRAC directory
cd %DIRAC%

rem download fresh Dirac
rem C:\Git\bin\git.exe pull origin master

echo %DATE% %TIME% 1>  %LOG%  2>&1
git --version  1>>  %LOG%  2>&1
rem git status
rem echo Exit Code of git status is %errorlevel%
git ls-remote 1>>  %LOG%  2>&1

rem fetch to origin master
rem git fetch origin master

rem git pull origin master

rem update all submodules
git submodule update  1>>  %LOG%  2>&1
git submodule status  1>>  %LOG%  2>&1

set BUILD=build_mingw64_i4
if exist %BUILD% rmdir /S /Q %BUILD%
python setup -D BUILDNAME="Win8.0_MinGW64_i4" -D DART_TESTING_TIMEOUT=99999 --generator="MinGW Makefiles" %BUILD%  1>>  %LOG%  2>&1
cd %BUILD%
ctest     -D ExperimentalUpdate     --track Miro  1>>  %LOG%  2>&1
rem echo Exit Code is %errorlevel%
ctest     -D ExperimentalConfigure  --track Miro  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalBuild      --track Miro  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalTest       --track Miro  1>>  %LOG%  2>&1
ctest     -D ExperimentalSubmit     --track Miro  1>>  %LOG%  2>&1

rem wait 1 minute
timeout 60

echo "************************************************"  1>>  %LOG%  2>&1
echo %DATE% %TIME%   1>>  %LOG%  2>&1

rem try git pull
rem git pull --verbose
rem echo Exit Code is %errorlevel%

rem go to the local DIRAC directory
cd %DIRAC%

rem git status
rem echo Exit Code is %errorlevel%

set BUILD=build_mingw64_i8_check
if exist %BUILD% rmdir /S /Q %BUILD%
python setup -D BUILDNAME="Win8.0_MinGW64_i8_check" --check --int64 -D DART_TESTING_TIMEOUT=99999 --generator="MinGW Makefiles" %BUILD%  1>>  %LOG%  2>&1
cd %BUILD%
rem --track BoundsCheck does not work, use track Miro
ctest     -D ExperimentalUpdate     --track BoundsCheck  1>>  %LOG%  2>&1
ctest     -D ExperimentalConfigure  --track BoundsCheck  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalBuild      --track BoundsCheck  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalTest       --track BoundsCheck  1>>  %LOG%  2>&1
ctest     -D ExperimentalSubmit     --track BoundsCheck  1>>  %LOG%  2>&1

rem try agaain....
timeout 20
ctest     -D ExperimentalSubmit     --track BoundsCheck  1>>  %LOG%  2>&1

rem wait 1 minute
timeout 60

echo "*********************"  1>>  %LOG%  2>&1
echo %DATE% %TIME%  1>>  %LOG%  2>&1

rem check ...
rem "C:\Program Files (x86)\PuTTY\plink.exe"  -v  -pgpfp

rem go to the local DIRAC directory
cd %DIRAC%
set BUILD=build_mingw64_i8
if exist %BUILD% rmdir /S /Q %BUILD%
python setup -D BUILDNAME="Win8.0_MinGW64_i8" --int64 -D DART_TESTING_TIMEOUT=99999 -D ENABLE_BENCHMARKS=OFF -D ENABLE_TUTORIALS=ON --generator="MinGW Makefiles" %BUILD%  1>>  %LOG%  2>&1
cd %BUILD%
ctest     -D ExperimentalUpdate     --track Miro  1>>  %LOG%  2>&1
ctest     -D ExperimentalConfigure  --track Miro  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalBuild      --track Miro  1>>  %LOG%  2>&1
ctest -j2 -D ExperimentalTest       --track Miro  1>>  %LOG%  2>&1
ctest     -D ExperimentalSubmit     --track Miro  1>>  %LOG%  2>&1

echo %DATE% %TIME%  1>>  %LOG%  2>&1

rem wait 3 minutes
timeout 180

rem   turn the hibernation off
powercfg -h off

rem  make the computer sleep 
rem rundll32.exe powrprof.dll,SetSuspendState 0,1,0

rem kill the pageant task
rem taskkill /f /im pageant.exe

rem switch off Desktop PC Windows after 10 seconds
rem timeout 10 && shutdown -s

rem - restart PC
shutdown /r

exit


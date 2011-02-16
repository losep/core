@ECHO %DEBUG% OFF
if NOT "%DEBUG%"=="" @ECHO ON
if "%~1"=="" GOTO USAGE
if "%~1"=="/D" (shift&goto set_d)

:set_e
if "%~1"=="+" (set _a_exe=1&shift)
if "%~1"=="" GOTO USAGE
if "%_a_exe%"=="1" (set _a_exe=%FS_SYSTEM_APP%\%~1) else (set _a_exe=%1);
shift
goto run

:set_d
if "%~1"=="" GOTO USAGE
if "%~1"=="+" (set _a_dir=1&shift)
if "%~1"=="" GOTO USAGE
if "%_a_dir%"=="1" (set _a_dir=%FS_SYSTEM_APP%\%~1) else (set _a_dir=%1)
shift
if "%~1"=="" GOTO USAGE
goto set_e

:run
if NOT "%_a_dir%"=="" goto run_d
echo start %_a_exe% %1 %2 %3 %4 %5 %6 %7 %8 %9
IF "%DEBUG%"=="" start "start" "%_a_exe%" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto end
:run_d
echo start /D %_a_dir% %_a_exe% %1 %2 %3 %4 %5 %6 %7 %8 %9
IF "%DEBUG%"=="" start "start" /D "%_a_dir%" "%_a_exe%" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto end


:Usage
echo apprund
echo      - Start program in specified directory
echo  Usage:
echo        apprund [/D [+] directory] [+] executable_name
echo  Options:
echo        /D directory    :   directory to start
echo        +               :   prefix a FS_APP on the path
echo        executable_name :   path of program
goto end

:end
set _a_dir=
set _a_exe=

@echo off
SET XRZ_PSDK_DIR=%FS_ROOT%\Program\Develop\Platform SDK\
set XRZ_PSDK_WIN7=%XRZ_PSDK_DIR%Windows7\
set XRZ_PSDK_2003R2=%XRZ_PSDK_DIR%Server2003R2\
set XRZ_PSDK_FEB2003=%XRZ_PSDK_DIR%FEB2003\

set XRZ_PSDK=%XRZ_PSDK_WIN7%

if /i "%1"=="WIN7" SET XRZ_PSDK=%XRZ_PSDK_WIN7%
if /i "%1"=="2003R2" SET XRZ_PSDK=%XRZ_PSDK_2003R2%
if /i "%1"=="FEB2003" SET XRZ_PSDK=%XRZ_PSDK_FEB2003%

IF EXIST %FS_ROOT%\program\commands\pathadd.bat (
    call %~dp0\env_tool.bat PATH -p -/ "%XRZ_PSDK%bin"
    call "%~dp0\env_tool.bat" INCLUDE -p -/ "%XRZ_PSDK%Include;%XRZ_PSDK%Include\crt;%XRZ_PSDK%Include\atl;%XRZ_PSDK%Include\mfc"
    call "%~dp0\env_tool.bat" LIB -p -/ "%XRZ_PSDK%lib;%XRZ_PSDK%lib\crt;%XRZ_PSDK%lib\atl;%XRZ_PSDK%lib\mfc"
) else (
    SET PATH=%XRZ_PSDK%bin;%PATH%
    SET INCLUDE=%XRZ_PSDK%Include;%XRZ_PSDK%Include\crt;%XRZ_PSDK%Include\atl;%XRZ_PSDK%Include\mfc;%INCLUDE%
    set LIB=%XRZ_PSDK%lib;%XRZ_PSDK%lib\crt;%XRZ_PSDK%lib\atl;%XRZ_PSDK%lib\mfc;%LIB%
)
echo _____________________XRZ_PSDK___________________
echo %XRZ_PSDK%
echo ________________________PATH____________________
echo %PATH%
echo ______________________INCLUDE___________________
echo %INCLUDE%
echo ______________________LIB_______________________
echo %LIB%
echo ________________________________________________

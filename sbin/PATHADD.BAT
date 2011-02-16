@ECHO OFF
if ""=="%~1" goto end
if "-h"=="%~1" goto Usage
goto doit
:Usage
echo %0 [option] PATH_VARIBLE
echo - simple batch util for modifing PATH
echo    default to prefixing mode
echo    -a    Appending Mode
echo    -n    Replacing Mode
echo    -p    Prefix Mode
echo	-d    Delete Mode
goto end
:doit
call "%~dp0\env_tool.bat" PATH -\ %*
:end

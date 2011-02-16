@ECHO OFF
call "%~dp0setenv_vc6.bat"
call "%~dp0setenv_sdk.bat" FEB2003
start "MSDEV" "%FS_ROOT%\Program\Develop\Visual Studio 6.0\COMMON\MSDEV98\BIN\MSDEV.EXE" 

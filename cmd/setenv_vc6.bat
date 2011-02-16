@echo off
set _tmp=%FS_ROOT%\Program\Develop\Visual Studio 6.0
if not exist "%_tmp%\Common\msdev98\bin\msdev.exe" goto error

echo Setting environment for Microsoft VisualStudio 6.0 

set VSCommonDir=%_tmp%\Common
set MSDevDir=%_tmp%\Common\MSDev98
set MSVcDir=%_tmp%\VC98
set VcOsDir=WIN95
if "%OS%" == "Windows_NT" set VcOsDir=WINNT

if "%OS%" == "Windows_NT" (
	call %~dp0env_tool.bat PATH -p -\ "%MSDevDir%\BIN;%MSVCDir%\BIN;%VSCommonDir%\TOOLS\%VcOsDir%;%VSCommonDir%\TOOLS"
	call %~dp0env_tool.bat INCLUDE -p -\ "%MSVCDir%\ATL\INCLUDE;%MSVCDir%\INCLUDE;%MSVCDir%\MFC\INCLUDE"
	call %~dp0env_tool.bat LIB -p -\ "%MSVCDir%\LIB;%MSVCDir%\MFC\LIB;%MSVCDIR%\ATL\LIB"
) else (
	 set PATH="%MSDevDir%\BIN";"%MSVCDir%\BIN";"%VSCommonDir%\TOOLS\%VcOsDir%";"%VSCommonDir%\TOOLS";"%windir%\SYSTEM";"%PATH%"
	set INCLUDE=%MSVCDir%\ATL\INCLUDE;%MSVCDir%\INCLUDE;%MSVCDir%\MFC\INCLUDE;
	set LIB=%MSVCDir%\LIB;%MSVCDir%\MFC\LIB;%LIB%
)

goto end

:error
echo Error, File not exists: "%_tmp%\Common\msdev98\bin\msdev.exe"
goto end

:end
set _tmp=
set VcOsDir=
set VSCommonDir=
echo ________________________PATH____________________
echo %PATH%
echo ______________________INCLUDE___________________
echo %INCLUDE%
echo _______________________LIB______________________
echo %LIB%
echo ________________________________________________



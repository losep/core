@ECHO OFF
set PDIR=%FS_ROOT%\Program\Develop
:set_tasm
for /F "delims=;" %%i in ("%PATH%") do (
    if "%%i"=="%PDIR%\TASM\BIN" goto set_bc
)
echo Setup Borland Tasm Environment
set PATH=%PDIR%\TASM\BIN;%PATH%

:set_bc
for /F "delims=;" %%i in ("%PATH%") do (
    if "%%i"=="%PDIR%\BC45\BIN" goto no_reset
)
echo Setup Borland C++ Environment
set PATH=%PDIR%\BC45\BIN;%PATH%
goto :eof

:no_reset
echo Borland Development Environment had already setuped.
goto :eof


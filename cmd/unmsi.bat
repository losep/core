@ECHO OFF
setlocal
if ""=="%~1" goto usage
set msifile=%~1
set outdir=%~2
if ""=="%outdir%" set outdir=%CD%\%~n1
echo msiexec /a "%msifile%" /qb TARGETDIR="%outdir%"
start msiexec /a "%msifile%" /qb TARGETDIR="%outdir%"
goto end

:usage
echo %0 - v1.0
echo Usage:
echo   %0 msifile [outdir]
echo.
:end



@echo %DEBUG% off
SETLOCAL

:getopt_s
if "%1"=="" goto getopt_e
if "%1"=="-h" goto usage_s
if "%1"=="-x" (set opt=x& shift & goto getopt_s)
if "%1"=="-c" (set opt=c& shift & goto getopt_s)
if "%1"=="-z" (set ext=gz& shift & goto getopt_s)
if "%1"=="-j" (set ext=bz2& shift & goto getopt_s)
if "%1"=="-7" (set ext=7z& shift & goto getopt_s)
:getopt_e

if "%1"=="" goto usage_s
if "%ext%"=="" set ext=gz
if "%opt%"=="x" goto x_s
goto c_s

:usage_s
echo tgz [options] (directory or file)
echo Options:
echo    -h      Display this
echo    -x      Decompress
echo    -c      Compress
echo    -z      Pipe to gzip
echo    -j      Pipe to bzip2
echo    -7      Pipe to 7zip
echo.
:usage_e
goto end

:x_s
set compress=gzip
if "%ext%"=="bz2" set compress=bzip2
if "%ext%"=="7z" set compress=7zipa
echo %compress% -v -d -c %1 %2 %3 %4 %5 %6 %7 %8 %9
echo --- tar -xv
%compress% -d -c %1 %2 %3 %4 %5 %6 %7 %8 %9 | tar -xv
:x_e
goto end

:c_s
set compress=gzip
if "%ext%"=="bz2" set compress=bzip2
if "%ext%"=="7z" set compress=7zipa
echo tar -cv %1 %2 %3 %4 %5 %6 %7 %8 %9
echo --- %compress% -9 STDOUT_TO %1.tar.%ext%
tar -cv %1 %2 %3 %4 %5 %6 %7 %8 %9 | %compress% -v -9>%1.tar.%ext%
:c_e
goto end

:end


@echo off
setlocal
set name=svn-win32-1.6.6
set url=http://subversion.tigris.org/files/documents/15/47914/%name%.zip
set src=%FS_ROOT%\tmp
set dst=%FS_CORE_APP%
if exist %dst%\svn\bin\NUL goto ok1
if exist "%src%\%name%.zip" goto setup

echo Downloading %name%
call wget --verbose --progress bar -O "%src%\%name%.zip" "%url%"
if exist "%src%\%name%.zip" goto setup
goto fail_down

:setup
cd "%dst%"
call 7z x -tzip "%src%\%name%.zip"
if exist %name%\NUL goto ok
echo failed seting up %name%
del "%src%\%name%.zip"
goto end

:fail_down
echo failed downloading %name%!
goto end

:ok1
echo Subversion already setup at %dst%\svn
goto end

:ok
echo rename %name% as svn
move %name% svn
echo add %dst%\svn\bin to PATH
echo %name% setup at %dst%\SVN
endlocal
set PATH=%FS_CORE_APP%\svn\bin;%PATH%

goto end

:end
endlocal
:end2

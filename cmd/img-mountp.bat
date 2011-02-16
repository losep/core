@ECHO OFF
if X == X%1 goto Usage
if X == X%2 goto no2

imdisk -a -m a: -f %1 -v %2
goto end

:no2
imdisk -a -m a: -f %1 -v 1
goto end

:usage
echo %0 - Mount disk image
echo Usage: %0 (filename) [partition num]

:end

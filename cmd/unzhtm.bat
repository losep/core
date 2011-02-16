@echo off
if X%1==X goto end
set zipfile=%~1
set dstdir=%~p1%~n1
if not exist "%zipfile%" goto end
call unzip.exe -q "%zipfile%" -d %dstdir%
echo %zipfile% unziped in %dstdir%.
if not exist "%dstdir%" goto end
call attrib -h -s -r "%zipfile%"
call del "%zipfile%"
echo %zipfile% deleted.
:end

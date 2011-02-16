@ECHO OFF
if X == X%1 goto usage
:rar
rar a -m5 -r -ep1 %~n1.rar %1\*.*
shift
if X == X%1 goto end
goto rar
goto end
:usage
echo %0 directory
:end


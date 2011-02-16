@echo off
if "x%1"=="x" goto END
echo gcc -o%~n1.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
gcc -o%~n1.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
call %~n1.exe
del %~n1.exe
:END
 

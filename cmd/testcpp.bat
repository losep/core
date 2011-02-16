@echo off
if "X%*"=="X" (
if NOT "X%TESTCPP%"=="X" testcpp %TESTCPP%
GOTO BATEND)
SET TESTCPP=%*
set pname=%~n1.exe
cl /O2 /Og /G6 /GX /nologo %* /o"%pname%"
echo output of %pname%:
echo ====================================================
call "%pname%"
echo ====================================================
del "%pname%"
:BATEND
@echo on

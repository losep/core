@ECHO OFF
set sysd=C:\windows\system32

:next
if "X" == "X%~1" goto end 
set full=%~1
set base=%~nx1
if not exist "%sysd%\%base%" copy "%full%" "%sysd%\%base%"
regsvr32 "%sysd%\%base%"
shift
goto next

:end


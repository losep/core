@ECHO OFF
if "%1"=="" GOTO NO_DEF
echo start "Google Chrome" "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" --user-data-dir="%FS_ROOT%\APPDATA\googlechrome\%~1" %2 %3 %4 %5 %6 %7 %8 %9 
start "Google Chrome" "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" --user-data-dir="%FS_ROOT%\APPDATA\googlechrome\%~1" %2 %3 %4 %5 %6 %7 %8 %9 
goto end

:NO_DEF
start "Google Chrome" "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" 

:end


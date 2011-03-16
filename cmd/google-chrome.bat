@ECHO OFF
setlocal

IF NOT "%LOCALAPPDATA%" == "" (
	SET chrome_dir=%LOCALAPPDATA%\Google\Chrome
) ELSE (
	SET chrome_dir=%USERPROFILE%\Local Settings\Application Data\Google\Chrome
)	

if "%1"=="" GOTO NO_DEF
echo start "Google Chrome" "%chrome_dir%\Application\chrome.exe" --user-data-dir="%FS_ROOT%\APPDATA\googlechrome\%~1" %2 %3 %4 %5 %6 %7 %8 %9 
start "Google Chrome" "%chrome_dir%\Application\chrome.exe" --user-data-dir="%FS_ROOT%\APPDATA\googlechrome\%~1" %2 %3 %4 %5 %6 %7 %8 %9 
goto end

:NO_DEF
start "Google Chrome" "%chrome_dir%\Application\chrome.exe" 


:end
endlocal

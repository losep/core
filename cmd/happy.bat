@ECHO %DEBUG% OFF
setlocal
set gs=
if ""=="%1" set gs=
if "800"=="%1" set gs=800x600.ini
if "1024"=="%1" set gs=1024x768.ini
if "600"=="%1" set gs=600x480.ini

if ""=="%gs%" goto _start
copy /y "%FS_ROOT%\games\happyonline\ini\%gs%" "%FS_ROOT%\games\happyonline\ini\GameSetup.ini"

:_start

start "happyonline" /d "%FS_ROOT%\Games\happyonline\" "%FS_ROOT%\Games\happyonline\happypets.exe" blacknull

set gs=
endlocal

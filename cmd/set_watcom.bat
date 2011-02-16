@ECHO OFF
if  NOT "%WATCOM%"=="" GOTO DONE
set PATH=%FS_APP%\develop\watcom\BINNT;%FS_APP%\develop\watcom\BINW;%PATH%
:DONE
set INCLUDE=%FS_APP%\develop\watcom\H;%FS_APP%\develop\watcom\H\NT
set WATCOM=%FS_APP%\develop\watcom
set EDPATH=%FS_APP%\develop\watcom\EDDAT
set WWINHELP=%FS_APP%\develop\watcom\BINW
echo Open Watcom Environment setuped



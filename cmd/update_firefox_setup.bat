@echo off
setlocal
set latest=3.6.13
set host=http://releases.mozilla.org/pub/mozilla.org/firefox/releases/latest/win32/en-US
set url=%host%/Firefox Setup %latest%.exe
echo updating firefox/firefox_setup.exe
echo wget -O %FS_CORE_APP%/firefox/firefox_setup.exe "%url%"
wget -O %FS_CORE_APP%/firefox/firefox_setup.exe "%url%"

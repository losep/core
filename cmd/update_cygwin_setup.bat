@echo off
echo updating cygwin/setup.exe
echo wget --verbose --progress bar -O %FS_CORE_APP%\CYGWIN\setup.exe http://www.cygwin.com/setup.exe
wget --verbose --progress bar -O %FS_CORE_APP%\CYGWIN\setup.exe http://www.cygwin.com/setup.exe

@echo off
if not exist %FS_APP%\develop\svn\NUL goto _END
SET SVN_EDITOR=vim
set NEWPATH=%FS_APP%\develop\svn\bin;%NEWPATH%
:_END
@echo off
if not exist %FS_APP%\DEVELOP\StrawberryPerl\NUL goto _END
SET PERL_DIR=%FS_APP%\DEVELOP\StrawberryPerl
set NEWPATH=%NEWPATH%;%PERL_DIR%\c\bin;%PERL_DIR%\perl\bin
:_END
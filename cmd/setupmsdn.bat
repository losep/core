@ECHO ON
set MSDN=%FS_ROOT%\document\programming\windows\msdn
set MSDNSTR=%FS_ROOT%\\document\\programming\\windows\\msdn
pushd %MSDN%\2001OCT\1033\setup
copy /y setup_tmpl.stf setup.stf
sed -i -e "s#XIAORANZZZ_MSDN_DIR#%MSDNSTR%#g" setup.stf
start setup.exe
:eof
popd

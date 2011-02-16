@ECHO OFF
call if_dir_in_path.bat "%FS_APP%\develop\FreeBasic"
if errorlevel 1 goto _set
if errorlevel 0  goto _adone
:_set
set PATH=%FS_APP%\develop\FreeBasic;%PATH%
goto _done

:_adone
echo Freebasic environment already setuped.
goto end

:_done
echo Freebasic environment setup OK.
goto end

:end

@ECHO OFF
qemudos -fda %FS_ROOT%\system\boot\xrdos.img -hda fat::%TEMP%\XRTEMP -boot a

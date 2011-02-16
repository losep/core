@ECHO OFF
for %%i in (%*) do (
    unzip.exe -u -n "%%~i"
)

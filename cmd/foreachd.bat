@ECHO OFF
for /d %%d in (*) do (
    pushd "%%~d"
    %*
    popd
)

rem  设置命令行不回显
@echo off

rem 设置winrar的路径，修改为你安装的路径。
rem 并可以后面加上参数。如-afrar或-afzip等。具体参考winrar的帮助。
set winrar="C:\Program Files\Winrar\winrar.exe" A -afzip

echo "Start....."

rem 批量操作目录
for /d %%i in (*) do call %winrar% "%%i" "%%i"

rem 取消环境变量
set winrar=

echo "Done."

rem 关闭控制台
exit 0
if X%1==X goto zhcEND
set name=%~nx1
set zh="%temp%\zh.ini"
if Exist %zh% del %zh% /q
echo [Info]>>%zh%
echo Title=%name%>>%zh%
echo Author=>>%zh%
echo Date=%date%>>%zh%
echo Publisher=%username%>>%zh%
echo Catalog=>>%zh%
if exist %name%\index.htm set ff=%name%\index.htm
if exist %name%\index.html set ff=%name%\index.html
echo DefaultFile=%ff%>>%zh%
echo HHCfile=none>>%zh%
echo ContentFile=>>%zh%
echo [Style]>>%zh%
echo ShowLeft=0 >>%zh%
echo ShowMenu=0 >>%zh%
echo ShowStatusBar=0 >>%zh%
echo zhComment file %%temp%%\zh.ini" for "%name%" generated.
:zhcEND

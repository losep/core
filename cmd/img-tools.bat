@ECHO OFF
for %%i in (attrib badblocks  cat  cd  classerase  copy  del  deltree dir  doctorfat  du  format  info  label  md  mount partition  rd  read  move  ren  showfat  toolstest  type write  zip) ; do ( 
    echo @echo off> img-%%i.bat
    echo mtool m%%i -i %%* >>img-%%i.bat
)


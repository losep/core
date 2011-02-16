@ECHO OFF
if X == X%1 goto noarg
bootfd.bat X:\boot\images\xpow98se.img  -hda fat::%1 %2 %3 %4 %5 %6 %7 %8 %9
:goto end
:noarg
bootfd.bat X:\boot\images\xpow98se.img
:end


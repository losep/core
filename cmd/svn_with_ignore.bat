@echo off
echo svn --config-option config:miscellany:global-ignores= "*.exe *.obj *.o *.pcb *.pch *.ilk *.m4 *.map *.opt Debug Release *.pdb *.sym *.gch *.cache *.ncb *.com *.COM *.OBJ *~ .*~ *.O *.EXE *.PCB *.lo *.la #*# .*.rej *.rej .#* .DS_Store" %*
svn --config-option config:miscellany:global-ignores="*.exe *.obj *.o *.pcb *.pch *.ilk *.m4 *.map *.opt Debug Release *.pdb *.sym *.gch *.cache *.ncb *.com *.COM *.OBJ *~ .*~ *.O *.EXE *.PCB *.lo *.la #*# .*.rej *.rej .#* .DS_Store" %*

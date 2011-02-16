@ECHO OFF
qemu -boot d -no-kqemu -m 256 -L %FS_APP%\emulator\qemu -cdrom %*

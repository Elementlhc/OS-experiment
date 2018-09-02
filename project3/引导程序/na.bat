@echo off
set name=%~n1
nasm -f bin %name%.asm -o %name%.com
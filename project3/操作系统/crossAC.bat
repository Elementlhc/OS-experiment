@echo off
set asmfile=%~n1
set cfile=%~n2
set LOADPOS=%~n3
set LIBPATH=../lib
nasm -f elf32 %asmfile%.asm -o %asmfile%.o
gcc -fno-builtin -Werror -Og -c %cfile%.c -o %cfile%.o
ld -N %LIBPATH%/crt0.o %asmfile%.o %cfile%.o %LIBPATH%/klib.o -Ttext %LOADPOS% --oformat binary -o %asmfile%.com
del %asmfile%.o %cfile%.o
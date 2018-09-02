@echo off
set cfile=%~n1
set LOADPOS=%~n2
set LIBPATH=../lib
gcc -fno-builtin -Werror -Og -c %cfile%.c -o %cfile%.o
ld -N %LIBPATH%/crt0.o %cfile%.o %LIBPATH%/klib.o -Ttext %LOADPOS% --oformat binary -o %cfile%.com
del %cfile%.o
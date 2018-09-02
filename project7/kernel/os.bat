@echo off
nasm -felf32 -o ../lib/kernel.o kernel.asm
nasm -felf32 -o ../lib/clib.o ../include/clib.asm
g++ -o os.o -Og -fno-exceptions -fno-rtti -c os.cpp
ld -o os.com -N -nostdlib ../lib/crt0.o os.o ../lib/clib.o ../lib/kernel.o -Ttext=0x7e00 --oformat binary
del os.o
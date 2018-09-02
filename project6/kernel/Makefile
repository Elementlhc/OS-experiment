all:
	nasm -felf32 -o ../lib/kernel.o kernel.asm
	nasm -felf32 -o ../lib/clib.o ../include/clib.asm
	i686-elf-g++ -o os.o -Og -I ../include -fno-exceptions -fno-rtti -c os.cpp
	i686-elf-ld -o os.com -nostdlib ../lib/crt0.o os.o ../lib/clib.o ../lib/kernel.o -Ttext=0x7e00 --oformat binary
	rm os.o
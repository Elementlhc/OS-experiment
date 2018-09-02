BITS 16

GLOBAL _Z5getipv
_Z5getipv:
    pop ax
    push ax
    retf

GLOBAL _Z5getspv
_Z5getspv:
    mov ax,sp
    retf

; _load(int cylinder, int track, int index, int load_addr)
GLOBAL _Z5_loadiiiii
_Z5_loadiiiii:
	push ax
	push bx
	push cx
	push dx
	push bp
		mov bp,sp
	    add bp,2*5
	    mov ah,2                ; 功能号
	    mov ch,[bp+4]                ;柱面号 ; 起始编号为0
	    mov dh,[bp+8]                ;磁头号 ; 起始编号为0
	    mov cl,[bp+12]           ;起始扇区号 ; 起始编号为1
	    mov al,[bp+16]      	 	;扇区数
	    mov bx,[bp+20]	 		;加载地址
	    mov dl,0                ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	    int 13H                 ;调用读磁盘BIOS的13h功能
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	retf

%include "kernel_int.asm"
%include "kernel_mp.asm"
%include "kernel_call.asm"
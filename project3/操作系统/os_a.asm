BITS 16
; _system(int start_sector, int num_sector, int oft)
GLOBAL Load
Load:
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
	    call bx
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	o32 ret						;或者retf
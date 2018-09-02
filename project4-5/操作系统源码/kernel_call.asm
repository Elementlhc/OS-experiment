BITS 16

_getChar:
	xor ax,ax
	int 16h
	ret

_putChar:
			push ax
			push bx
			push cx
			push dx
			push bp
		mov bp,sp
		add bp,2*5
		mov ax,[bp+2]
		mov ah,0eh
		mov cx,ax
    	mov bl,0
		int 10h
		
		mov ax,cx
		cmp byte al,0dh
		jne _putEnd
		mov al,0ah
		mov bl,0
		int 10h

		mov ah,03h	;读取光标信息
		mov bh,0	;页号
		int 10h
		inc dx
		mov ah,02h	;设置光标位置
		mov bh,0	;页号
		int 10h
_putEnd:
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret
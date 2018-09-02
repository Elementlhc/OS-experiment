BITS 16
EXTERN main
GLOBAL _start
_start:
	push ax
	push es
	push ds
	push ss
		mov ax,cs
	    mov ds,ax
	    mov es,ax
	    mov ss,ax
		push cs
		call main
	pop ss
	pop ds
	pop es
	pop ax
	ret
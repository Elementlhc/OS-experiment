BITS 16
EXTERN main
GLOBAL _start
_start:
	mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
	push cs
	call main
	ret
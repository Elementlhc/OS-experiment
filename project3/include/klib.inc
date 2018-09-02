
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.inc
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

BITS 16

;****************************
; void _cls()               *
;****************************

GLOBAL _cls
_cls: 
; 清屏
    push ax
    push bx
    push cx
    push dx		
		mov	ax, 600h	; AH = 6,  AL = 0
		mov	bx, 700h	; 黑底白字(BL = 7)
		mov	cx, 0		; 左上角: (0, 0)
		mov	dx, 184fh	; 右下角: (24, 79)
		int	10h		; 显示中断
		mov ah,02h
		mov bh,0
		mov dx,0
		int 10h
	pop dx
	pop cx
	pop bx
	pop ax
	o32 ret

;********************************************************
; void _printChar(char ch)                            	*
;********************************************************


GLOBAL _printChar
_printChar:
	push ax
	push bx
	push bp
		mov bp,sp
		mov ax,[bp+4+2*3]	;4? C语言调用汇编函数，参数以4个字节为单位入栈
		mov ah, 0eh
		mov bl,0
		int 10h
	pop bp
	pop bx
	pop ax
	o32 ret

;****************************
; char getch()           		*
;****************************

GLOBAL getch
getch:
	mov ah,0
	int 16h
	o32 ret

; ========================================================================
; void _delay(int h, int l);
; ========================================================================
GLOBAL _delay
_delay:
	push ax
	push cx
	push dx
	push bp
		mov bp,sp
		mov cx,[bp+4+2*4]
		mov dx,[bp+4*2+2*4]
		mov ah,86h
		int 15h
	pop bp
	pop dx
	pop cx
	pop ax
	o32 ret

; ========================================================================
;                  void _port_out(u16 port, u16 value);
; ========================================================================
GLOBAL	_port_out
_port_out:
    push bp
        mov bp,sp
    	mov	dx, word [bp + 2 + 4]		; port
		mov	ax, word [bp + 2 + 4 * 2]	; value
		out	dx, ax
		nop	; 一点延迟
		nop
		mov sp,bp
	pop bp
	o32 ret
; ========================================================================
;                  u8 _port_in(u16 port);
; ========================================================================
GLOBAL	_port_in
_port_in:
    push bp
            mov bp,sp
        	mov	dx, word [bp + 2]		; port
			xor	ax, ax
			in	al, dx
			nop	; 一点延迟
			nop
			mov sp,bp
	pop bp
	ret
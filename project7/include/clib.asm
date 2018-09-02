
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                             ; clib.inc
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

BITS 16

; ************************************
; int _getCursor();
; ************************************
GLOBAL _Z10_getCursorv
_Z10_getCursorv:
	push bx
	push dx
		mov ah,03h	;读取光标信息
		mov bh,0	;页号
		int 10h
		mov ax, dx	;dh 行号 dl 列号
	pop dx
	pop bx
	retf

; ************************************
; void _setCursor(int row, int col);
; ************************************
GLOBAL _Z10_setCursorii
_Z10_setCursorii:
	push dx
	push bp
		mov bp,sp
		add bp,4
		mov ah,02h	;设置光标位置
		mov bh,0	;页号
		mov dh,[bp+4]	;行dh 列dl4
		mov dl,[bp+8]
		int 10h
	pop bp
	pop dx
	retf

;**********************************************************
; void _cls(int r1, int c1, int r2, int c2)               *
;**********************************************************

GLOBAL _Z4_clsiiii
_Z4_clsiiii: 
; 清屏
    push ax
    push bx
    push cx
    push dx
    push bp
    	mov bp,sp
    	add bp,2*5
		mov	ax, 600h	; AH = 6,  AL = 0
		mov	bx, 700h	; 黑底白字(BL = 7)
		mov ch,[bp+4]	;左上角
		mov cl,[bp+8]
		mov dh,[bp+12]	;右下角
		mov dl,[bp+16]
		int	10h		; 显示中断
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	retf

;********************************************************
; void _printChar(char ch)                            	*
;********************************************************

GLOBAL _Z10_printCharc
_Z10_printCharc:
	push ax
	push bp
		mov bp,sp
		mov ax,[bp+4+2*2]	;4? C语言调用汇编函数，参数以4个字节为单位入栈
		mov ah, 2
		int 21h
	pop bp
	pop ax
	retf

; void printCharAt(int row, int line, char c, short color);
GLOBAL _Z11printCharAtiics
_Z11printCharAtiics:
	push ax
	push bx
	push bp
	push gs
		mov ax,0xb800
		mov gs,ax

		mov bp,sp
		add bp,2*4
		mov ax,[bp+4*1]
		mov bx,80
		mul bx
		add ax,[bp+4*2]
		mov bx,2
		mul bx
		mov bx,ax
		mov al,[bp+4*3]
		mov ah,[bp+4*4]
		mov [gs:bx],ax
	pop gs
	pop bp
	pop bx
	pop ax
	retf
	
;****************************
; char getch()           		*
;****************************

GLOBAL _Z5getchv
_Z5getchv:
	mov ah,1
	int 21h
	retf

; ========================================================================
; void _delay(int h, int l);
; ========================================================================
GLOBAL _Z6_delayii
_Z6_delayii:
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
	retf

GLOBAL _Z6rebootv
_Z6rebootv:
	push 2
	push 0xf000
	push 0xfff0
	iret
	
; ========================================================================
;                  void _port_out(u16 port, u16 value);
; ========================================================================
GLOBAL	_Z9_port_outii
_Z9_port_outii:
    push bp
        mov bp,sp
    	mov	dx, word [bp + 2 + 4]		; port
		mov	ax, word [bp + 2 + 4 * 2]	; value
		out	dx, ax
		nop	; 一点延迟
		nop
		mov sp,bp
	pop bp
	retf

BITS 16
EXTERN cTimer
; Load(int cylinder, int track, int index, int load_addr)
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
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	retf

; Run(int load_addr)
GLOBAL Run
Run:
	push bx
	push bp
		mov bp,sp
		add bp,2*2
		mov bx,[bp+4]
		call bx
	pop  bp
	pop bx
	retf

saveInt:
	push bp	
	push ax
	push bx
	push es
		mov bp,sp
		add bp,2*4
		mov bx,[bp+2]
		xor ax,ax
		mov es,ax
		mov word ax,[es:bx]
		mov word bp,int_vector
		add bp,bx
		mov word [bp],ax
	pop es
	pop bx
	pop ax
	pop bp
	ret

; setInt(int interr_num, int ip_addr);
_setInt:
	push ax
	push bx
	push bp
		mov bp,sp
		add bp,2*3
		mov bx,[bp+2]
		mov ax,[bp+4]

		;保存原来的中断
		shl bx,2
		push bx
		call saveInt     ;ip
		add sp,2
		add bx,2
		push bx
		call saveInt     ;cs
		add sp,2

		; 设置新中断
		mov bp,bx
		mov word[bp],cs
		sub bp,2
		mov word[bp],ax
	pop bp
	pop bx
	pop ax
	ret

intEnd:
	push ax
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    pop ax
	sti
	iret

; void resetInt(int which)
GLOBAL resetInt
resetInt:
	push ax
	push bx
	push es
	push gs
	push bp
		mov bp,sp
		add bp,5*2
		
		mov ax,[bp+4]
		mov bx,4
		mul bx
		mov bx,ax

		xor ax,ax
		mov gs,ax
		mov bp,int_vector
		add bp,bx
		mov word ax,[bp]	;ip
		mov word [gs:bx],ax
		add bx,2
		add bp,2
		mov word ax,[bp]	;cs
		mov word [gs:bx],ax

		mov byte[color],0
	pop bp
	pop gs
	pop es
	pop bx
	pop ax
	retf

GLOBAL setInt8h
setInt8h:
	cli
	push word Timer
	push 8
	call _setInt
	add sp,4
	sti
	retf
Timer:
	cli
	push cs
	call cTimer
	jmp intEnd

GLOBAL setInt9h
setInt9h:
	cli
	push word KeyboardInt
	push 9
	call _setInt
	add sp,4

	sti
	retf
KeyboardInt:
	cli
	push ax
    push bx
Ouch:
	push di
    push si
    push gs
    mov ax,0xb800
    mov gs,ax

    mov bx,(80*12+39)*2
    mov ah,[color]
    mov di,0
    mov si,ouchs
loopOutput:
    cmp di,ouch_len
    jge ouchEnd
    mov byte al,[si]
    mov [gs:bx],ax
    add bx,2
    inc di
    inc si
    jmp loopOutput
ouchEnd:
    inc byte[color]
    pop gs
    pop si
    pop di
music:
    in al,60h
   	cmp al,1eh	;'A'
   	jb KeyboardEnd
   	cmp al,25h	;'K'
   	jg KeyboardEnd
   	sub al,1eh
   	xor ah,ah
   	shl al,1
   	mov bx,ax
   	push word[frequency+bx]
   	call musick
   	add sp,2
KeyboardEnd:
    pop bx
    pop ax
	jmp intEnd

; －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－   
; Subroutine 延时指定的时钟嘀嗒数   
; 入口：   
; Didas=时钟嘀嗒数（1秒钟约嘀嗒18.2次，10秒钟嘀嗒182次。若延时不是秒的10数次倍，误差稍微大点）   
delayk: 
    push dx   
    push cx   
    xor ax, ax   
    int 1ah   
    mov [_times], dx   
    mov [_times+2], cx   
read_time:   
    xor ax,ax   
    int 1ah   
    sub dx, [_times]   
    sbb cx, [_times+2]   
    cmp dx, DIDAS   
    jb read_time   
    pop cx   
    pop dx   
    ret 
  
  ; void musick(int fre);
musick: 
    push ax   
    push bx
    push cx   
    push dx   
    push bp
       in al, 61h   
       or al, 3   
       out 61h, al ;接通扬声器   
      
       mov al, 0b6h   ;;将计数器2设为LSB和MSB,Model3,二进制格式
       out 43h, al   
       mov dx, 12h   
       mov ax, 348ch
       mov bp,sp
       add bp,2*5
       mov word bx,[bp+2]
       div word bx	;音符的频率
       out 42h, al  ;给计时器2写入低位字节
      
       mov al, ah   ;给计时器2写入高位字节
       out 42h, al   
      
       in al, 61h   ;获得61H端口当前的设置
       mov ah, al   
       or al, 3   	;使PB0=1,PB1=以使扬声器可以发声
       out 61h, al  ;打开扬声器
      
       mov cx, 3314   
    push ax 
    ;功能:产生一个N×15.08μs的时间延迟
    ;调用:(CX) = 15.08μs的倍数N  
    @waitf1:   
       in al, 61h   
       and al, 10h   
       cmp al, ah   
       jz @waitf1   
       mov ah, al   
       loop @waitf1   
    pop ax   
       call delayk ;延时   
       mov al, ah   
       out 61h, al ;关闭扬声器   
    pop bp   
    pop dx   
    pop cx   
    pop bx
    pop ax   
    out 61h, al   ;恢复61H端口原来的设置
    ret

color db 0
ouchs db "Ouch!Ouch!"
ouch_len equ $-ouchs


DIDAS EQU 2                              ;延时（时钟嘀嗒次数）   
 _times dw 0,0
frequency:
   dw 523,587,659,698,784,880,988,1048	;中音频率

GLOBAL setInt22h
setInt22h:
	cli
	push word @22h
	push 22h
	call _setInt
	add sp,4

	sti
	retf
@22h:
	cli
	push ax
    push bx
    push di
    push si
    push gs
    mov ax,0xb800
    mov gs,ax

    mov bx,(80*4+4)*2
    mov ah,22
    mov di,0
    mov si,@22hmsg
@22h1:
    cmp di,@22hmsglen
    jge @22hEnd
    mov byte al,[si]
    mov [gs:bx],ax
    add bx,2
    inc di
    inc si
    jmp @22h1
@22hEnd:
    pop gs
    pop si
    pop di
    pop bx
    pop ax
	jmp intEnd
@22hmsg db "This is 22h!"
@22hmsglen equ $-@22hmsg

GLOBAL setInt23h
setInt23h:
	cli
	push word @23h
	push 23h
	call _setInt
	add sp,4

	sti
	retf
@23h:
	cli
	push ax
    push bx
    push di
    push si
    push gs
    mov ax,0xb800
    mov gs,ax

    mov bx,(80*4+60)*2
    mov ah,23
    mov di,0
    mov si,@23hmsg
@23h1:
    cmp di,@23hmsglen
    jge @23hEnd
    mov byte al,[si]
    mov [gs:bx],ax
    add bx,2
    inc di
    inc si
    jmp @23h1
@23hEnd:
    pop gs
    pop si
    pop di
    pop bx
    pop ax
	jmp intEnd
@23hmsg db "This is 23h!"
@23hmsglen equ $-@23hmsg

GLOBAL setInt24h
setInt24h:
	cli
	push word @24h
	push 24h
	call _setInt
	add sp,4

	sti
	retf
@24h:
	cli
	push ax
    push bx
    push di
    push si
    push gs
    mov ax,0xb800
    mov gs,ax

    mov bx,(80*20+4)*2
    mov ah,24
    mov di,0
    mov si,@24hmsg
@24h1:
    cmp di,@24hmsglen
    jge @24hEnd
    mov byte al,[si]
    mov [gs:bx],ax
    add bx,2
    inc di
    inc si
    jmp @24h1
@24hEnd:
    pop gs
    pop si
    pop di
    pop bx
    pop ax
	jmp intEnd
@24hmsg db "This is 24h!"
@24hmsglen equ $-@24hmsg

GLOBAL setInt25h
setInt25h:
	cli
	push word @25h
	push 25h
	call _setInt
	add sp,4

	sti
	retf
@25h:
	cli
	push ax
    push bx
    push di
    push si
    push gs
    mov ax,0xb800
    mov gs,ax

    mov bx,(80*20+60)*2
    mov ah,25
    mov di,0
    mov si,@25hmsg
@25h1:
    cmp di,@25hmsglen
    jge @25hEnd
    mov byte al,[si]
    mov [gs:bx],ax
    add bx,2
    inc di
    inc si
    jmp @25h1
@25hEnd:
    pop gs
    pop si
    pop di
    pop bx
    pop ax
	jmp intEnd
@25hmsg db "This is 25h!"
@25hmsglen equ $-@25hmsg

GLOBAL setInt21h
setInt21h:
	cli
	push word @21h
	push 21h
	call _setInt
	add sp,4

	sti
	retf
@21h:
	cli
@1:
	cmp ah,1
	jnz @2
; ah=1,键盘输入并回显,AL=输入字符
fno1_readAndPrintChar:
	call _getChar
	jmp fno2_printChar
@2:
	cmp ah,2
	jnz @3
; ah=2,显示输出,AL=输出字符
fno2_printChar:
    push ax
    call _putChar
    add sp,2
    jmp @21End
@3:

@7:
	cmp ah,7
	jnz @8
; ah=1,键盘输入无回显,AL=输入字符
fno7_readChar:
	call _getChar
	jmp @21End
@8:
@21End:
	jmp intEnd

int_vector:
	times 30h dd 0

%include "kernel_call.asm"
org 7c00h
mov	ax, cs	       ; 置其他段寄存器值与CS相同
mov	ds, ax	       ; 数据段
mov es, ax		   ; 置ES=DS
call printChar

@1:  
jmp @1

printChar:
	mov	bp, Message		 ; BP=当前串的偏移地址
	mov	cx, MessageLength	; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
    mov dx, 0		       ; 行号=0; 列号=0			 
	int	10h			 ; BIOS的10h功能：显示一行字符
	ret
Message:
	db '16337113 laomadong'
MessageLength  equ ($-Message)
times 510-($-$$) db 0
db 0x55,0xaa
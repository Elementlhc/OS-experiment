;程序源代码（myos1.asm）
org  7c00h		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 8100h
start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov es, ax		   
	call printString
	mov	ds, ax	       ; 数据段; 置ES=DS
LoadnEx:
	call input
	cmp al,1
	jz clearWindow
	call callProgram
	jmp loopEnd
clearWindow:
	call clear
loopEnd:
	loop LoadnEx              ;无限循环

input:
	mov ah, 00h
	int 16h
	cmp al,'0'
	jb invalidInput
	cmp al,'7'
	jg invalidInput
	sub al,'0'
	inc al
	ret
invalidInput:
	jmp input

clear:
	xor ax,ax
	mov ah,06h
	mov al,0   ;清窗口
	mov ch,1   ;左上角的行号
	mov cl,0   ;左上角的列号
	mov dh,24  ;右下角的行号
	mov dl,79  ;右下角的行号
	int 10h
	ret
	
callProgram:
	push ax
	mov ax,cs
	mov es,ax
	mov ds,ax
	mov bx, OffSetOfUserPrg1  ;偏移地址; 存放数据的内存偏移地址
	;读软盘或硬盘上的若干物理扇区到内存的ES:BX处
	mov ah,2                 ; 功能号
	mov al,1                 ;扇区数
	mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0                 ;磁头号 ; 起始编号为0
	pop cx
	mov ch,0                 ;柱面号 ; 起始编号为0
	int 13H ;                调用读磁盘BIOS的13h功能
	; 用户程序a.com已加载到指定内存区域中
	call bx
	ret
	
printString:
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
x db 1
      times 510-($-$$) db 0
      db 0x55,0xaa


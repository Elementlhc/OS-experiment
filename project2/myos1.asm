;����Դ���루myos1.asm��
org  7c00h		; BIOS���������������ص�0:7C00h��������ʼִ��
OffSetOfUserPrg1 equ 8100h
start:
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov es, ax		   
	call printString
	mov	ds, ax	       ; ���ݶ�; ��ES=DS
LoadnEx:
	call input
	cmp al,1
	jz clearWindow
	call callProgram
	jmp loopEnd
clearWindow:
	call clear
loopEnd:
	loop LoadnEx              ;����ѭ��

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
	mov al,0   ;�崰��
	mov ch,1   ;���Ͻǵ��к�
	mov cl,0   ;���Ͻǵ��к�
	mov dh,24  ;���½ǵ��к�
	mov dl,79  ;���½ǵ��к�
	int 10h
	ret
	
callProgram:
	push ax
	mov ax,cs
	mov es,ax
	mov ds,ax
	mov bx, OffSetOfUserPrg1  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
	;�����̻�Ӳ���ϵ����������������ڴ��ES:BX��
	mov ah,2                 ; ���ܺ�
	mov al,1                 ;������
	mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
	mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
	pop cx
	mov ch,0                 ;����� ; ��ʼ���Ϊ0
	int 13H ;                ���ö�����BIOS��13h����
	; �û�����a.com�Ѽ��ص�ָ���ڴ�������
	call bx
	ret
	
printString:
	mov	bp, Message		 ; BP=��ǰ����ƫ�Ƶ�ַ
	mov	cx, MessageLength	; CX = ������=9��
	mov	ax, 1301h		 ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
    mov dx, 0		       ; �к�=0; �к�=0			 
	int	10h			 ; BIOS��10h���ܣ���ʾһ���ַ�
	ret

Message:
      db '16337113 laomadong'
MessageLength  equ ($-Message)
x db 1
      times 510-($-$$) db 0
      db 0x55,0xaa


; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.     
;  ��Ӧ�� 2014/3
     Down equ 1                  ;D-Down,U-Up,R-right,L-Left
	 Right equ 2
	 Left equ 3
	 DnLt equ 4
	 DnRt equ 5
     delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
	 Up_BD equ 10
	 Dn_BD equ 22
	 Lt_BD equ 2
	 Rt_BD equ 18
    org 1000h					; ������ص�100h������������COM 
start:
push ax
push bx
push cx
push dx
push es
	mov ax,cs
	mov ds,ax
	mov ax,0xb800				;ָ���ı�ģʽ����ʾ������
	mov es,ax
	mov word[x],Up_BD
	mov word[y],Rt_BD
	inc word[y]
loop1:
	dec word[count]				; �ݼ���������
	jnz loop1					; >0����ת;
	mov word[count],delay
	dec word[dcount]				; �ݼ���������
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,Down
    cmp al,byte[rdul]			;���ʱ���Ϊ0
	jz  DownMove
	mov al,Left
    cmp al,byte[rdul]			;���ʱ���Ϊ0
	jz  LeftMove
	mov al,Right
    cmp al,byte[rdul]
	jz  RightMove
	mov al,DnLt
    cmp al,byte[rdul]
	jz  DnLtMove
	mov al,DnRt
    cmp al,byte[rdul]
	jz  DnRtMove
    jmp end

setSymmetricPoint:
	mov ax,Up_BD
	add ax,Dn_BD
	mov bx,Lt_BD
	add bx,Rt_BD
	ret
	
drawSymmetric:
	push ax
	push bx
	sub ax,word[x]
	mov word[x],ax
	sub bx,word[y]
	mov word[y],bx
	call show
	mov cx,word[y]
	pop bx
	sub bx,cx
	mov word[y],bx
	mov bx,cx
	mov cx,word[x]
	pop ax
	sub ax,cx
	mov word[x],ax
	mov ax,cx
	ret

DownMove:
	inc word[x]					;ȡ����ǰ����������
	call show					;���ǰ��������������ǣ���������ʾ
	call setSymmetricPoint
	call drawSymmetric
	sub ax,2
	cmp word[x],ax
	jz toDR
	jmp loop1

toD:
	mov byte[rdul],Down
	jmp loop1
toDL:
	mov byte[rdul],DnLt
	jmp loop1
toDR:
	mov byte[rdul],DnRt
	jmp loop1
toL:
	mov byte[rdul],Left
	jmp loop1
toR:
	mov byte[rdul],Right
	jmp loop1
	
DnLtMove:
	inc word[x]
	dec word[y]
	call show
	call setSymmetricPoint
	call drawSymmetric
	jmp toD
	
DnRtMove:
	inc word[x]
	inc word[y]
	call show
	call setSymmetricPoint
	call drawSymmetric
	jmp toR
	
RightMove:
	inc word[y]
	call show
	call setSymmetricPoint
	call drawSymmetric
	cmp word[y],bx
	jg end
	jmp loop1
	
LeftMove:
	dec word[y]
	call show
	call setSymmetricPoint
	call drawSymmetric
	mov bx,word[y]
	mov ax,Lt_BD
	sub ax,bx
	jz toDL
	jmp loop1

show:
	xor ax,ax                 ; �����Դ��ַ
	mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah, byte[cnt]			  ;�Ѹ�����ֵ��ah�����������ǰ��
	add ah, 1				  ;��1��Ϊ�˷�ֹ�ڵ�1���ֵ���ɫ�Ǻ�ɫ���޷�����
	;and ah,10001111b
	mov cx, word[cnt]
	and cx, 1				  ;��1�����൱��%2��������������ż��������
	jz bushan
	or ah, 10000000b		  ;ͨ���������K��1��ʹ�ַ���˸
bushan:
	jmp show2
show2:
	mov al,byte[char1]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word [es:bx],ax  		;  ��ʾ�ַ���ASCII��ֵ
	inc word[cnt]
	ret
	
end:
pop es
pop dx
pop cx
pop bx
pop ax
    ret
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Left         ; �������˶�
    x    dw 0
    y    dw 0
	cnt dw 0
    char1 db 'S'
times 512-($-$$) db 0
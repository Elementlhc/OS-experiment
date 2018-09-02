; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.     
;  ��Ӧ�� 2014/3
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    ;org 100h					; ������ص�100h������������COM 
initilize:
	mov ax,0x07c0
	mov ds,ax
	mov ax,0xb800				;ָ���ı�ģʽ����ʾ������
	mov es,ax
	mov si,info
	xor di,di					;ѭ������di=0
print_str:
	mov bx,infolen
	add bx,bx
	cmp bx,di					;while(di<infolen)	��ӡ������Ϣ di+=2
	jb start
	mov al,[si]
	mov byte [es:di],al
	inc si
	add di,2					;+2����Ϊ��һ��byte����ʾ�ַ����ڶ���byte����ɫ
	loop print_str
start:
	;xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
loop1:
	dec word[count]				; �ݼ���������
	jnz loop1					; >0����ת;
	mov word[count],delay
	dec word[dcount]				; �ݼ���������
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]			;���ʱ���Ϊ0
	jz  DnRt
    mov al,2
    cmp al,byte[rdul]
	jz  UpRt
    mov al,3
    cmp al,byte[rdul]
	jz  UpLt
    mov al,4
    cmp al,byte[rdul]
	jz  DnLt
    jmp $	

DnRt:
	inc word[x]					;ȡ����ǰ����������
	inc word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
	jz  dr2ur					;���������25�����Ѿ�������磬��תΪ���Ϸ���
	mov bx,word[y]
	mov ax,80
	sub ax,bx
	jz  dr2dl					;���������80�����Ѿ��ұ߳����磬��ת���·���
	jmp show					;���ǰ��������������ǣ���������ʾ
dr2ur:
	mov word[x],23
	mov byte[rdul],Up_Rt	
	jmp show
dr2dl:
	mov word[y],78
	mov byte[rdul],Dn_Lt	
	jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
	jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
	jz  ur2dr
	jmp show
ur2ul:
	mov word[y],78
	mov byte[rdul],Up_Lt	
	jmp show
ur2dr:
	mov word[x],1
	mov byte[rdul],Dn_Rt	
	jmp show

UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
	jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
	jz  ul2ur
	jmp show

ul2dl:
	mov word[x],1
	mov byte[rdul],Dn_Lt	
	jmp show
ul2ur:
	mov word[y],1
	mov byte[rdul],Up_Rt	
	jmp show
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
	jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
	jz  dl2ul
	jmp show

dl2dr:
	mov word[y],1
	mov byte[rdul],Dn_Rt	
	jmp show
	
dl2ul:
	mov word[x],23
	mov byte[rdul],Up_Lt	
	jmp show
	
show:
	xor ax,ax                 ; �����Դ��ַ
	mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah, byte[x]			  ;��������ֵ��ah�����������ǰ��
	add ah, 1				  ;��1��Ϊ�˷�ֹ�ڵ�0�г����ֵ���ɫ�Ǻ�ɫ���޷�����
	mov cx, word[x]
	and cx, 1				  ;��1�����൱��%2��������������ż���в���
	jz bushan
	jnz shan
bushan:
	jmp show2
shan:
	or ah, 10000000b		  ;ͨ���������K��1��ʹ�ַ���˸
	jmp show2
show2:
	mov al,byte[char1]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word [es:bx],ax  		;  ��ʾ�ַ���ASCII��ֵ
	mov al,byte[char2]
	mov word [es:(bx+2)],ax  		;  ��ʾ�ַ���ASCII��ֵ
	jmp loop1
end:
    jmp $                   ; ֹͣ��������ѭ�� 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; �������˶�
    x    dw 0
    y    dw 0
    char1 db 'A'
	char2 db 'B'
	info db '16337113 laomd'
	infolen equ $-info

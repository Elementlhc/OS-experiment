; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.     
;  ��Ӧ�� 2014/3
     Down equ 1                  ;D-Down,U-Up,R-right,L-Left
     UpRt equ 2                  ;
     Hori equ 3                  ;
     delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
     ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
	 Up_BD equ 1
	 Dn_BD equ 8
	 Lt_BD equ 5
	 Rt_BD equ 15
    org 8100h					; ������ص�100h������������COM 
start:
	mov ax,cs
	mov ds,ax
	mov ax,0xb800				;ָ���ı�ģʽ����ʾ������
	mov es,ax
	mov word[x],Up_BD
	add word[x],3
	mov word[y],Lt_BD
	add word[y],2
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
    mov al,UpRt
    cmp al,byte[rdul]
	jz  UpRtMove
    mov al,Hori
    cmp al,byte[rdul]
	jz  HoriMove
    jmp end

DownMove:
	inc word[x]					;ȡ����ǰ����������
	call show					;���ǰ��������������ǣ���������ʾ
	mov bx,word[x]
	mov ax,Dn_BD
	sub ax,bx
	jz  d2h					;���������25�����Ѿ�������磬��תΪ��
	jmp loop1
	
d2h:
	mov byte[rdul],Hori
	mov word[y],Lt_BD
	jmp loop1
	
UpRtMove:
	dec word[x]
	inc word[y]
	call show
	mov bx,word[x]
	mov ax,Up_BD
	sub ax,bx
	jz  rt2d
	jmp loop1
	
rt2d:
	mov byte[rdul],Down
	jmp loop1
	
HoriMove:
	inc word[y]
	call show
	mov bx,word[y]
	mov ax,Rt_BD
	cmp ax,bx
	jb  end
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
    ret
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db UpRt         ; �������˶�
    x    dw 0
    y    dw 0
	cnt dw 0
    char1 db '1'
times 512-($-$$) db 0
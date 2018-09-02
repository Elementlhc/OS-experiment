; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.     
;  凌应标 2014/3
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
    ;org 100h					; 程序加载到100h，可用于生成COM 
initilize:
	mov ax,0x07c0
	mov ds,ax
	mov ax,0xb800				;指向文本模式的显示缓冲区
	mov es,ax
	mov si,info
	xor di,di					;循环变量di=0
print_str:
	mov bx,infolen
	add bx,bx
	cmp bx,di					;while(di<infolen)	打印个人信息 di+=2
	jb start
	mov al,[si]
	mov byte [es:di],al
	inc si
	add di,2					;+2是因为第一个byte是显示字符，第二个byte是颜色
	loop print_str
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]			;相等时结果为0
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
	inc word[x]					;取出当前行数和列数
	inc word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
	jz  dr2ur					;如果行数是25，即已经下面出界，就转为右上方向
	mov bx,word[y]
	mov ax,80
	sub ax,bx
	jz  dr2dl					;如果列数是80，即已经右边出出界，就转右下方向
	jmp show					;如果前面两种情况都不是，就正常显示
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
	xor ax,ax                 ; 计算显存地址
	mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah, byte[x]			  ;把行数赋值给ah，随机背景和前景
	add ah, 1				  ;加1是为了防止在第0行出现字的颜色是黑色而无法看到
	mov cx, word[x]
	and cx, 1				  ;和1相与相当于%2，即奇数行闪，偶数行不闪
	jz bushan
	jnz shan
bushan:
	jmp show2
shan:
	or ah, 10000000b		  ;通过或操作把K置1，使字符闪烁
	jmp show2
show2:
	mov al,byte[char1]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word [es:bx],ax  		;  显示字符的ASCII码值
	mov al,byte[char2]
	mov word [es:(bx+2)],ax  		;  显示字符的ASCII码值
	jmp loop1
end:
    jmp $                   ; 停止画框，无限循环 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 0
    y    dw 0
    char1 db 'A'
	char2 db 'B'
	info db '16337113 laomd'
	infolen equ $-info

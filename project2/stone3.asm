; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.     
;  凌应标 2014/3
     Down equ 1                  ;D-Down,U-Up,R-right,L-Left
	 Right equ 2
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
	 Up_BD equ 1
	 Dn_BD equ 8
	 Lt_BD equ 66
	 Rt_BD equ 76
    org 8100h					; 程序加载到100h，可用于生成COM 
start:
	mov ax,cs
	mov ds,ax
	mov ax,0xb800				;指向文本模式的显示缓冲区
	mov es,ax
	mov word[x],Up_BD
	mov word[y],Lt_BD
	dec word[y]
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay
	
    mov al,Down
    cmp al,byte[rdul]			;相等时结果为0
	jz  DownMove
	mov al,Right
    cmp al,byte[rdul]
	jz  RightMove
    jmp end

DownMove:
	inc word[x]					;取出当前行数和列数
	call show					;如果前面两种情况都不是，就正常显示
	mov bx,word[x]
	mov ax,Dn_BD
	cmp ax,bx
	jz end
	jmp loop1

toD:
	mov word[x],Up_BD
	dec word[x]
	mov byte[rdul],Down
	jmp loop1
	
RightMove:
	inc word[y]
	call show
	mov word[x],Dn_BD
	call show
	mov ax,word[x]
	mov bx,2
	div bx
	mov word[x],ax
	call show
	mov word[x],Up_BD
	mov bx,word[y]
	mov ax,Rt_BD
	sub ax,bx
	jz toD
	jmp loop1

show:
	xor ax,ax                 ; 计算显存地址
	mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bx,ax
	mov ah, byte[cnt]			  ;把个数赋值给ah，随机背景和前景
	add ah, 1				  ;加1是为了防止在第1个字的颜色是黑色而无法看到
	;and ah,10001111b
	mov cx, word[cnt]
	and cx, 1				  ;和1相与相当于%2，即奇数个闪，偶数个不闪
	jz bushan
	or ah, 10000000b		  ;通过或操作把K置1，使字符闪烁
bushan:
	jmp show2
show2:
	mov al,byte[char1]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word [es:bx],ax  		;  显示字符的ASCII码值
	inc word[cnt]
	ret
	
end:
    ret
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Right         ; 向右下运动
    x    dw 0
    y    dw 0
	cnt dw 0
    char1 db '3'
times 512-($-$$) db 0
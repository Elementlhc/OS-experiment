BITS 16

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
    mov al,20h          ; AL = EOI
    out 20h,al          ; 发送EOI到主8529A
    out 0A0h,al         ; 发送EOI到从8529A
    pop ax
    sti
    iret

; void resetInt(int which)
GLOBAL _Z8resetInti
_Z8resetInti:
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
        mov word ax,[bp]    ;ip
        mov word [gs:bx],ax
        add bx,2
        add bp,2
        mov word ax,[bp]    ;cs
        mov word [gs:bx],ax

    pop bp
    pop gs
    pop es
    pop bx
    pop ax
    retf

GLOBAL _Z9setInt21hv
_Z9setInt21hv:
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
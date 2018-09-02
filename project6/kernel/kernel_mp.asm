BITS 16

EXTERN _Z11saveProcessiiiiiiiiiiiiiii
EXTERN _Z8schedulev
EXTERN _Z10sendCurProv
EXTERN _Z6rebootv

tmp_pcb: times 15 dw 0
GLOBAL _Z7sendPCBiiiiiiiiiiiiiii
_Z7sendPCBiiiiiiiiiiiiiii:
    push bx
    push di
    push si
    push bp
        mov bp,sp
        add bp,2*4+4
        xor di,di
        mov si,tmp_pcb
        loopPop:
            cmp di,15
            jae sendEnd
            mov bx,word[bp]
            mov word[si],bx
            inc di
            add bp,4
            add si,2
            jmp loopPop
sendEnd:
    pop bp
    pop si
    pop di
    pop bx
    retf

; void setInt8h();
GLOBAL _Z8setInt8hv
_Z8setInt8hv:
    cli
    push word Timer
    push 8
    call _setInt
    add sp,4
    sti
    retf


tmp_cs: dw 0
tmp_ip: dw 0
tmp_flags: dw 0
timer_cnt: db 0
is_done: db 0

kernel_pcb: times 15 dw 0
help_pcb: dw 0

GLOBAL _Z10Timer_donev
_Z10Timer_donev:
    add sp,4
    mov si,kernel_pcb
    mov byte[is_done],1
    mov byte[timer_cnt],0
    jmp restart_1

Timer:
    cli

    cmp byte[timer_cnt],0
    jnz Timer_save
    mov byte[is_done],0
    mov byte[timer_cnt],1
    
    mov word[kernel_pcb],ax
    mov word[kernel_pcb+2],bx
    mov word[kernel_pcb+4],cx
    mov word[kernel_pcb+6],dx
    mov word[kernel_pcb+8],si
    mov word[kernel_pcb+10],di
    mov word[kernel_pcb+12],bp
    mov word[kernel_pcb+14],es
    mov word[kernel_pcb+16],gs
    mov word[kernel_pcb+18],ds
    mov word[kernel_pcb+20],ss
    pop word[kernel_pcb+24] ;ip
    pop word[kernel_pcb+26] ;cs
    pop word[kernel_pcb+28] ;flags
    mov word[kernel_pcb+22],sp

Timer_save:
    cmp byte[is_done],0
    jnz intEnd

    pop word[tmp_ip]
    pop word[tmp_cs]
    pop word[tmp_flags]

    push 0
    push word[tmp_flags]
    push 0
    push word[tmp_cs]
    push 0
    push word[tmp_ip]
    push 0
    push sp
    push 0    
    push ss
    push 0    
    push ds
    push 0    
    push gs
    push 0    
    push es
    push 0    
    push bp
    push 0    
    push di
    push 0    
    push si
    push 0    
    push dx
    push 0    
    push cx
    push 0    
    push bx
    push 0    
    push ax

    push cs
    call _Z11saveProcessiiiiiiiiiiiiiii
    add sp,15*4

    push cs
    call _Z8schedulev

Timer_restart:
    push cs
    call _Z10sendCurProv
    mov si,tmp_pcb

restart_1:
    mov ax,word[si]
    mov bx,word[si+2]
    mov cx,word[si+4]
    mov dx,word[si+6]
    mov di,word[si+10]
    mov bp,word[si+12]
    mov es,word[si+14]
    mov gs,word[si+16]
    mov ss,word[si+20]  ;转到用户栈
    mov sp,word[si+22]
    push word[si+28]    ;flags
    push word[si+26] ;cs
    push word[si+24] ;ip
    mov ds,word[si+18]
    mov si,word[si+8]

    jmp intEnd
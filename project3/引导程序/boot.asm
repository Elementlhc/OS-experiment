org 7c00h
_start:
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    push 0x7e00
    push 11
    push 2
    call Load

_end:
    mov ah,4ch
    int 21h
    
Load:
    push ax
    push bx
    push cx
    push dx
    push bp
        mov bp,sp
        mov cl,[bp+2+2*5]               ;起始扇区号 ; 起始编号为1
        mov al,[bp+4+2*5]             ;扇区数
        mov bx,[bp+6+2*5]             
        mov ah,2                ; 功能号
        mov dl,0                ;驱动器号 ; 软盘为0，硬盘和U盘为80H
        mov dh,0                ;磁头号 ; 起始编号为0
        mov ch,0                ;柱面号 ; 起始编号为0
        int 13H                 ;调用读磁盘BIOS的13h功能
        call bx
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ret
times 510-($-$$) db 0
dw 0xAA55
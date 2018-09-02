org 7c00h
_start:
    mov cl,2               ;起始扇区号 ; 起始编号为1
    mov al,17             ;扇区数
    mov bx,0x7e00             
    mov ah,2                ; 功能号
    mov dl,0                ;驱动器号 ; 软盘为0，硬盘和U盘为80H
    mov dh,0                ;磁头号 ; 起始编号为0
    mov ch,0                ;柱面号 ; 起始编号为0
    int 13H                 ;调用读磁盘BIOS的13h功能
    call bx
_end:
    jmp $
    
times 510-($-$$) db 0
dw 0xAA55
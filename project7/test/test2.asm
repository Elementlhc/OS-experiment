org 0x2000

mov ax,cs
mov ds,ax
mov ax,0xb800
mov gs,ax
mov ah,0x20
mov al,'A'
mov bx,(5*80+50)*2
mov word[count],delay
mov word[dcount],ddelay

loop1:
    dec word[count]             ; µÝ¼õ¼ÆÊý±äÁ¿
    jnz loop1                   ; >0£ºÌø×ª;
    mov word[count],delay
    dec word[dcount]                ; µÝ¼õ¼ÆÊý±äÁ¿
    jnz loop1
    mov word[count],delay
    mov word[dcount],ddelay

    mov word[gs:bx],ax
    inc al
    cmp al,'Z'
    ja end
    add bx,2
    jmp loop1
end:
    mov ah,2
    mov al,'2'
    int 21h
    jmp $

delay equ 50000
ddelay equ 200
count dw 0
dcount dw 0
times 512-($-$$) db 0
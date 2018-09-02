mov ax,0x07c0
mov ds,ax
mov ax,0xb800
mov es,ax
mov cx,msglen
mov si,message
xor di,di
print_str:
mov bx, msglen
add bx,bx
cmp di, bx
jge end
mov al,[si]
mov [es:di],al
inc si
inc di
mov byte [es:di],0x07
inc di
loop print_str
end:
jmp $
message db 'laomdong'
msglen equ $-message
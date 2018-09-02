org 1000h
int 22h
int 23h
int 24h
int 25h
push ax
push di
push si
mov si,msg
xor di,di
loop1:
	cmp word di,msglen
	jge END
	mov ah,2
	mov byte al,[si]
	int 21h
	inc di
	inc si
	jmp loop1
END:
pop si
pop di
pop ax
ret

msg db "This is a test for 21h with ah == 2."
db 13
msglen equ $-msg

times 512-($-$$) db 0
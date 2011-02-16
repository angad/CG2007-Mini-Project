stk segment stack
	db 128 DUP(?)
tos label word
stk ends
;
data segment
	array db 1,2,3,4,5,6,7,8,9,0,1,1,1,1,1,1,1,1
	len equ $ - array
data ends
;
code segment
assume cs:code, ss:stk, ds:data
;
start:
	mov	ax, stk		;initialize stack
	mov	ss, ax
	mov	sp, offset tos
	mov	ax, data		;initialize data segment
	mov	ds, ax
	mov ax, len
	mov dx, 0
	mov bx, 10
	div word ptr bx 	;divide ax by bx
	mov cx, dx			
	mov ah, 2
	mov dl, al
	add dl, 30h
	int 21h				;printing first char
	mov ah, 2
	mov dl, cl
	add dl, 30h
	int 21h				;printing second char
;
; call exit function to DOS
exit:
	mov ah,4ch
	int 21h
code ends
end start
	
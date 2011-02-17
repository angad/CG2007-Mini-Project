stk segment stack
	db 128 DUP(?)
tos label word
stk ends
;
data segment
	array db 13,2,3,4,5,6,7,8,9,10,11,12,14,16
	len equ $ - array
	nonumbers db "There are no numbers$"
	space db " $"
	threshold equ 12
	table dw 3 DUP(?)
data ends
;
code segment
assume cs:code, ss:stk, ds:data
;
start:
print MACRO val
	mov ah, 2
	mov dl, val
	add dl, 30h
	int 21h
ENDM
printsp MACRO
	mov ah, 2
	mov dl, 20h
	int 21h
ENDM
;printd PROC NEAR
;	mov dx, 0
;	mov bx, 10
;	div word ptr bx
;	mov cx, dx
;	mov dl, 0
;	cmp dl, al
;	je second
;first:	print al
;second:	print cl
;	RET
;printd ENDP
	mov	ax, stk		;initialize stack
	mov	ss, ax
	mov	sp, offset tos
	mov	ax, data		;initialize data segment
	mov	ds, ax
;-------------------------q1
	mov ax, len
	;CALL NEAR PTR printd
	mov dx, 0
	mov bx, 10
	div word ptr bx
	mov cx, dx
	mov dl, 0
	cmp dl, al
	je second
	first:	print al
	second:	print cl
	;
;-------------------------q2
	mov cl, 0ah
	print cl
	xor cl, cl
	xor bx, bx
	xor al, al
	xor cx, cx
traverse:
	mov cl, array[bx]	;copying array element to cl
	cmp cl, threshold	;comparing cl and threshold
	jl printcl			;if cl<threshold then print cl
	inc bx				;increment counter
	cmp bx, len			;comparing counter and length
	jnz traverse		;if not equal, then continuing the loop
	jz checkIfNone
printcl:
	xor ax, ax
	mov al, cl
	mov cl, 10
	div byte ptr cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second2
	first1:	print al
second2: print cl
	mov ah, 9
	mov dx, offset space
	int 21h
	mov ch, 6
	inc bx
	cmp bx, len
	jl traverse
	;
checkIfNone:
	mov ah, 6
	cmp ch, ah
	jnz printNoNumber
	jz lookForEven
;
printNoNumber:
	mov ah, 9
	mov dx, offset nonumbers
	int 21h
	jmp lookForEven
;
;----------------------q3
	xor cl, cl
	xor bx, bx
	xor dh, dh
lookForEven:
	mov cl, array[bx]
	and cl, 1
	jz evenPrint
notEven:
	inc bx
	cmp bx, len
	jz printEvenCount
	jnz lookForEven
evenPrint:
	inc dh
	mov cl, array[bx]
	xor ax, ax
	mov al, cl
	mov cl, 10
	div byte ptr cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second3
	first3:	print al
	second3: print cl
	printsp
	inc bx
	cmp bx, len
	jz printEvenCount
	jnz lookForEven
printEvenCount:
	print dh
;
; call exit function to DOS
exit:
	mov ah,4ch
	int 21h
code ends
end start
stk segment stack
	db 128 DUP(?)
tos label word
stk ends
;
data segment
	array db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
	len equ $ - array
	nonumbers db "There are no numbers$"
	lengthStr db "length of array is $"
	belowThreshold db "Numbers below threshold $"
	evenNumbers db "Even numbers in the array $"
	evenNumbersCount db "Total number of even numbers $"
	evenNumbersAverage db "Average of the even numbers is $"
	evenNumbersSum db "Sum of even numbers $"
	primeNumbers db "Prime numbers in the array $"
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
printWithout30h MACRO val
	mov ah, 2
	mov dl, val
	int 21h
ENDM

printStr MACRO val
	mov ah, 9
	mov dl, val
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
;	div bx
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
	mov ah, 9
	mov dx, offset lengthStr
	int 21h
	mov ax, len
	;CALL NEAR PTR printd
	mov dx, 0
	mov bx, 10
	div bx
	mov cx, dx
	mov dl, 0
	cmp dl, al
	je second
	first:	print al
	second:	print cl
;
;-------------------------q2
	mov ah, 2
	mov dl, 0ah
	int 21h
	xor cl, cl
	xor bx, bx
	xor al, al
	xor cx, cx
	mov ah, 9
	mov dx, offset belowThreshold
	int 21h
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
	div cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second2
	first1:	print al
second2: print cl
	printsp
	mov ch, 6
	inc bx
	cmp bx, len
	jl traverse
;
checkIfNone:
	mov ah, 6
	cmp ch, ah
	jnz printNoNumber
	jz evenTraverse
;
printNoNumber:
	mov ah, 9
	mov dx, offset nonumbers
	int 21h
	mov ah, 2
	mov dl, 0ah
	int 21h
	jmp evenTraverse
;
;----------------------q3
	xor ax, ax
	;xor bx, bx
	xor cx, cx
	xor dx, dx
	;mov bx, len
evenTraverse:
	sub bx, 1
	xor ch, ch
	mov ah, 2
	mov dl, 0ah
	int 21h
	mov ah, 9
	mov dx, offset evenNumbers
	int 21h
lookForEven:
	xor ax, ax
	mov al, array[bx]
	mov cl, 2
	div cl
	mov dl, 0
	cmp ah, dl
	jz evenPrint
notEven:
	dec bx
	cmp bx, 0
	jz printEvenCount
	jnz lookForEven
evenPrint:
	xor ax, ax
	inc dh
	mov al, array[bx]
	add ch, al
	mov cl, 10
	div cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second3
	first3:	print al
	second3:
	print cl
	printsp
	dec bx
	cmp bx, 0
	jz printEvenCount
	jnz lookForEven
printEvenCount:
	xor ax, ax
	mov bh, dh
	mov ah, 2
	mov dl, 0ah
	int 21h
	mov ah, 9
	mov dx, offset evenNumbersCount
	int 21h
	xor ax, ax
	xor dx, dx
	mov al, bh
	mov cl, 10
	div cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second4
	first4:	print al
	second4:
	print cl
	printsp
	;
	mov ah, 2
	mov dl, 0ah
	int 21h
	mov ah, 9
	mov dx, offset evenNumbersAverage
	int 21h
	xor ax, ax
	mov al, ch
	mov dx, 0
	div bh
	mov cl, 10
	div cl
	mov cl, ah
	mov dl, 0
	cmp dl, al
	je second5
	first5:	print al
	second5:
	print cl	
	xor bx, bx
	mov ah, 2
	mov dl, 0ah
	int 21h
	mov ah, 9
	mov dx, offset primeNumbers
	int 21h
	jmp checkPrime
checkPrime:
	xor ax, ax
	xor dx, dx
	mov al, array[bx]
	cmp al, 2
	jz yesPrime
	cmp al, 4
	jz notPrime
	cmp al, 1
	jz notPrime
	mov dx, 0
	mov cl, 2
	div cl
	mov ch, al
	mov dx, 1
	;mov ch, 2
	primeLoop:
		cmp ch, 2
		jle yesPrime
		;divid test value by loop count
		xor ax, ax
		mov al, array[bx]
		mov dx, 0
		div ch
		;check remainder
		cmp ah, 0
		je notPrime
		sub ch, 1
		jmp primeLoop
		
	yesPrime:
		xor ax, ax
		xor dx, dx
		mov al, array[bx]
		mov cl, 10
		div cl
		mov cl, ah
		mov dl, 0
		cmp dl, al
		je second6
		first6:	print al
		second6:
		print cl
		printsp
		inc bx
		cmp bx, len
		jz exit
		jnz checkPrime
	notPrime:
		inc bx
		cmp bx, len
		jz exit
		jnz checkPrime
;
; call exit function to DOS
exit:
	mov ah,4ch
	int 21h
code ends
end start
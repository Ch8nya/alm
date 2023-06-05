section .data

msg1	db	"enter no: "
msg1_len	equ	$-msg1

msg2	db	"Factorial is: "
msg2_len	equ	$-msg2

msg3	db	"Error"
msg3_len	equ	$-msg3


section .bss

factorial 	resw	 1
n			resw 	 1
char_ans	resb	 4
buffer		resb	 5


%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro read 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro

section .text
 global _start
 _start:
	print msg1, msg1_len
	call accept16
	mov [n],bx

	mov cx,[n]
	mov word[factorial],1
	call facto

	mov ax,word[factorial]
	call disp10
	exit

facto:
	push rcx
	CMP rcx,1
	jne recursion
	jmp next

recursion:
	dec rcx
	call facto

next:
	pop rcx
	mov rax,rcx
	mul word[factorial]
	mov word[factorial],ax

	ret

disp10:
	MOV rbx,10
	MOV rcx,4
	MOV rsi,char_ans+3

back:
	mov rdx,0
	div rbx
	cmp dl,09h
	jbe add30
	add dl,07h

add30:
	add dl,30h

	mov [rsi],dl
	dec rsi
	dec rcx
	jnz back
	print char_ans,4
	ret

accept16:
	read buffer,5
	mov rcx,4
	mov rsi,buffer
	xor rbx,rbx

nb:
	shl rbx,4
	mov al,[rsi]

	cmp al,'0'
	jb Error
	cmp al,'9'
	jbe sub30

	cmp al,'A'
	jb Error
	cmp al,'F'
	jbe sub37

	cmp al,'a'
	jb Error
	cmp al,'f'
	jbe sub57

Error:
	print msg3, msg3_len

sub57:sub al,20h
sub37:sub al,07h
sub30:sub al,30h

	add bx,ax
	inc rsi
	dec rcx
	jnz nb

	ret
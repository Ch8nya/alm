section .data
	msg db "Enter string:",10
	msg_len equ $-msg

	msg2 db "Length :",10
	msg2_len equ $-msg2


section .bss
	char_ans resb 2
	n resb 20
	n_len equ $-n

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
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
	print msg,msg_len
	read n, n_len
	dec rax
	call display
	exit

display:
mov rbx,16
mov rcx,2
mov rsi,char_ans+1

back:
mov rdx,0

div rbx;
cmp dl,09h
jbe add30
add dl,07h

add30:
add dl,30h

mov[rsi],dl
dec rsi
dec rcx
jnz back
print msg2,msg2_len
print char_ans, 2
ret
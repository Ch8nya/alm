section .data
	array dq -10h,20h,30h,40h,50h,-60h
	n equ 6

	msg db "Positive Count :"
	msg_len equ $-msg

	msg2 db "Negative Count :"
	msg2_len equ $-msg2

%macro print 2
	MOV rax,1
	MOV rdi,1
	MOV rsi,%1
	MOV rdx,%2
	syscall
%endmacro

%macro read 2
	MOV rax,0
	MOV rdi,0
	MOV rsi,%1
	MOV rdx,%2
	syscall
%endmacro

%macro exit 0
	MOV rax,60
	MOV rdi,0
	syscall
%endmacro

section .bss
	p_count resq 1
	n_count resq 1
	char_ans resb 2

section .text
global _start

_start:
	MOV rsi, array
	MOV rcx,n
	MOV rbx,0
	MOV rdx,0

cnt:
	MOV rax,[rsi]
	SHL rax,1
	JC negative
	INC rbx
	JMP next

negative:
	INC rdx

next:
	ADD rsi,8
	DEC rcx
	JNZ cnt

MOV [p_count],rbx
MOV [n_count],rdx


print msg,msg_len
mov rax,[p_count]
call display

print msg2,msg2_len
mov rax,[n_count]
call display
exit

display:
	MOV	rbx,16
	MOV	rcx,2
	MOV	rsi,char_ans+1
	
back:
	MOV	rdx,0
	DIV	rbx

	CMP	dl,09h
	JBE	add30
	add	dl,07h

add30:
	ADD	dl,30h
	
	MOV	[rsi],dl
	DEC	rsi
	DEC	rcx
	JNZ	back
	print	char_ans,2
	ret

	

	
	

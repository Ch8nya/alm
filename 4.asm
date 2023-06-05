section .data
	msg db 	"Enter HEX no: "
	msg_len	equ 	$-msg

	msg2		db 		"Equivalent BCD is: "
	msg2_len	equ 	$-msg2

	msg3		db 		"Invalid input"
	msg3_len	equ 	$-msg3

	nline db 10
	_nline equ $-nline

section .bss
	buffer resb 5
	ans resb 4
	char_ans resb 4

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


section .text
	global _start
_start:
	print msg,msg_len
	call accept_16
	exit

accept_16:
	read buffer,5
	MOV rcx,4
	MOV rsi,buffer
	XOR bx,bx

next_byte:
	SHL bx,4
	MOV al,[rsi]

	CMP al,'0'
	jb ERROR
	CMP al,'9'
	jbe sub30

	CMP al,'A'
	jb ERROR
	CMP al,'F'
	jbe sub37

	CMP al,'a'
	jb ERROR
	CMP al,'f'
	jbe sub57

ERROR:
	print msg3,msg3_len
	exit

sub57: SUB al,20h
sub37: SUB al,07h
sub30: SUB al,30h

	ADD BX,AX
	INC RSI
	DEC RCX
	JNZ next_byte


	mov AX,BX
	call display
	ret

display:
	mov rbx,10
	mov rcx,4
	mov rsi,char_ans+3

back:
	mov rdx,0
	div rbx;rax/rbx
	cmp dl,09h
	jbe add30  
	add dl,27h


add30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz back
	print char_ans,4
	print nline, _nline
	ret

section .data
	msg		db 		"Enter BCD no: "
	msg_len	equ 	$-msg

	msg2		db 		"Equivalent HEX is: "
	msg2_len	equ 	$-msg2

	nline	db	10
	_nline	equ $-nline

section .bss
	buffer resb 6
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
	call BCD_HEX
	exit

BCD_HEX:
	print msg,msg_len
	read buffer,6
	MOV rsi,buffer
	XOR ax,ax
	MOV rbp,5
	MOV rbx,10

next:
	XOR cx,cx
	MUL bx
	MOV cl,[rsi]
	SUB cl,30h
	ADD ax,cx

	INC rsi
	DEC rbp
	JNZ next

	MOV [ans],ax
	print msg2,msg2_len

	MOV ax,[ans]
	call display
	ret

display:
	MOV rbx,16
	MOV rcx,4
	MOV rsi,char_ans+3

back:
	MOV rdx,0
	DIV rbx

	CMP dl,09h
	JBE add30
	ADD dl,07h

add30:
	ADD dl,30h

	MOV [rsi],dl
	DEC rsi
	DEC rcx
	JNZ back

	print char_ans,4
	print nline,_nline
	ret
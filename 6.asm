;block transfer non overlap without string
section .data
	space db " "
	smsg	db	"Source block: "
	smsg_len	equ	$-smsg

	dmsg	db	"Destination block: "
	dmsg_len	equ	$-dmsg

	bmsg	db	"Before transfer: "
	bmsg_len	equ	$-bmsg

	amsg	db	"After transfer: "
	amsg_len	equ	$-amsg

	sblock db 10h,20h,30h,40h,50h
	dblock times 5 db 0

	nline db 10
	_nline equ $-nline

section .bss
	char_ans resb 2


%macro print 2
	MOV	rax,1
	MOV	rdi,1
	MOV	rsi,%1
	MOV	rdx,%2
	syscall
%endmacro

%macro read 2
	MOV 	rax,0
	MOV	rdi,0
	MOV	rsi,%1
	MOV	rdx,%2
	syscall
%endmacro

%macro exit 0
	MOV	rax,60
	MOV	rdi,0
	syscall
%endmacro


section .text
	global _start
_start:

	print bmsg,bmsg_len

	print smsg,smsg_len
	mov rsi,sblock
	call disp_block

	print dmsg,dmsg_len
	mov rsi,dblock
	call disp_block

	call BT_NO
	print amsg,amsg_len

	print smsg,smsg_len
	mov rsi,sblock
	call disp_block

	print dmsg,dmsg_len
	mov rsi,dblock
	call disp_block
	exit

BT_NO:
	MOV rsi, sblock
	MOV rdi, dblock
	MOV rcx,5

next_index:
	MOV al,[rsi]
	MOV [rdi],al

	INC rsi
	INC rdi
	DEC rcx
	jnz next_index
	ret

disp_block:
	MOV rbp,5

next_num:
	MOV al,[rsi]
	PUSH rsi

	CALL disp_8
	print space,1

	POP rsi
	INC rsi
	DEC rbp
	JNZ next_num
	print nline,_nline
RET

disp_8:
	MOV	rbx,16
	MOV	rcx,2
	MOV	rsi,char_ans+1

next_digit:
	XOR	rdx,rdx
	div	rbx
	
	CMP	dl,09h
	JBE	add30
	ADD	dl,07h
add30:
	ADD	dl,30h
	MOV	[rsi],dl

	DEC	rsi
	DEC	rcx
	JNZ	next_digit
	print	char_ans,2
RET
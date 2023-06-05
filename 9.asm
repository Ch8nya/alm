;block transfer overlap with string
section .data
	bmsg		db		10,"before transfer "
	bmsg_len 	equ		$-bmsg
	
	amsg		db		10,"after transfer "
	amsg_len 	equ		$-amsg
	
	smsg		db		10,"source block  :"
	smsg_len 	equ		$-smsg
	
	dmsg		db		10,"destination block  :"
	dmsg_len 	equ		$-dmsg
	
	sblock		db		11h,12h,13h,14h,15h
	dblock		times 5 db	0
	
	space		db		" "
	
;--------------------------------------------------------------
	
section .bss
	char_ans	resb		2    ;coz we have 2 bytes nos
	
;--------------------------------------------------------------------

%macro	print	2
	 MOV	RAX,1
	 MOV	RDI,1
         MOV	RSI,%1
         MOV	RDX,%2
    syscall
%endmacro

%macro	read	2
	 MOV	RAX,0
	 MOV	RDI,0
         MOV	RSI,%1
         MOV	RDX,%2
    syscall
%endmacro


%macro exit 	0
	;print	nline,nline_len
	MOV	RAX,60
        MOV	RDI,0
    syscall
%endmacro

;------------------------------------------------------------------------

section .text

	global _start
	
_start:
	print		bmsg,bmsg_len
	print		smsg,smsg_len
	
	mov		rsi,sblock
	call		disp_block
	
	print		bmsg,bmsg_len
	print		dmsg,dmsg_len
	
	mov		rsi,dblock-2
	call		disp_block
	
	call		BT_NO
	
	print		amsg,amsg_len
	
	print		smsg,smsg_len
	mov		rsi,sblock
	call		disp_block
	
	print		dmsg,dmsg_len
	mov		rsi,dblock-2
	call		disp_block
	
exit

BT_NO:
	mov		rsi,sblock+4
	mov		rdi,dblock+2
	mov		rcx,5
	
	std
	rep		movsb
ret

disp_block:
	mov		rbp,5
	
next_num:
	mov		al,[rsi]
	push		rsi		;push rsi on stack as it get modified in disp_8
	
	call		disp_8
	print		space,1
	
	pop		rsi		;again pop rsi that pushed on stack
	inc		rsi
	
	dec		rbp
	jnz		next_num
ret
;---------------------------------------------------------------------------------------

disp_8:
	mov		rsi,char_ans+1
	mov		rcx,2
	mov		rbx,16
	
next_digit:
	xor		rdx,rdx
	div		rbx
	
	cmp		dl,09h
	jbe		add30
	add		dl,07h
	
add30:
	ADD		DL,30H
	MOV		[RSI],DL

	DEC		RSI
	DEC		RCX
	JNZ		next_digit

	print		char_ans,2
ret

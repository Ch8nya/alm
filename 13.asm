section .data
 
menu       db 10,"1.hex to bcd"
           db 10,"2.bcd to hex"
           db 10,"3.exit"
           db 10,"enter your choice",10
           menu_len equ $-menu
hmsg db 10,"enter 4 digit hex number::"
hmsg_len equ $-hmsg
 
 
bmsg db 10,"enter 5 digit bcd number::"
bmsg_len equ $-bmsg
 
ebmsg db 10,"the equivalent bcd number is::"
ebmsg_len equ $-ebmsg
 
emsg db 10,"the equivalent hex no is::"
esmg_len equ $-emsg
 
amsg db 10,"invalid no. input::",10
amsg_len equ $-amsg
 
nline db 10
_nline equ $-nline
 
%macro print 2
mov rax, 1
mov rdi, 1
mov rsi, %1
mov rdx, %2
syscall
%endmacro
 
%macro exit 0
mov rax, 60
mov rdi, 0
syscall
%endmacro
 
%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro
 
section .bss
    buf   resb 6
 
    char_ans  resb 4
    ans   resw 1
 
 
section .text
 
global _start
_start:
 
MENU:  print menu,menu_len
       read  buf,2
 
   mov  al,[buf]
 
case1:    cmp al,'1'
          jne case2
          call HEX_BCD
          JMP  MENU
 
 
case2:    cmp al,'2'
          jne case3
          call BCD_HEX
          JMP  MENU
 
case3:    cmp al,'3'
          jne INVALID
          exit
 
INVALID:
      print amsg,amsg_len
      Jmp MENU
 
 
 
BCD_HEX:
 
print bmsg,bmsg_len
read buf,6
 
mov rsi,buf
xor ax,ax
mov rbp,5
mov rbx,10
 
next:
xor cx,cx
mul bx
mov cl,[rsi]
sub cl,30h
add ax,cx
 
inc rsi
dec rbp
jnz next
 
mov [ans],ax
print hmsg,hmsg_len
 
mov ax,[ans]
call display_hex 
ret
 
;display
 
display_hex:
mov rbx,16
mov rcx,4
mov rsi,char_ans+3
 
back_hex:
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
jnz back_hex
print char_ans,4
print nline, _nline
ret
 
 
 
HEX_BCD:
read buf,5
MOV RCX,4
MOV RSI,buf
XOR BX,BX
 
next_byte:
SHL BX,4
MOV AL,[RSI]
 
CMP AL,'0'
JB ERROR
CMP AL,'9'
JBE SUB30
 
CMP AL,'A'
JB ERROR
CMP AL,'F'
JBE SUB37
 
 
CMP AL,'a'
JB ERROR
CMP AL,'f'
JBE SUB57
 
ERROR:
     print amsg,amsg_len
 
SUB57: SUB AL,20H
SUB37: SUB AL,07H
SUB30: SUB AL,30H
 
ADD BX,AX
INC RSI
DEC RCX
JNZ next_byte
 
 
mov AX,BX
call display_BCD 
ret
 
;display
 
display_BCD:
mov rbx,10
mov rcx,4
mov rsi,char_ans+3
 
back_BCD:
mov rdx,0
div rbx;rax/rbx
cmp dl,09h
jbe add30a  
add dl,27h
 
 
add30a:
add dl,30h
mov [rsi],dl
dec rsi
dec rcx
jnz back_BCD
print char_ans,4
print nline, _nline
ret

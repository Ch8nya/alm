section .data
    msg db "Hex No is: ",10
    msg_len equ $-msg

section .bss
    char_ans    resb    2

%macro print 2
    MOV rax,1
    MOV rdi,1
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
    MOV rax,30
    call display
    exit

display:
    MOV rbx,16
    MOV rcx,2
    MOV rsi,char_ans+1

back:
    MOV rdx,0
    DIV rbx
    CMP dl,09h
    jbe add30
    ADD dl,07h

add30:
    ADD dl,30h
    MOV [rsi],dl
    DEC rsi
    DEC rcx
    JNZ back
    print char_ans,2
    ret
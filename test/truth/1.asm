;section .bss
;    resb 2*32
;
;section file1data   ;自定义file1data
;    strHello db "hello,youyifeng!",0Ah
;    STRLEN equ $-strHello
;   ; strHello db "Hello,world.",0Ah
   ; STRLEN equ $-strHello
;
;section file1text   ;自定义代码段file1text
;    extern print    ;声明print函数
;    global _start   ;连接器把_start当做程序的入口
;
;_start:
;    push STRLEN     ;传入参数字符串的长度
;    push strHello   ;传入参数strHello
;    call print      ;调用print函数
;    ;返回到系统
;    mov ebx,0           ;返回值4
;    mov eax,1           ;胸调用号:sys_exit
;    int 0x80            ;系统调用
section .bss
    resb 2*32

segment file111data
    strHello db "hello,youyifeng!",0Ah
    STRLEN equ $-strHello

section file1text
    extern print
    global _start

_start:
    push STRLEN
    push strHello
    call print
    
    mov ebx,0
    mov eax,1
    int 0x80

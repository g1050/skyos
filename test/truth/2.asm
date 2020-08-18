;section .text
;    mov eax,0x10
;    jmp $
;
;section file2data   ;自定义数据段file2data
;    file2var db 3
;
;section file2text   ;自定义代码段
;    global print        ;导出print函数
;
;;定义print函数,print("Hello,World.",len(str))
;print:
;    mov edx,[esp+8]     ;字符串长度的参数,参数2
;    mov ecx,[esp+4]     ;字符串
;
;    mov ebx,1
;    mov eax,4           ;sys_write
;    int0x80 :            ;系统调用a
;    ret

section .text
mov eax,0x10
jmp $
section file2data
file2var db 3
section file2text
global print
print:
mov edx,[esp+8]
mov ecx,[esp+4]
mov ebx,1
mov eax,4
int 0x80
ret

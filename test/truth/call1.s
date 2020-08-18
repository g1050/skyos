;call near near_proc
;call near 和 call 是类似的　默认是进调用
;相对近调用
;近调用必须用相对地址,这是硬件决定的．

;------------------------------------  
;call near指令的操作码是0xe8,操作数是调用函数的相对地址
;计算方式:绝对地址-call指令的地址然后-call指令大小(e6一字节+操作数两字节)
SECTION gxk vstart=0x900

call near_proc
    jmp $
    addr dd 4
near_proc:
    mov ax,0x1234
    ret

jmp $
times 510-($-$$) db  0x00
db 0x55,0xaa


;将es寄存器指向文本模式缓冲区的基地址
mov ax,0xb800
mov es,ax

;控制要显示的字符

;段超越前缀es
mov byte [es:0x00],'H'
;0000 0111 黑底白字
mov byte [es:0x01],0x07

mov byte [es:0x02],'e'
;1010 0100 绿底红字闪烁
mov byte [es:0x03],0xa4

mov byte [es:0x04],'l'
;0000 0111 黑底白字
mov byte [es:0x05],0x07

mov byte [es:0x06],'l'
;0000 0111 黑底白字
mov byte [es:0x03],0xa4

mov byte [es:0x08],'o'
;0000 0111 黑底白字
mov byte [es:0x09],0x07

label: jmp label
times 510-($-$$) db 0
db 0x55,0xaa

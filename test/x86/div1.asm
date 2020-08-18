;除数要求放在ax寄存器中
mov ax,0x0005

;被除数放在8位寄存器或者内存单元中
mov cl,0x02

div cl
;计算结果的商放在AL中,余数放在AH中
 times 510-($-$$) db 0
 db 0x55,0xaa

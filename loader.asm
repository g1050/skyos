%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR  ;没分段段地址还是0
mov bx,0

mov byte [gs:bx],'2'
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],' '
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],'L'
inc bx
mov byte [gs:bx],0xa4
inc bx


mov byte [gs:bx],'O'
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],'A'
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],'D'
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],'E'
inc bx
mov byte [gs:bx],0xa4
inc bx

mov byte [gs:bx],'R'
inc bx
mov byte [gs:bx],0xa4
inc bx

 jmp $


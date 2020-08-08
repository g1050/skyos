;程序功能:打印字符串,背景色是黑色,前景色是绿色．

;主引导程序
;开机的时候CS:IP寄存器被强制指向0xFFFF0,就是BIOS的入口
;BIOS只有16字节空间,0xFFF0处是一个命令jmp far f000:e05b
;指向0xfe05b就是BIOS真正开始的地方,该处是固件,是刻RAM在上的程序
;BIOS最后一项工作是检查0盘0扇道1扇区的最后512字节处,并将该处的从程序加载到0x7c00处
;jmp 0:ox7c00

;------------------------
;vstart 表示起始地址编译为0x7c00
SECTION MBR vstart=0x7c00
    ;------------------------
    mov ax,cs ;ax = 0
    mov ds,ax ;as = 0
    mov es,ax ;es = 0
    mov ss,ax ;ss = 0
    mov fs,ax ;fs = 0
    mov sp,0x7c00 ;栈顶指针移动到0x7c00位置

    ;------------------------
    ;清屏
    mov ax,0x600
    mov bx,0x700
    mov cx,0
    mov dx,0x184f

    int 0x10
    ;------------------------
    ;打印前的准备工作
    mov ah,3
    mov bh,0

    int 0x10
    ;------------------------
    ;打印字符
    mov ax,message
    mov bp,ax

    mov cx,5
    mov ax,0x1301
    mov bx,0x2
    int 0x10
    ;------------------------

    jmp $

    message db "1 MBR "
    times 510-($-$$) db 0

    ;0扇区的最后两个字节存放0x55,0xaa
    db 0x55,0xaa

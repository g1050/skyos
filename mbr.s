;程序功能:打印字符串,背景色是黑色,前景色是绿色．

;主引导程序
;开机的时候CS:IP寄存器被强制指向0xFFFF0,就是BIOS的入口
;BIOS只有16字节空间,0xFFF0处是一个命令jmp far f000:e05b
;指向0xfe05b就是BIOS真正开始的地方,该处是固件,是刻RAM在上的程序
;BIOS最后一项工作是检查0盘0扇道1扇区的最后512字节处,并将该处的从程序加载到0x7c00处
;jmp 0:ox7c00

;------------------------
;vstart 表示起始地址编译为0x7c00
;0x7c00是因为最开始是43kB的内存,所以选择把MBR放在了最后一个KB
;MBR本身大小是512KB,但是还有为其开辟相应的栈空间
;所以预留了1KB的空间

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
    mov ax,0x600    ;AH高八位设置为6号
    ;其他寄存器做相应的设置
    mov bx,0x700    ;BH上卷行属性
    mov cx,0        ;CL,CH (X,Y)窗口左上角的位置
    mov dx,0x184f   ;DL,DH (X,Y)右下角的位置

    int 0x10        ;调用int0x10中断

    ;------------------------
    ;打印前的准备工作
    mov ah,3        ;3号子功能,读光标的位置
    mov bh,0        ;设置页号

    int 0x10

    ;------------------------
    ;打印字符
    mov ax,message  ;把message地址存入ax
    mov bp,ax       ;

    mov cx,5
    mov ax,0x1301   ;13号功能打印字符串
    mov bx,0x2      ;设置页号和字符属性
    int 0x10
    ;------------------------

    jmp $           ;这是个死循环吧

    message db "Hellosky-os!!!"
    times 510-($-$$) db 0   ;重复填充0

    ;0扇区的最后两个字节存放0x55,0xaa
    db 0x55,0xaa

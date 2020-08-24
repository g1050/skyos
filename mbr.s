;程序功能:打印字符串,背景色是黑色,前景色是绿色．

;主引导程序
;开机的时候CS:IP寄存器被强制指向0xFFFF0,就是BIOS的入口
;BIOS只有16字节空间,0xFFF0处是一个命令jmp far f000:e05b
;指向0xfe05b就是BIOS真正开始的地方,该处是固件,是刻RAM在上的程序
;BIOS最后一项工作是检查0盘0扇道1扇区的最后512字节处,并将该处的从程序加载到0x7c00处
;jmp 0:ox7c00

;------------------------
;vstart 表示起始地址编译为0x7c00,因为段地址是0x0000,要是不用vstart还需要手动加上0x7c00
;0x7c00是因为最开始是63kB的内存,所以选择把MBR放在了最后一个KB
;MBR本身大小是512B,但是还有为其开辟相应的栈空间
;所以预留了1KB的空间

;因为我们知道程序被加载到了0x7c00处,所以提前告诉编译器,最后让CPU直接从0x7c00处读取数据
%include "boot.inc"

SECTION MBR vstart=0x7c00
    ;------------------------
    mov ax,cs ;ax = 0
    mov ds,ax ;as = 0
    mov es,ax ;es = 0
    mov ss,ax ;ss = 0
    mov fs,ax ;fs = 0
    mov sp,0x7c00 ;栈顶指针移动到0x7c00位置
    mov ax,0xb800   ;ax指向显存位置
    mov gs,ax       ;gs = 0xb800

    ;------------------------
    ;清屏
    mov ax,0x600    ;AH高八位设置为6号
    ;其他寄存器做相应的设置
    mov bx,0x700    ;BH上卷行属性
    mov cx,0        ;CL,CH (X,Y)窗口左上角的位置
    mov dx,0x184f   ;DL,DH (X,Y)右下角的位置

    int 0x10        ;调用int0x10中断

    ;输出背景色为绿色,前景色为红色,闪烁的字符串"1 MBR"
    mov bx,0

    mov byte [gs:bx],'1'
    inc bx
    mov byte [gs:bx],0xA4
    inc bx

    mov byte [gs:bx],' '
    inc bx
    mov byte [gs:bx],0xA4
    inc bx

    mov byte [gs:bx],'M'
    inc bx
    mov byte [gs:bx],0xA4
    inc bx

    mov byte [gs:bx],'B'
    inc bx
    mov byte [gs:bx],0xA4
    inc bx

    mov byte [gs:bx],'R'
    inc bx
    mov byte [gs:bx],0xA4
    inc bx

;    ;打印前的准备工作
;    mov ah,3        ;3号子功能,读光标的位置
;    mov bh,0        ;设置页号
;
;    int 0x10
;
;    ;------------------------
;    ;打印字符
;    mov ax,message  ;把message地址存入ax
;    mov bp,ax       ;
;
;    mov cx,5
;    mov ax,0x1301   ;13号功能打印字符串
;    mov bx,0x2      ;设置页号和字符属性
;    int 0x10
;    ;------------------------

    mov eax,LOADER_START_SECTOR    ;起始扇区1ba的地址
    mov bx,LOADER_BASE_ADDR         ;写入的地址
    mov cx,1        ;要写入的扇区数
    call rd_disk_m_16               ;以下读取程序的起始部分(一个扇区),调用这个过程

    jmp LOADER_BASE_ADDR

;输入eax:起始逻辑扇区号 bx:目标地址 cx:写入扇区数
rd_disk_m_16:
    mov esi,eax     ;备份扇区号
    mov di,cx       ;备份cx
;读写硬盘,五个步骤读写硬盘
    ;设置要读取的扇区号
    mov dx,0x1f2    ;0x1f2端口写入要读取的扇区数
    mov al,cl
    out dx,al       ;读取的扇区数
    
    mov eax,esi     ;恢复eax
    ;将LBA地址存入0x1f3-0x1f6
    ;LBA地址7-0位写入端口
    mov dx,0x1f3
    out dx,al
    ;0x1f4
    mov cl,8
    shr eax,cl
    mov dx,0x1f4
    out dx,al
    ;0x1f5
    shr eax,cl
    mov dx,0x1f5
    out dx,al
    ;0x1f6
    shr eax,cl
    and al,0x0f
    or al,0xe0
    mov dx,0x1f6
    out dx,al
    ;向0x1f7写入读命令
    mov dx,0x1f7
    mov al,0x20
    out dx,al
    ;检查磁盘状态
    .not_ready:
        nop
        in al,dx
        and al,0x88
        cmp al,0x08
        jnz .not_ready
    ;从0x1f0端口取出数据
    mov ax,di
    mov dx,256
    mul dx          ;计算读取次数,每次读入一个字
    mov cx,ax
    mov dx,0x1f0

    .go_on_read:
        in ax,dx
        mov [bx],ax
        add bx,2
        loop .go_on_read
        ret

    ;jmp $           ;这是个死循环吧
    

    ;message db "Hellosky-os!!!"
    times 510-($-$$) db 0   ;重复填充0

    ;0扇区的最后两个字节存放0x55,0xaa
    db 0x55,0xaa

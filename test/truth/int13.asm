

;将数据读取到内存0x900
LOAD_BASE_ADDR equ 0x9000

;mov ax,0x1
;call LBA_to_CHS

mov ax,0
mov es,ax
mov bx,LOAD_BASE_ADDR

;设置int13的入口参数
mov ah,0x2      ;0x2号功能是读取磁盘
mov ax,1        ;要读取的扇区数

mov ch,0        ;柱面
mov cl,2        ;扇区号
mov dh,0        ;磁头

mov dl,0x80     ;硬盘 
int 0x13

;然后通过终端在屏幕上显示
mov ax,0x600
mov bx,0x700
mov cx,0
mov dx,0x184f
int 0x10

mov ah,3
mov bh,0

int 0x10

mov ax,LOAD_BASE_ADDR
;mov bx,LOAD_BASE_ADDR
;mov byte [es:bx],'s'
;xor di,di
;mov si,1
;mov bx,LOAD_BASE_ADDR
;call read_hard_disk_0
mov bp,ax       
mov cx,10
mov ax,0x1301
mov bx,0x2
int 0x10
jmp $

;*******************************************************
;-------------------------------------------------------------------------------
read_hard_disk_0:                        ;从硬盘读取一个逻辑扇区

;输入：DI:SI=起始逻辑扇区号
;      DS:BX=目标缓冲区地址
;过程调用前保存寄存器中的信息
push ax
push bx
push cx
push dx

;硬盘每个PATA和SATA接口分配了8个端口
;主硬盘接口是0x1f0-0x1f7
mov dx,0x1f2                    ;该端口用来设置读取的扇区个数
mov al,1                        ;先读取一个扇区,根据这个扇区的内容选择继续读取多少个扇区
out dx,al                       ;读取的扇区数

;因为物理地址是20位，所以需要四个8位端口来存放地址
;程序在硬盘上的起始逻辑扇区号100存储在si和di上

inc dx                          ;0x1f3
mov ax,si                       ;SI中装着低16位
out dx,al                       ;LBA地址7~0
;100D = 64H

inc dx                          ;0x1f4
mov al,ah
out dx,al                       ;LBA地址15~8
;0x00

inc dx                          ;0x1f5
mov ax,di                       ;di中装着高16位
out dx,al                       ;LBA地址23~16
;0x00

;设置模式
inc dx                          ;0x1f6
mov al,0xe0                     ;LBA28模式，主盘
or al,ah                        ;LBA地址27~24
out dx,al
;0xe0 1110 0000 表示哦LBA模式,主硬盘

;设置是读还是写指令
inc dx                          ;0x1f7
mov al,0x20                     ;读命令
out dx,al

;准备工作已经完成
;-------------------------------------------------------------------------------

.waits:
in al,dx
and al,0x88
cmp al,0x08
jnz .waits                      ;不忙，且硬盘已准备好数据传输 

mov cx,256                      ;总共要读取的字数
mov dx,0x1f0                    ;0x1f0是硬盘的数据端口

.readw:
in ax,dx                        ;dx > ax 
mov [bx],ax
add bx,2                        ;bx向上偏移一个字
loop .readw                     ;循环直到读完256个字

;恢复寄存器中的信息
pop dx
pop cx
pop bx
pop ax

ret
;函数调用结束



;*******************************************************
; LBA_to_CHS() - LBA Converting CHS for floppy diskette
;
; description:
; input:
;        ax - LBA sector
;
; output:
;        ch - cylinder
;        cl - sector ( 1 - 63 )
;        dh - head
;*******************************************************

LBA_to_CHS:

%define SPT        18
%define HPC        2


mov cl, SPT
div cl                           ; al = LBA / SPT, ah = LBA % SPT


; cylinder = LBA / SPT / HPC

mov ch, al
shr ch, (HPC / 2)                ; ch = cylinder               


; head = (LBA / SPT) % HPC

mov dh, al
and dh, 1                        ; dh = head


; sector = LBA % SPT + 1

mov cl, al
inc cl                           ; cl = sector

ret
times 510-($-$$) db 0
db 0x55,0xaa

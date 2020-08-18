         ;代码清单6-1
         ;文件名：c06_mbr.asm
         ;文件说明：硬盘主引导扇区代码
         ;创建日期：2011-4-12 22:12 
      
         ;相对进转移
         jmp near start
         ;定义数据
  mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
            'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
  number db 0,0,0,0,0
  
  start:
        ;定义数据段的基地址
         mov ax,0x7c0                  ;设置数据段基地址 
         mov ds,ax
         
         ;显存的基地址
         mov ax,0xb800                 ;设置附加段基地址 
         mov es,ax
         
         ;clear direct flag
         ;DF=0 表示正向表示从内存下往上
         ;std DF=1
         cld
         ;source 源地址
         mov si,mytext                 
         ;目标地址偏移量为0
         mov di,0
         ;CX中记录要传输的字节或者字
         mov cx,(number-mytext)/2      ;实际上等于 13
         ;rep repeat 根据CX的值进行repeat
         rep movsw
     
         ;得到标号所代表的偏移地址
         mov ax,number
         
         ;计算各个数位
         ;bx中存放number的地址
         mov bx,ax

         mov cx,5                      ;循环次数 
        ;除数放在Si中
         mov si,10                     ;除数 
  digit: 
         xor dx,dx                     ;dx清零
         div si                        ;被除数除以10
         mov [bx],dl                   ;保存数位,将余数保存在number后面
         inc bx                         ;自增
         loop digit                     ;循环
         
         ;显示各个数位
         mov bx,number 
         mov si,4                      
   show:
         mov al,[bx+si]
         add al,0x30
         mov ah,0x04
         mov [es:di],ax
         add di,2
         dec si
         jns show
         
         mov word [es:di],0x0744

         jmp near $

  times 510-($-$$) db 0
                   db 0x55,0xaa

         ;�����嵥6-1
         ;�ļ�����c06_mbr.asm
         ;�ļ�˵����Ӳ����������������
         ;�������ڣ�2011-4-12 22:12 
      
         ;��Խ�ת��
         jmp near start
         ;��������
  mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
            'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
  number db 0,0,0,0,0
  
  start:
        ;�������ݶεĻ���ַ
         mov ax,0x7c0                  ;�������ݶλ���ַ 
         mov ds,ax
         
         ;�Դ�Ļ���ַ
         mov ax,0xb800                 ;���ø��Ӷλ���ַ 
         mov es,ax
         
         ;clear direct flag
         ;DF=0 ��ʾ�����ʾ���ڴ�������
         ;std DF=1
         cld
         ;source Դ��ַ
         mov si,mytext                 
         ;Ŀ���ַƫ����Ϊ0
         mov di,0
         ;CX�м�¼Ҫ������ֽڻ�����
         mov cx,(number-mytext)/2      ;ʵ���ϵ��� 13
         ;rep repeat ����CX��ֵ����repeat
         rep movsw
     
         ;�õ�����������ƫ�Ƶ�ַ
         mov ax,number
         
         ;���������λ
         ;bx�д��number�ĵ�ַ
         mov bx,ax

         mov cx,5                      ;ѭ������ 
        ;��������Si��
         mov si,10                     ;���� 
  digit: 
         xor dx,dx                     ;dx����
         div si                        ;����������10
         mov [bx],dl                   ;������λ,������������number����
         inc bx                         ;����
         loop digit                     ;ѭ��
         
         ;��ʾ������λ
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

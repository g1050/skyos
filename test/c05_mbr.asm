         ;�����嵥5-1 
         ;�ļ�����c05_mbr.asm
         ;�ļ�˵����Ӳ����������������
         ;�������ڣ�2011-3-31 21:15 
         
         mov ax,0xb800                 ;ָ���ı�ģʽ����ʾ������
         mov es,ax

         ;������ʾ�ַ���"Label offset:"
         mov byte [es:0x00],'G'
         mov byte [es:0x01],0x07
         mov byte [es:0x02],'x'
         mov byte [es:0x03],0x07
         mov byte [es:0x04],'k'
         mov byte [es:0x05],0x07
         mov byte [es:0x06],'!'
         mov byte [es:0x07],0x07
         mov byte [es:0x08],'l'
         mov byte [es:0x09],0x07
         mov byte [es:0x0a],' '
         mov byte [es:0x0b],0x07
         mov byte [es:0x0c],"o"
         mov byte [es:0x0d],0x07
         mov byte [es:0x0e],'f'
         mov byte [es:0x0f],0x07
         mov byte [es:0x10],'f'
         mov byte [es:0x11],0x07
         mov byte [es:0x12],'s'
         mov byte [es:0x13],0x07
         mov byte [es:0x14],'e'
         mov byte [es:0x15],0x07
         mov byte [es:0x16],'t'
         mov byte [es:0x17],0x07
         mov byte [es:0x18],':'
         mov byte [es:0x19],0x07

         ;--------��ӡnumber�Ļ���ַ
         mov ax,number                 ;ȡ�ñ��number��ƫ�Ƶ�ַ
         mov bx,10

         ;�������ݶεĻ���ַ,���ݶεĻ���ַ�ʹ�����غ�
         mov cx,cs
         mov ds,cx

         ;���λ�ϵ�����
         ;������0x0000 number
         ;������16λ��,���Դ˴���AX:DX/bx
         mov dx,0
         div bx
         ;��0x7c00��ԭ��,���򱻼�����0x0000:0x7c00
         mov [0x7c00+number+0x00],dl   ;�����λ�ϵ�����
         ;��DL�е����������ڸ�λ��,����Ȼ��AX��

         ;��ʮλ�ϵ�����
         xor dx,dx ;dx����
         div bx
         mov [0x7c00+number+0x01],dl   ;����ʮλ�ϵ�����

         ;���λ�ϵ�����
         xor dx,dx
         div bx
         mov [0x7c00+number+0x02],dl   ;�����λ�ϵ�����

         ;��ǧλ�ϵ�����
         xor dx,dx
         div bx
         mov [0x7c00+number+0x03],dl   ;����ǧλ�ϵ�����

         ;����λ�ϵ����� 
         xor dx,dx
         div bx
         mov [0x7c00+number+0x04],dl   ;������λ�ϵ�����

         ;������ʮ������ʾ��ŵ�ƫ�Ƶ�ַ
         ;ʮ����x��Ӧ��ASCII��0x3x
         mov al,[0x7c00+number+0x04]
         add al,0x30
         mov [es:0x1a],al
         mov byte [es:0x1b],0x04
         
         mov al,[0x7c00+number+0x03]
         add al,0x30
         mov [es:0x1c],al
         mov byte [es:0x1d],0x04
         
         mov al,[0x7c00+number+0x02]
         add al,0x30
         mov [es:0x1e],al
         mov byte [es:0x1f],0x04

         mov al,[0x7c00+number+0x01]
         add al,0x30
         mov [es:0x20],al
         mov byte [es:0x21],0x04

         mov al,[0x7c00+number+0x00]
         add al,0x30
         mov [es:0x22],al
         mov byte [es:0x23],0x04
         
         mov byte [es:0x24],'D'
         mov byte [es:0x25],0x07
          
   infi: jmp near infi                 ;����ѭ��

;�������������,������ĸ�ʮ��ǧ��
  number db 0,0,0,0,0
  times 203 db 0
            db 0x55,0xaa

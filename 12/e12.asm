; 编写0号中断的处理程序，使得在除法溢出时，在屏幕中间显示字符串“divide error!”,然后返回DOS
; 仔细跟踪调试，在理解整个过程。
assume cs:code,ss:stack
stack segment
    db 32 dup (0)
stack ends
code segment
start:
; 程序初始化
    mov ax,stack
    mov ss,ax
    mov sp,32
; 装载do0
    mov ax,cx
    mov ds,ax
    mov si,offset do0
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset do0end - offset do0 ; 设置es:di指向目的地址
    cld
    rep movsb

; 设置中断向量表
    mov word ptr es:[0],200H
    mov word ptr es:[2],0

; test case: 制造除法溢出
    mov ax,1000H
    mov bl,1
    div bl

mov ax,4c00H
int 21H

do0:
    jmp short do0start
    db "divide error!"
    ; 保存用到寄存器
    push ax
    push cx
    push ds
    push es
    push si
    push di
do0start:
    ; 处理中断
    mov ax,cs
    mov ds,ax
    mov si,202H         ;设置ds:si指向字符串(这个地方的hardcode有待优化为offset计算)

    mov ax,0b800H
    mov es,ax
    mov di,12*160+36*2  ; 设置es:di指向显存空间的中间位置

    mov cx,13           ; 设置cx为字符串长度
s:  mov al,[si]
    mov es:[di],al
    inc si
    add di,2
    loop s
    ; 恢复用到的寄存器
    pop di
    pop si
    pop ax
    mov es,ax
    pop ax
    mov ds,ax
    pop cx
    pop ax
    ; 用iret指令返回
    iret
    mov ax,4c00H
    int 21H
do0end:
    nop

code ends

end start

; 编写、安装中断7ch的中断例程
; 功能：将一个全是字母，以0结尾的字符串，转化为大写
; 参数：ds:si指向字符串的首地址

assume cs:code
data segment
    db 'conversation',0
data ends
code segment
start:
; 安装程序
    mov ax,cs
    mov ds,ax
    mov si,offset capital
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset capitalend - offset capital
    cld
    rep movsb

; 设置中断向量表
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200H
    mov word ptr es:[7ch*4+2],0

; 测试
    jmp test_case

; 子程序：将小写字母转化为大写
; 参数：ds:si指向字符串的首地址
capital:
    push cx
    push si
change:
    mov cl,[si]
    jcxz ok
    and byte ptr [si],11011111b
    inc si
    jmp short change
ok: pop si
    pop cx
    iret
capitalend:
    nop

; 测试用例
test_case:
    mov ax,data
    mov ds,ax
    mov si,0
    int 7cH

    mov ax,4c00H
    int 21H
code ends
end start

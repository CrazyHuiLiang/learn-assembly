; 用7ch中断例程完成jmp near ptr s指令的功能，用bx向中断例程传送转移位移
assume cs:code

data segment
db 'conversation',0
data ends

code segment
; 安装程序
    mov ax,cs
    mov ds,ax
    mov si,offset jpn
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset jpnend - offset jpn
    cld
    rep movsb

; 设置中断向量表
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200H
    mov word ptr es:[7ch*4+2],0

; 运行测试用例
    jmp test_case

; 中断程序
jpn:
    ; int 7cH中断触发后，当前的标志寄存器、CS和IP都要压栈，
    ; 此时压入的CS和IP的内容，分别是调用程序的段地址和int 7cH后一条指令的偏移地址（即标号se的偏移地址）
    ; 我们可以直接从栈中我们将栈中标号se的偏移地址加上bx中的转移位移，则栈中的se的偏移地址就变成了s的偏移地址；
    add [bp+2],bx   ; 下面我们再使用iret指令，用栈中的内容设置CS、IP，从而实现转移标号s处
    iret
jpnend:
    nop

; 在屏幕的第12行，显示data段中以0结尾的字符串
test_case:
    mov ax,data
    mov ds,ax
    mov si,0
    mov ax,0b800H
    mov es,ax
    mov di,12*160

s:  cmp byte ptr [si],0         ; 如果是0，跳出循环
    je ok
    mov al,[si]
    mov es:[di],al
    inc si
    add di,2
    mov bx,offset s-offset ok   ; 设置从标号ok到标号s的转移位置
    int 7ch                     ; 转移到标号s处
ok: mov ax,4c00H
    int 21H
code ends
end start

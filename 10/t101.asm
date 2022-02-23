; 补全程序，实现从内存1000:0000 处开始执行指令

assume cs:code

stack segment
        db 16 dup (0)
stack ends

code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,16
        ; 补全点
        mov ax,1000h ; 将段地址入栈
        push ax
        ; 补全点
        mov ax,0 ; 将偏移地址入栈
        push ax
        retf ; 跳转
code ends

end start




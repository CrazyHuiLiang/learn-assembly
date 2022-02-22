; 写一个通用的子程序来实现显示字符串的功能，提供灵活的调用接口，使调用者可以决定显示的位置（行、列）、内容和颜色

assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:
    ; 在屏幕的8行，3列
    mov dh,8
    mov dl,3
    ; 用绿色显示
    mov cl,2
    ; data段中的字符串
    mov ax,data
    mov ds,ax
    mov si,0
    ; 调用子程序进行显示
    call show_str

    mov ax,4c00h
    int 21h

; 在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数
;   (dh)=行号，取值范围[0,24]
;   (dl)=列号，取值范围[0,79]
;   (cl)=颜色
;   ds:si 指向字符串的首地址
show_str:
    ; 保存程序中要用到的寄存器

    ; 行列位置与显存地址的对应关系
code ends
end start


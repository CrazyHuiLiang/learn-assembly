; 使用int 21H在屏幕的5行12列显示字符串“Welcome to masm!”
; int 21H 是DOS提供的中断例程
assume cs:code

data segment
    db 'Welcome to masm','$' ; $数据的边界，不显示
data ends

code segment
start:
    mov ah,2    ; 置光标
    mov bh,0    ; 第0页
    mov dh,5    ; dh中放行号
    mov dl,12   ; dl中放列号
    int 10H

    mov ax,data
    mov ds,ax
    mov dx,0    ; ds:dx指向字符串的首地址data:0
    mov ah,9
    int 21H
code ends
end start

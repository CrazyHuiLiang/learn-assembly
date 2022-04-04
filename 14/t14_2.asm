; 编程，用加法和移位指令计算 (ax)=(ax)*10
; 提示，(ax)*10 = (ax)*2+(ax)*8

assume cs:code

code segment
start:
    mov ax,1
    mov bx,ax
    shl bx,1    ; ax*2
    shl ax,3    ; ax*8
    add ax,bx   ; ax*2 + ax*8
code ends
end start

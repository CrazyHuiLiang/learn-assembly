; 编程，用加法和移位指令计算 (ax)=(ax)*10
; 提示，(ax)*10 = (ax)*2+(ax)*8

assume cs:code

code segment
start:
    mov ax,1
    mov bx,ax
    shl bx,1    ; ax*2
    mov cl,3    ; 如果移动位数大于1时，需要将位数放在cl中
    shl ax,cl   ; ax*8
    add ax,bx   ; ax*2 + ax*8
code ends
end start

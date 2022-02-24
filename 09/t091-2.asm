; 补全程序，使jmp指令执行后，CS:IP指向程序的第一条指令
assume cs:code


data segment
        dd 12345678H
data ends

code segment
start:  mov ax,data
        mov ds,ax
        mov bx,0
        ; 代码插入点 - 2行
        mov [bx],bx
        mov [bx+2],cs
        jmp dword ptr ds:[0]
code ends

end start


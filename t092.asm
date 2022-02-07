assume cs:code


code segment

start:  mov ax,2000h
        mov ds,ax
s:      mov cl,[bx]
        mov ch,0
        jcxz ok
        inc bx
        jmp short s
ok:     mov dx,bx
        mov ax,4c00h
        int 21h


code ends

end start




; 下面程序执行后，ax中的数值为多少
assume cs:code

code segment
start:  
        mov ax,0        ; (ax)=
        call far ptr s
        inc ax
s:      pop ax          ; (ax)=
        add ax,ax       ; (ax)=
        pop bx
        add ax,bx

        mov ax,4c00h
        int 21h
code ends

end start

assume cs:code

stack segment
        db 16 dup (0)
stack ends


code segment
start:  
        mov ax,1000h
        mov ds,ax
        mov word ptr ds:[0], 0b8h
        mov word ptr ds:[2], 0e800h
        mov word ptr ds:[4], 0001h
        mov word ptr ds:[6], 5840h


        mov ax,stack
        mov ss,ax
        mov sp,16

        ; need use debug redirect
        ; breakpoint: change cs:ip to 1000:0
        mov ax,4c00h
        int 21h
code ends

end start




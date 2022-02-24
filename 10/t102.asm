; 下面程序执行后，ax中的数值为多少
assume cs:code

stack segment
        db 16 dup (0)
stack ends


code segment
start:  
        ; Mock, fill machine code to 1000:0
        mov ax,1000h
        mov ds,ax
        mov word ptr ds:[0], 0b8h
        mov word ptr ds:[2], 0e800h
        mov word ptr ds:[4], 0001h
        mov word ptr ds:[6], 5840h
        mov byte ptr ds:[8], 0b8h
        mov word ptr ds:[9], 4c00h
        mov word ptr ds:[11],21cdh

        ; init stack
        mov ax,stack
        mov ss,ax
        mov sp,16

        ; jmp to 1000:0
        mov ax,1000h
        push ax
        mov ax,0h
        push ax
        mov bp,sp
        jmp dword ptr [bp]
code ends

end start

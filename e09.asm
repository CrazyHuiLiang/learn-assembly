assume cs:code,ds:data


data segment
    db 'welcome to masm!'
data ends


code segment

start:  mov ax,data
        mov ds,ax
        mov bx,0

        mov ax,0b8fch
        mov ss,ax
        mov bp,8

        mov cx,16
s:      mov al,[bx]
        mov ah,2h
        mov [bp],ax
        inc bx
        add bp,2
        loop s

        sub bp,15
        mov al,24h
        mov [bp],al
        add bp,2
        mov [bp],al

        add bp,4
        mov al,91h
        mov cx,5
blue:   mov [bp],al
        add bp,2
        loop blue

        mov ax,4c00h
        int 21h

code ends


end start




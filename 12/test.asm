assume cs:code

code segment
    mov ax,1000H
    mov bl,1
    div bl

    mov ax,4c00H
    int 21H
code ends

end


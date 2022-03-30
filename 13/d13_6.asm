; 在屏幕的第5行12列显示3个红底高亮闪烁绿色的"a"
assume cs:code

; int 10H 是BIOS
code segment
    mov ah,2    ; 放置光标的子程序
    mov bh,0    ; 第0页
    mov dh,5    ; dh中放行号
    mov dl,12   ; dl中放列号
    int 10H

    mov ah,9    ; 在光标位置显示字符的子程序
    mov al,'a'  ; 字符
    mov bl,11001010b ; 颜色属性
    mov bh,0    ; 第0页
    mov cx,3    ; 字符重复个数
    int 10H

    mov ax,4c00H
    int 21H
code ends
end

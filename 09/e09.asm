; 编程：在屏幕的中间分别显示绿色、绿地红色、白底蓝色的字符串'welcome to masm!'
assume cs:code,ds:data

data segment
    db 'welcome to masm!'
data ends

code segment

        ; 设置ds:bx 指向 data
start:  mov ax,data
        mov ds,ax
        mov bx,0

        ; 设置ss:[bp]指向显存
        mov ax,0b882h   ; B800H为显存的开始位置，一行80个字符，占160字节，B882为第13行开始位置
        mov ss,ax
        mov bp,64       ; 一行有80个字符，需要显示的字符有16个，要将此16个字符显示至屏幕中央，需要显示的起始位置为第32个字符后

        ; 循环16次，先将所有的ASCII数据转移至屏幕
        mov cx,16
s:      mov al,[bx]     ; 低自己存储ASCII数据
        mov ah,2h       ; 高字节存储绿色（暂时将所有数据都设置为绿色）
        mov [bp],ax     ; 将数据通过ss:[bp]的方式转移至显存中
        inc bx          ; 指向data中的下一个字符
        add bp,2        ; 指向显存中的下一个字符
        loop s

        sub bp,15       ; 将bp指向显存中 to 首字母的字符属性位置
        mov al,24h      ; 颜色设置为绿底红色
        mov [bp],al     ; t
        add bp,2
        mov [bp],al     ; 0

        add bp,4        ; 将bp指向显存中 masm! 首字母的字符属性位置
        mov al,71h      ; 白底蓝字
        mov cx,5        ; masm! 有5个字符
blue:   mov [bp],al
        add bp,2
        loop blue

        mov ax,4c00h
        int 21h

code ends

end start

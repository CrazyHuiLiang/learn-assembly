; 在屏幕中间显示当前的月份
assume cs:code
code segment
start:
    mov al,8
    out 70H,al  ; 月份的单元地址为 8
    in al,71H   ; 从数据端口71H中获取指定单元中的数据

    mov ah,al   ; al中为从CMOS RAM的8号单元中读出的数据
    mov cl,4
    shr ah,cl   ; ah中为月份的十位数码值
    and al,00001111b    ; al中为月份的各位数码值

    ; 显示(ah)+30H 和 (al)+30H 对应的ASCII码字符
    add ah,30H
    add al,30H

    mov bx,0b800H
    mov es,bx
    mov byte ptr es:[160*12+40*2],ah    ; 显示月份的十位数码
    mov byte ptr es:[160*12+40*2+2],al  ; 显示月份的个位数码

    mov ax,4c00H
    int 21H
code ends
end start

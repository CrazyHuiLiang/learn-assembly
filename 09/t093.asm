; 补全程序，利用loop指令，实现在内存2000H段中查找第一个值为0的字节，找到后，将它的偏移地址存储在dx中
assume cs:code

code segment

start:  mov ax,2000h
        mov ds,ax
s:      mov cl,[bx] ; 拿出一个字节的数据
        mov ch,0
        ; 代码插入点 1行
        inc cx ; 如果值0，需要加一，这样在下面的loop指令时，才能实现等于0，终止循环
        inc bx ; 递增拿下一个字节的数据
        loop s
ok:     dec bx ; 因为之前有一次递增，所以减一才是值为0的位置
        mov dx,bx
        mov ax,4c00h
        int 21h
code ends

end start

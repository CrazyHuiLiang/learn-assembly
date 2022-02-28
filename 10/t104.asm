; 下面程序执行后，ax中的数值为多少
assume cs:code

code segment
; 程序开始执行，SP默认是0000
start:  
        ; b8 06 00
        mov ax,6        ; (ax)=6
        ; ff d0
        call ax         ; 执行此行后，下一行代码转为下两行位置，同时将下一行的位置压栈（前面这两行的代码占据了5个字节，所以下一行代码的偏移地址为0005),偏移地址压栈，这是sp会减去2 = fffe
        ; 40
        inc ax
        mov bp,sp       ; (bp)=fffe
        add ax,[bp]     ; 刚才call指令产生的压栈地址 0005   <-------- 最终答案

        mov ax,4c00h
        int 21h
code ends

end start

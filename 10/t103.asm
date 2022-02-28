; 下面程序执行后，ax中的数值为多少
assume cs:code

code segment
; 程序开始执行，SP默认是0000
start:  
        ; b8 00 00
        mov ax,0        ; (ax)=0
        ; 9a 09 00 00 10
        call far ptr s  ; 执行此行后，下一行代码转为标号s的行，同时将下一行的位置压栈（前面这两行的代码占据了8个字节，所以下一行代码的偏移地址为0008),因为是远转移，所以此行指令执行后，会将段地址（0C5A）和偏移地址压栈，这是sp会减去4 = fffc
        ; 40
        inc ax
        ; 58
s:      pop ax          ; (ax)=0008h
        add ax,ax       ; (ax)=0010h
        pop bx          ; (bx)=0c5ah
        add ax,bx       ; (ax)=0c6ah    <-----------  最终结果

        mov ax,4c00h
        int 21h
code ends

end start

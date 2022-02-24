; 补全程序，利用jcxz指令，实现在内存2000H段中查找第一个值为0的字节，找到后，将它的偏移地址存储在dx中
assume cs:code

code segment

start:  mov ax,2000h
        mov ds,ax
        ; 代码插入点 - 4行
s:      mov cl,[bx] ; 拿出一个字节的数据
        mov ch,0
        jcxz ok ; 判断值是否为0，为0跳转至ok
        inc bx  ; 不为0时，递增索引，检查下一个字节
        jmp short s
ok:     mov dx,bx
        mov ax,4c00h
        int 21h
code ends

end start

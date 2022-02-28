; 下面的程序执行后，ax和bx中的数值为多少？
assume cs:code
data segment
        dw 8 dup (0)
data ends
code segment
start:  mov ax,data
        mov ss,ax
        mov sp,16
        mov word ptr ss:[0],offset s    ; 标号s的地址（偏移地址）
        mov ss:[2],cs                   ; 代码执行的保存段地址
        call dword ptr ss:[0]           ; 转移至s，压栈下一行nop的段地址（0C5aH）ss:[0eH] 和偏移地址(0019H) ss:[0cH]
        nop
s:      mov ax,offset s                 ; 标号s的地址(偏移地址 001aH）
        sub ax,ss:[0cH]                 ; 减去 0019H = 1 <------------------- ax结果
        mov bx,cs                       ; 段地址 0c5aH
        sub bx,ss:[0eH]                 ; 减去 0c5aH = 0 <------------------- bx结果

        mov ax,4c00H
        int 21H
code ends
end start

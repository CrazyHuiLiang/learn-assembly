; 有如下程序段，添加两条指令，使该程序在运行中将s处的一条指令复制到s0处
assume cs:codesg

codesg segment

s:      mov ax,bx
        mov si,offset s         ; si 指向复制源位置
        mov di,offset s0        ; di 指向目标位置
        ; 代码插入点 - 2行
        mov ax,cs:[si]          ; 将复制内容转移至ax
        mov cs:[di],ax          ; 将ax内容转移至目标位置，完成复制
s0:     nop
        nop

codesg ends


end s

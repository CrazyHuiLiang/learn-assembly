; 写一个名称为divdw的子程序，进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
; X: 被除数
    ; H：被除数的高位字节
    ; L：被除数的低位字节
; N：除数
; int(): 描述性运算符，取商
; rem()：描述性运算符，取余
; 算法采用运算公式为（证明过程见《汇编语言》附录5）：
    ; X/N = int(H/N)*FFFFH + [rem(H/N)*FFFFH + L]/N
assume cs:code,ss:stack

stack segment
    dw 8 dup(0)
stack ends


code segment

; 设置栈，用于后续子程序暂存寄存器中的数值使用
mov ax,stack
mov ss,ax
mov sp,10H

; test case: 计算1000000/10的值
mov ax,4240H
mov dx,000FH
mov cx,0AH
call divdw

mov ax,4c00H
int 21h


; 参数：
    ; (ax)=dword型数据的低16位
    ; (dx)=dword型数据的高16位
    ; (cx)=除数
; 返回：
    ; (ax)=结果的低16位
    ; (dx)=结果的高16位
    ; (cx)=余数
divdw:
    ; 暂存寄存器
    push bx
    push si

    ; 计算H/N
    mov bx,ax ; 暂存被除数的低16位至 bx
    mov ax,dx ; 让被除数的高16位，做被除数
    mov dx,0
    div cx      ; 16位除法, 此时 (AX) = int(H/N); (DX) = rem(H/N)

    ; 计算 [rem(H/N)*FFFFH + L]/N ；这部分公式的含义可以解读为做一16位除法，除数仍在cx中， H/N 的余数作为被除数的高16位，divdw传入的被除数的低16位作为这次除法的低16位
    mov si,ax ; 将H/N的商暂存于 si
    mov ax,bx ; divdw传入的被除数的低16位作为这次除法的低16位; (此时 H/N 的余数在dx寄存器中，恰好作为此次除法的被除数的高16位）
    div cx    ; 16位除法，此时 （AX）即使整个式子的商的低16位

    ; X/N = int(H/N)*FFFFH + [rem(H/N)*FFFFH + L]/N
    mov cx,dx ; [rem(H/N)*FFFFH + L]/N 是整个式子最终的余数，根据接口约定，余数存于cx中
    mov dx,si ; H/N的商是整个式子的商的高16位，根据接口约定存于dx中；（整个式子的商的低16位已位于ax中，无需变动）

    ; 还原之前寄存器中的值
    pop si
    pop bx
    ret

code ends

end














code segment

    start:
        ; 设置被除数
        mov dx, 1234H
        mov ax, 5679H
        ; 设置除数
        mov bx, 0004H
        ; 调用函数
        call divdw
        ; 程序返回
        jmp finish

    ; 功能 : 不会产生溢出的 divdw 函数
    ; 参数 : 
    ;       被除数 : dx 高 16 位 , ax 低 16 位
    ;       除数 : bx
    ; 返回 : 
    ;       商 : dx 高 16 位 , ax 低 16 位
    ;       余数 : cx
    ; 公式 : 
    ;       X / n -> 商 S(32bit) 余 Y(16bit)
    ;       X = H * 65536 + L
    ;       S_H = H / n
    ;       S_L = (rem(H / n) * 65536 + L) / n
    ;       上一行公式的商为最终结果的低 16 位 , 余数即为最终的余数
    divdw:
        ; 首先计算商的高 16 位
        ; 注意这里我们的除数是 16 位的
        ; 如果进行 div 运算的时候默认会将被除数当成 32 位
        ; 其中高 16 位在 dx 中 , 低 16 位在 ax 中
        ; 因此首先要将 ax 的值保存起来 , 然后将 dx 的值移动到 ax 中
        ; 然后将 dx 清零 , 计算完成后还要恢复 ax
        push ax
        mov ax, dx
        xor dx, dx
        div bx ; 进行除法运算 , ( ax 保存商 , dx 保存余数 )
        ; 我们接下来要使用上一个除法运算得到的余数
        ; 除法运算需要使用 ax , 但是现在 ax 保存着商
        ; 因此我们需要将 ax 再进行保存
        ; 这里先使用一个暂时不用的寄存器进行保存 , (si)
        mov si, ax ; 将商保存
        ; 现在 dx 中存放的是被除数高 8 位除以除数得到的余数
        ; 根据公式 , 下一次的除法运算
        ; 要将第一次的除法运算的商左移 16 位在加上被除数的低 16 位作为新的被除数
        ; 但是我们知道 , 在 div 指令中 , 32 位的除法
        ; 刚好是 dx 中存放高 16 位 , ax 中存放低 16 位 , 因此直接进行除法运算即可
        pop ax ; 设置新的被除数的低 16 位 , 也就是旧的被除数的低 16 位数
        div bx ; 进行除法运算
        ; 商保存在 ax 中 , 余数保存在 dx 中
        ; 这个时候得到的余数就是真正的余数
        ; 商 就是真正的商的低 16 位 , 而真正的商的高 16 位被我们临时保存在了 si 中
        ; 现在我们需要将余数存在 cx 中 , 商的高 16 位存在 dx 中 , 然后就可以返回了
        mov cx, dx
        mov dx, si
        ret 

    finish:
        mov ax,4cH
        int 21H

code ends

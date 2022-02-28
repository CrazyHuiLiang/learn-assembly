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
start:
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

end start

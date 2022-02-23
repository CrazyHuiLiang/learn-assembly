; 写一个名称为divdw的子程序，进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
; X: 被除数
    ; H：被除数的高位字节
    ; L：被除数的低位字节
; N：除数
; int(): 描述性运算符，取商
; rem()：描述性运算符，取余
; 算法采用运算公式为（证明过程见《汇编语言》附录5）：
    ; X/N = int(H/N)*FFFFH + [rem(H/N)*FFFFH + L]/N


assume cs:code

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

    ; 计算H/N
    mov bx,ax
    mov ax,dx
    mov dx,0
    div cx      ; 16位除法, (AX) = int(H/N); (DX) = rem(H/N)

    ; 计算 left = int(H/N)*FFFFH => (AX)*FFFFH
    ; 计算 right1 = rem(H/N)*FFFFH => (DX)*FFFFH
    ; 计算 right2 = right1+L
    ; 计算 right = right2/N

    ; 计算 result = left + right


ok: ret

code ends

end
; 将data段中的数据以十进制的形式显示出来
assume cs:code
data segment
    db 10 dup (0)
data ends
; 内存中都是二进制信息，需要进行信息的转化（数值 转为 显卡使用的ASCII码）
code segment
; test case: 将12666以十进制形式在屏幕的8行3列，用绿色显示出来
start:  
    mov ax,12666
    mov bx,data
    mov ds,bx
    mov si,0
    call dtoc

    ; 显示
    mov dh,8
    mov dl,3
    mov cl,2
    call show

; 将word型数据转变为表示十进制数的字符串，字符串以0为结尾符。
; 参数
;   (ax)=word型数据
;   ds:si指向字符串的首地址
dtoc:
    ; cache register
    push ax
    push dx
    push cx
    push si

    ; convert num to ascii
toc:
    mov cx,10           ; 存放进制（10) 作为被除数
    call divdw          ; 辗转相除
    add cl,30H          ; 取余，转化为ascii（因为除数为10，所以余数只占一个字节的cl，ch为0)
    mov [si],cl
    inc si              ; 字符串指向下一个字符位置
    mov cx,ax
    jcxz return_dtoc    ; (cx)=0时，返回
    jmp toc

return_dtoc:
    mov byte ptr [si],0          ; 字符串以0结尾
    pop si
    pop cx
    pop dx
    pop ax
    ret

; 不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
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

; 在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数
;   (dh)=行号，取值范围[0,24]
;   (dl)=列号，取值范围[0,79]
;   (cl)=颜色
;   ds:si 指向字符串的首地址
show:
    mov cx,[si]
    inc si
    jcxz return_show ; 内容为0时return
    mov es:[di],cx ; 低位字节存储ASCII码
    inc di
    mov es:[di],bx ; 高位字节存储字符属性
    inc di
    jmp show
return_show:
    mov cl,bl ; 还原cl寄存器
    ret
code ends
end start

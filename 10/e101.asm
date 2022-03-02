; 写一个通用的子程序来实现显示字符串的功能，提供灵活的调用接口，使调用者可以决定显示的位置（行、列）、内容和颜色

assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:
    ; 在屏幕的8行，3列
    mov dh,8
    mov dl,3
    ; 用绿色显示(8位分别代表 闪烁，背景R，背景G，背景B，高亮，前景R，前景G，前景B）
    mov cl,10B
    ; data段中的字符串
    mov ax,data
    mov ds,ax
    mov si,0
    ; 调用子程序进行显示
    call show_str

    mov ax,4c00h
    int 21h

; 在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数
;   (dh)=行号，取值范围[0,24]
;   (dl)=列号，取值范围[0,79]
;   (cl)=颜色
;   ds:si 指向字符串的首地址
show_str:
    ; 保存程序中要用到的寄存器
    mov bl,cl ; 将颜色信息暂存至bl中（因为后续jcxz需要用到cx）
    mov bh,0

    ; 行列位置与显存地址的对应关系
        ; B8000H~B8F9FH中的内容将出现在显示器上
        ; 显示器可以显示25行，每行80个字符
        ; 每个字符占两个字节的存储空间，低位字节存储字符的ASCII码，高位字节存储字符的属性
    ; es:di 指向输出位置
    mov ax,0B800H
    mov es,ax
    mov al,160 ; 一行80个字符，占160
    mul dh
    mov di,ax
    mov al,2 ; 一个输出字符占两个字节
    mul dl
    add di,ax

    ; 将字符转移至屏幕输出
show:
    mov ch,0
    mov cl,[si]
    inc si
    jcxz return ; 内容为0时return
    mov es:[di],cl ; 低位字节存储ASCII码
    inc di
    mov es:[di],bl ; 高位字节存储字符属性
    inc di
    jmp show
return:
    mov cl,bl ; 还原cl寄存器
    ret

code ends
end start


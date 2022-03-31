; 编写并安装int 7ch中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处
; 参数:
;   (dh)=行号
;   (dl)=列号
;   (cl)=颜色
;   ds:si指向字符串首地址

assume cs:code

data segment
    db 'welcome to masm!',0
data ends

code segment

start:
; 安装程序
    mov ax,cs
    mov ds,ax
    mov si,offset print
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset printend - offset print
    cld
    rep movsb

; 设置中断向量表
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200H
    mov word ptr es:[7ch*4+2],0

; 运行测试用例
    jmp test_case

; 中断程序
print: 
    push ax
    push bx
    push cx
    push dx

    mov dx,si   ; ds:dx指向字符串首地址，用于 call_print_int 标号

    ; 将0结尾改为$结尾
check0:
    mov byte ptr cx,[si]
    jcxz replace0       ; 如果当前字符是0，将其转换为$
    inc si
    jump check0
replace0:
    mov byte ptr [si],'$'

    mov ah,2    ; 置光标
    mov bh,0    ; 第0页
    int 10H

call_print_int:
    mov ah,9
    int 21H

    pop dx
    pop cx
    pop bx
    pop ax
    iret
printend:
    nop


test_case:
    mov dh,10   ; 行号
    mov dl,10   ; 列号
    mov cl,2    ; 颜色
    mov ax,data
    mov ds,ax
    mov si,0    ; ds:si 字符串首地址
    int 7cH
    mov ax,4c00H
    int 21H
code ends
end start

; 程序设计题：将e07实验中的Power idea公司的数据在屏幕中显示出来

; e07
; Power idea公司从1975年成立一直到1995年的基本情况data段所定义
; 将data段中的数据按： 行表示年份，列表示一个具体字段（如table段示意）保存在table段中
assume cs:code,ds:data,ss:stack
data segment
    ; 表示21年的21个年份（字符串）
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ; 表示21年公司总收入的21个dword型数据
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ; 表示21年公司雇员人数的21个word型数据
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends
table segment
    ;           年份  收入 雇员 人均收入
    db 21 dup ('year summ ne ?? ')
table ends
printBuffer segment ; 用于向屏幕输出的字符串的缓存
    db 16 dup (0)
printBuffer ends
stack segment
    db 16 dup (0)
stack ends
code segment
; -----------------将data段内容复制至table段-----------------
; (es:bp)   指向 data 的数据列
; (si)      标识 data 当前读到第几个数据
; (ds:bx)   指向 table 的行
; (di)      标识 table 数据列的起点位置

; cx 用于循环
; ax 用于临时计算
start:
    ; 将data段中年份复制至table年份列
    mov ax,data
    mov es,ax       ; es指向data段
    mov bp,0        ; bp指向年份的起始位置
    mov si,0        ; si指向每个年份的起始位置
    mov ax,table
    mov ds,ax       ; ds指向table段
    mov bx,0        ; bx指向table的行
    mov di,0        ; di指向table的每个字段的起始位置
    mov cx,21       ; 共有21个数据
copy_year:
    mov ax,es:[bp+si+0] ; 复制前2个字节
    mov ds:[bx+di+0],ax
    mov ax,es:[bp+si+2] ; 复制后2个字节
    mov ds:[bx+di+2],ax
    add si,4            ; si指向下一个数据
    add bx,16           ; bp指向table的下一行
    loop copy_year

    ; 将data段中收入复制到table收入列
    mov bp,84       ; bp指向收入的起始位置
    mov si,0        ; si指向每个年份收入的起始位置
    mov bx,0        ; bx指向table的行
    mov di,5        ; di指向table的每个字段的起始位置
    mov cx,21       ; 共有21个数据
copy_income:
    mov ax,es:[bp+si+0] ; 复制前2个字节
    mov ds:[bx+di+0],ax
    mov ax,es:[bp+si+2] ; 复制后2个字节
    mov ds:[bx+di+2],ax
    add si,4            ; si指向下一个数据
    add bx,16           ; bp指向table的下一行
    loop copy_income

    ; 将data段中雇员复制到table雇员列
    mov bp,168      ; bp指向雇员的起始位置
    mov si,0        ; si指向每个年份收入的起始位置
    mov bx,0        ; bx指向table的行
    mov di,10       ; di指向table的每个字段的起始位置
    mov cx,21       ; 共有21个数据
copy_employee:
    mov ax,es:[bp+si+0] ; 复制2个字节
    mov ds:[bx+di+0],ax
    add si,2            ; si指向下一个数据
    add bx,16           ; bp指向table的下一行
    loop copy_employee

; -----------------计算出人均收入，写入table人均收入列-----------------
    mov bx,0        ; bx指向table的行
    mov cx,21       ; 共有21个数据
per_employee_income:
    mov ax,ds:[bx+5]; 被除数低16位
    mov dx,ds:[bx+7]; 被除数高16位
    mov si,ds:[bx+10]; 除数
    div si           ; 除法
    mov ds:[bx+13],ax; 商存入table
    add bx,16        ; bp指向table的下一行
    loop per_employee_income


; -----------------将table内数据显示出来-----------------
    ; init stack
    mov ax,stack
    mov ss,ax
    mov sp,16

    ; data段中的字符串
    mov ax,printBuffer
    mov ds,ax

    mov ax,table ; 因为需要使用ds指向用于显示的缓存位置，故换用es指向table
    mov es,ax

    mov bx,0        ; bx指向table的行
    mov cx,21       ; 共有21个数据
    mov dh,4        ; 从屏幕第4行开始显示
call_show_str:
    push cx         ; 因为下方调用需要用到cl，故暂存cx
    mov cl,10B      ; 用绿色显示(8位分别代表 闪烁，背景R，背景G，背景B，高亮，前景R，前景G，前景B）

    ; 显示年份
    mov si,0
    mov dl,0        ; 从屏幕左边起始位置开始显示
    mov ax,es:[bx+0]
    mov ds:[si+0],ax
    mov ax,es:[bx+2]
    mov ds:[si+2],ax
    mov byte ptr ds:[si+3],0
    call show_str   ; 调用子程序进行显示

    inc dh
    add bx,16
    pop cx
    loop call_show_str


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
    push ax
    push bx
    push es
    push si
    push di

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
    mov cx,[si]
    inc si
    jcxz return ; 内容为0时return
    mov es:[di],cx ; 低位字节存储ASCII码
    inc di
    mov es:[di],bx ; 高位字节存储字符属性
    inc di
    jmp show
return:
    mov cl,bl ; 还原cl寄存器
    pop di
    pop si
    pop ax
    mov es,ax
    pop bx
    pop ax
    ret

code ends
end start
; 2d
; 076c
; 077a
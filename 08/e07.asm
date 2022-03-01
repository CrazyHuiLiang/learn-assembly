; Power idea公司从1975年成立一直到1995年的基本情况data段所定义
; 将data段中的数据按： 行表示年份，列表示一个具体字段（如table段示意）保存在table段中
assume cs:code,ds:data
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

    mov ax,4c00H
    int 21H
code ends
end start

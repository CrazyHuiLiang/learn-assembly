; 编写、安装中断7ch的中断例程
; 功能： 求一word型数据的平方
; 参数：(ax)=要计算的数据
; 返回值：dx、ax中存放结果的高16位和低16位
assume cs:code
code segment

start:
    ; 安装中断例程
    mov ax,cs
    mov ds,ax
    mov si,offset sqr               ; 设置ds:si指向源地址
    mov ax,0
    mov es,ax
    mov di,200H                     ; 设置es:di指向目标地址
    mov cx,offset sqrend-offset sqr ; 设置cx为传输长度
    cld                             ; 设置传输方向为正
    rep movsb

    ; 设置中断向量表
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200H
    mov word ptr es:[7ch*4+2],0

    ; 跳转至测试代码
    jmp test_case

    ; 计算平方的例程
sqr:
    mul ax  ;计算平方
    iret    ; int指令和iret指令的配合使用  与call和ret的配合 具有相似的思路
sqrend:
    nop


test_case:
    ; test case: 求 2 * 3456^2
    mov ax,3456
    int 7cH         ; 调用中断7ch的中断例程，计算ax中的数据的平方
    add ax,ax       ; 低位*2
    adc dx,dx       ; 高位*2(使用adc不用add是因为上一步有可能有进位)
    
    mov ax,4c00H
    int 21H


code ends

end start


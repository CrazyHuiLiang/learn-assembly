assume cs:code

code segment
start:
    ; 编程，读取CMOS RAM的2号单元的内容
    mov al,2
    out 70H,al  ; 将2送入端口70H
    in al,71H   ; 从端口71H读出2号单元的内容

    ; 编程，想CMOS RAM的2号单元写入0
    mov al,2
    out 70H,al  ; 将2送入端口70H
    mov al,0
    out 71H,al  ; 向端口71H写入0

code ends

end start

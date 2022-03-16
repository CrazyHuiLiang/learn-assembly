; 编写一个子程序，将包含任意字符，已0结尾的字符串中的小写字母转变成为大写字母

assume cs:code,ss:stack
datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

stack segment
    db 32 dup (0)
stack ends

code segment

begin:
    mov ax,datasg
    mov ds,ax
    mov si,0
    call letterc

mov ax,4c00H
int 21H

; 功能：将已0结尾的字符串中的小写字母[97,122] 转变成大写字母[65,90]
; 参数：ds:si指向字符串首地址
letterc:

push si
push ax

letterc_loop:
; 取出字母
mov al,[si]

; 判断是不是0，如果是0，结束后续处理
cmp al,0
je returnLetterc

; 判断ascii是不是小于97，是的话直接continue
cmp al,97
jb continue_letterc

; 判断ascii是不是小于大于122，是的话直接continue
cmp al,122
ja continue_letterc

; 将此字节值减去32，转化为大写字母
sub al,32

; 将大写字母写入内存区域
mov [si],al

; 进行下一字节的读取
continue_letterc:
inc si
jmp letterc_loop

returnLetterc:
pop ax
pop si
ret

code ends
end

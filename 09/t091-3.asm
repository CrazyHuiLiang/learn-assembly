; 使用debug查看内存，程序执行后CS:IP的值是?
assume cs:code

code segment

; Mock data
mov ax,2000h
mov ds,ax
mov bx,1000h
mov word ptr [bx],0beh
add bx,2
mov word ptr [bx],6h

mov es,ax
jmp dword ptr es:[1000h]

code ends

end


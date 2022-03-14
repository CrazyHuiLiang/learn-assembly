assume cs:code

code segment

sub al,al
mov al,10H
add al,90H
mov al,80H
add al,80H
mov al,0fcH
add al,05H
mov al,7dH
add al,0bH

mov ax,4c00H
int 21H

code ends
end

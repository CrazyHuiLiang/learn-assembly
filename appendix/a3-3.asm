assume cs:code

code segment
begin:	jmp s		; same as "jmp near" + NOP
	jmp short s 
	jmp near ptr s	; use "jmp short" + NOP
	jmp far ptr s	; use "jmp short" + NOP NOP NOP
s:	mov ax,0
code ends
end begin

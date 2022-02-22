assume cs:code

code segment
begin:	jmp s		; same as "jmp near"
	;jmp short s	; throw error
	jmp near ptr s	; E9xx
	jmp far ptr s	; EAxxxx
	db 100 dup (0b8h,0,0)
s:	mov ax,0
code ends
end begin

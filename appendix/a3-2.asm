assume cs:code
; ƫ����λ��[-32768��32767]֮�䣬����������ʹ�ö�ת�ƣ�EBƫ����
code segment
s:	db 100 dup (0b8h,0,0)
	jmp s		;��ʹ��jmp near; E9 xx
	;jmp short s	;�ᱨ��
	jmp near ptr s	;��ʹ��jmp near; E9 xx
	jmp far ptr s	;��ʹ��jmp far; EA xxxx
code ends
end s

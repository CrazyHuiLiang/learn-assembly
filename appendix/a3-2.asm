assume cs:code
; 偏移量位于[-32768，32767]之间，编译器都将使用短转移；EB偏移量
code segment
s:	db 100 dup (0b8h,0,0)
	jmp s		;会使用jmp near; E9 xx
	;jmp short s	;会报错
	jmp near ptr s	;会使用jmp near; E9 xx
	jmp far ptr s	;会使用jmp far; EA xxxx
code ends
end s

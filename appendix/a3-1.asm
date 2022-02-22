assume cs:code
; 偏移量位于[-128，127]之间，编译器都将使用短转移；EB偏移量
code segment
s:	jmp s
	jmp short s
	jmp near ptr s
	jmp far ptr s
code ends
end s

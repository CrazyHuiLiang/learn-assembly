assume cs:code
; ƫ����λ��[-128��127]֮�䣬����������ʹ�ö�ת�ƣ�EBƫ����
code segment
s:	jmp s
	jmp short s
	jmp near ptr s
	jmp far ptr s
code ends
end s

include irvine32.inc

.data
A BYTE 1010101b
B BYTE 1111111b
Cval byte 0000000b
msg1 BYTE "Bit 0 is ON", 0
msg2 BYTE "Bit 0 is OFF", 0
msgAnd BYTE "After AND: ",0
msgOR BYTE "After OR: ",0
msgXOR BYTE "After XOR: ",0

.code
main proc
mov al, A
mov bl, B
mov cl, Cval

and al, 55h
mov A, al
mov edx, offset msgAND
call writestring
movzx eax, al
call writebin
call crlf

or bl, 55h
mov b, bl
mov edx, offset msgOR
call writestring
movzx eax, bl
call writebin
call crlf

xor cl, 0FFh
mov cval, cl
mov edx, offset msgxor
call writestring
movzx eax, cl
call writebin
call crlf

test al,1
jnz biton
jmp bitoff

biton:
	mov edx, offset msg1
	call writestring
	jmp exitt

bitoff: 
	mov edx, offset msg2
	call writestring

exitt:
	call crlf

exit
main endp
end main

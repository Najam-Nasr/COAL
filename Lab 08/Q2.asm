include irvine32.inc

.data

inputmsg BYTE "Enter 5 numbers: ",0
outputmsg BYTE "Numbers in reverse order: ",0
space BYTE " ",0

.code
main proc

mov ecx, 5
mov edx, offset inputmsg
call writestring
call crlf

inputloop:
	call readdec
	push eax
	loop inputloop


call crlf
mov edx, offset outputmsg
call writestring
call crlf

mov ecx, 5

outputloop:
	pop eax
	call writedec
	mov edx, offset space
	call writestring
	loop outputloop
	call crlf

exit
main endp
end main

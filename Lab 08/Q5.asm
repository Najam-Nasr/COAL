include irvine32.inc

.data
msg1 byte "Enter a number: ",0
msg2 byte "Factorial: ",0
var1 dword ?

.code
main proc

mov edx, offset msg1
call writestring


call readdec
mov var1, eax
call crlf


mov ecx, var1
mov eax, 1

fact:
	imul eax, ecx
	loop fact


mov edx, offset msg2
call writestring
call writedec
exit 
main endp
end main

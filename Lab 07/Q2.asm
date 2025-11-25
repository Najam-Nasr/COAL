include irvine32.inc

.data
A DWORD ?
B DWORD ?
Cval DWORD ?

msg BYTE "Enter three numbers: ",0
msg1 BYTE "Largest (Unsigned): ",0
msg2 BYTE "Largest (Signed): ",0

.code
main proc

mov edx, offset msg
call writestring
call crlf
call readint
mov A, eax
call crlf
call readint
mov B, eax
call crlf
call readint 
mov Cval, eax
call crlf

mov eax, A
cmp eax, B
ja check2nd
mov eax, B
jmp check2nd

check2nd:
cmp eax, Cval
jae print
mov eax, Cval

print:
	mov edx, offset msg1
	call writestring
	call writedec
	call crlf

mov eax, A
cmp eax, B
jge check2
mov eax, B
jmp check2

check2:
	cmp eax, Cval
	jge printt
	mov eax, Cval

printt:
	mov edx, offset msg2
	call writestring
	call writeint
	call crlf

exit
main endp
end main

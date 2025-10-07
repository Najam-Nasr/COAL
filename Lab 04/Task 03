include irvine32.inc

.data
num1 dword 1234h
num2 dword 5678h

.code
main proc

mov eax, num1
mov ebx, num2
xchg eax, ebx

call dumpregs
call crlf

exit
main endp
end main

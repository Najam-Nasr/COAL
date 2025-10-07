INCLUDE irvine32.inc

.data
num DWORD 15000h

.code
main proc

mov eax, num
add eax, 1

call dumpregs
call crlf

exit
main endp
end main

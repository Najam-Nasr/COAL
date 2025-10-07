INCLUDE irvine32.inc

.data

count DWORD 11
.code
main proc

mov eax, 5
mov ecx, count
mov ebx, 1

l1:
call writedec
call crlf
inc eax
loop l1

exit
main endp
end main

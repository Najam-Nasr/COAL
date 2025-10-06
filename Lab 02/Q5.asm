include irvine32.inc

.data

result dword ?

.code
main proc

mov ebx, 111b
sub ebx, 12
add ebx, 1F3h
sub ebx, 745O
mov result, ebx
mov eax, result

call writeint
call crlf

exit
main endp
end main

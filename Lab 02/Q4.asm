include irvine32.inc

.data

result dword ?

.code
main proc

mov ebx, 11010110b
sub ebx, 9C4h
add ebx, 220
add ebx, 18
add ebx, 1011110b
sub ebx, 13
add ebx, 12
mov result, ebx
mov eax, result

call writeint
call crlf

exit
main endp
end main

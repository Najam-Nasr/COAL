;NAJAM NASR 24k-0754

include irvine32.inc

.data
total DWORD ?

.code
main proc

mov ebx, 101110b
add ebx, 50Ah
add ebx, 67d
add ebx, 1010001b
add ebx, 6Ch
mov total, ebx
mov eax, total

call writeint
call crlf
exit

main endp
end main

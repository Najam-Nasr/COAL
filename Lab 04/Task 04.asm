include irvine32.inc

.data
Xval DWORD 25
yval dword 15
zval dword 40
rval dword ?

.code
main proc
mov eax, xval
mov ebx, yval
mov ecx, zval
add eax, ebx
sub eax, ecx
neg eax
mov rval, eax

call writeint
call crlf

exit
main endp
end main

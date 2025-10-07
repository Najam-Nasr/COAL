INCLUDE irvine32.inc

.data
arrayb BYTE 25, 45, 65
arrayW WORD 155, 185, 225
arrayD DWORD 645, 690, 735
sum1 DWORD ?
sum2 DWORD ?
sum3 DWORD ?

.code
main proc

movzx eax, [arrayB + 0]
movzx ebx, [arrayW + 0]
mov ecx, [arrayD + 0]

mov sum1, eax
add sum1, ebx
add sum1, ecx
mov eax, sum1

call writedec
call crlf

movzx eax, [arrayB + 1]
movzx ebx, [arrayW + 2]
mov ecx, [arrayD + 4]

mov sum2, eax
add sum2, ebx
add sum2, ecx
mov eax, sum2

call writedec
call crlf


movzx eax, [arrayB + 2]
movzx ebx, [arrayW + 4]
mov ecx, [arrayD + 8]

mov sum3, eax
add sum3, ebx
add sum3, ecx
mov eax, sum3

call writedec
call crlf

exit
main endp
end main

INCLUDE irvine32.inc


max equ 100
min equ 10

.data

.code
main proc

mov eax, max
add eax, min


call writeint
call crlf

exit
main endp
end main

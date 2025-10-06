include irvine32.inc

.data
num1 BYte -50
num2 byte 200

.code
main proc

movzx eax, num1
movsx ebx, num2

call dumpregs
call crlf

exit
main endp
end main

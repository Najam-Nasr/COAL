include irvine32.inc

.data
num1 BYte 25
num2 word 1200h
num3 dword ?

.code
main proc
mov al, num1
mov ax, num2
movzx eax, ax
mov num3, eax

call writeint 
call crlf

exit
main endp
end main

INCLUDE irvine32.inc

.data

msg1 BYTE "Welcome",0
msg2 BYTE "You should not see this line",0
msg3 BYTE "Goodbye",0

.code
main proc

mov edx, offset msg1
call writestring
call crlf

mov edx, offset msg2
jmp skip
call writestring
call crlf
skip:

mov edx, offset msg3
call writestring 
call crlf


exit
main endp
end main

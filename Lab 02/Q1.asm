include irvine32.inc

.data
msg BYTE "Najam Nasr", 0

.code
main proc
mov eax, 25
add eax, 47
add eax, 88
add eax, 64
add eax, 120h
add eax, 27q
sub eax, 0Ah
call writeint 
call crlf
exit
main ENDP
end main

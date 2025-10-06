include irvine32.inc

.data
msg BYTE "Najam Nasr", 0

.code
main PROC
mov edx, OFFSET msg
call WriteString
call crlf
exit

main ENDP
END main

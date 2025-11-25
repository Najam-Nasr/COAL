include irvine32.inc

.data

var1 DWORD ?
var2 DWORD ?
var3 DWORD ?
var4 DWORD ?
var5 DWORD ?

countPos DWORD ?
countNeg DWORD ?
countZero DWORD ?

msg BYTE "Enter 5 numbers: ",0
msgPosCount  BYTE "Positive numbers: ",0
msgNegCount  BYTE "Negative numbers: ",0
msgZeroCount BYTE "Zeroes: ",0

.code
main proc

mov countPos, 0
mov countNeg, 0
mov countZero, 0

mov edx, offset msg
call writestring
call crlf

call readint
mov var1, eax
cmp eax, 0
jg L1_Pos
jl L1_Neg
inc countZero
jmp L1_End
L1_Pos:
inc countPos
jmp L1_End
L1_Neg:
inc countNeg
L1_End:

call readint
mov var2, eax
cmp eax, 0
jg L2_Pos
jl L2_Neg
inc countZero
jmp L2_End
L2_Pos:
inc countPos
jmp L2_End
L2_Neg:
inc countNeg
L2_End:

call readint
mov var3, eax
cmp eax, 0
jg L3_Pos
jl L3_Neg
inc countZero
jmp L3_End
L3_Pos:
inc countPos
jmp L3_End
L3_Neg:
inc countNeg
L3_End:

call readint
mov var4, eax
cmp eax, 0
jg L4_Pos
jl L4_Neg
inc countZero
jmp L4_End
L4_Pos:
inc countPos
jmp L4_End
L4_Neg:
inc countNeg
L4_End:

call readint
mov var5, eax
cmp eax, 0
jg L5_Pos
jl L5_Neg
inc countZero
jmp L5_End
L5_Pos:
inc countPos
jmp L5_End
L5_Neg:
inc countNeg
L5_End:

call crlf

mov edx, OFFSET msgPosCount
call WriteString
mov eax, countPos
call WriteInt
call crlf

mov edx, OFFSET msgNegCount
call WriteString
mov eax, countNeg
call WriteInt
call crlf


mov edx, OFFSET msgZeroCount
call WriteString
mov eax, countZero
call WriteInt
call crlf

exit
main endp
end main

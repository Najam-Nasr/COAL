; WordleTwoPlayers.asm
; 2-Player Wordle with strict 5-letter input validation (no leftover chars)
; Case-insensitive: accepts upper or lower case (normalizes to UPPER)
; Includes Stack Frames, INVOKE, PROTO, PROC, Arrays, Loops, Colored Output

include Irvine32.inc

; ===============================================
; 1. PROTO DIRECTIVES
; ===============================================
ShowIntro PROTO
PlayRound PROTO,
    setterNum:DWORD,
    guesserNum:DWORD,
    roundIndex:DWORD

.data
; ===============================================
; 2. DATA DEFINITION
; ===============================================

; --- Intro & Rules ---
introTitle        BYTE "==========================================",13,10
                  BYTE "      WORDLE: 2-PLAYER CHALLENGE          ",13,10
                  BYTE "==========================================",13,10,0

introRule1        BYTE "1. Player 1 enters a secret 5-letter word (hidden).",13,10,0
introRule2        BYTE "2. Player 2 has 5 attempts to guess the word.",13,10,0
introRule3        BYTE "3. Roles switch every round.",13,10,13,10,0

msgTotalRounds    BYTE "Total Rounds to Play: ",0

colorHeader       BYTE "--- COLOR GUIDE ---",13,10,0
txtGreen          BYTE " [GREEN]  ",0
msgGreen          BYTE " : Letter is in the Correct Place",13,10,0
txtYellow         BYTE " [YELLOW] ",0
msgYellow         BYTE " : Letter is correct but in the Wrong Place",13,10,0
txtRed            BYTE " [RED]    ",0
msgRed            BYTE " : Letter is not in the word",13,10,13,10,0
introStart        BYTE "Press any key to START THE GAME...",0

; --- Round Header Strings ---
msgRoundHeader    BYTE "---------------- ROUND ",0
msgRoundOf        BYTE " OF ",0
msgRoundEnd       BYTE " ----------------",13,10,0

; --- Game Prompts ---
promptSecret      BYTE "Player ",0
promptSet         BYTE ": enter SECRET (5 letters): ",0
promptGuess       BYTE ": guess #",0
promptRest        BYTE " (5 letters): ",0
invalidLengthMsg  BYTE "Invalid input! Please enter exactly 5 letters.",13,10,0

; --- Round/Game Messages ---
roundWinMsg       BYTE " *** ROUND WINNER: Player ",0
roundWinSuffix    BYTE " wins this round! ***",13,10,0
roundLostMsg      BYTE " *** ROUND OVER! Secret was: ",0

; --- Scorecard Strings ---
scorecardHeader   BYTE 13,10,"--- CURRENT SCORECARD ---",13,10,0
scoreStatusMsg    BYTE "Status: Completed Round ",0
scoreOfMsg        BYTE " of ",0

nextRoundMsg      BYTE 13,10,"Press any key for NEXT ROUND...",0

finalMsg          BYTE "--- FINAL MATCH RESULTS ---",13,10,0
p1ScoreMsg        BYTE "Player 1 Total Points: ",0
p2ScoreMsg        BYTE "Player 2 Total Points: ",0
p1WinMsg          BYTE "PLAYER 1 WINS THE MATCH!",0
p2WinMsg          BYTE "PLAYER 2 WINS THE MATCH!",0
tieMsg            BYTE "IT'S A TIE!",0

; ===============================================
; 3. ARRAYS (1D and 2D)
; ===============================================
bufSecret         BYTE 6 DUP(0)      ; will hold exactly 5 chars + null
bufGuess          BYTE 6 DUP(0)      
tempSecret        BYTE 6 DUP(0)      
statusBuf         BYTE 6 DUP(0)      

; line buffer to capture entire input line (prevents leftover chars)
lineBuf           BYTE 260 DUP(0)    

; 2D Array: ScoreHistory [2 Players][3 Rounds]
ScoreHistory      BYTE 6 DUP(0)      
ROW_SIZE = 3                        

; Variables
roundsLimit       DWORD 3
guessesAllowed    DWORD 5
attemptCounter    DWORD 0
currentRound      DWORD 0            
FinalScore1       DWORD 0
FinalScore2       DWORD 0

.code

; ===============================================
; main PROC
; ===============================================
main PROC
    call ShowIntro
   
    mov currentRound, 0
    mov ecx, roundsLimit       ; Loop roundsLimit times

GameLoop:
    push ecx

    ; Round A: Player 1 Sets, Player 2 Guesses
    INVOKE PlayRound, 1, 2, currentRound

    ; Round B: Player 2 Sets, Player 1 Guesses
    INVOKE PlayRound, 2, 1, currentRound

    inc currentRound
    pop ecx
    loop GameLoop

    ; --- Final Results Screen ---
    call Clrscr
    mov edx, OFFSET finalMsg
    call WriteString

    ; Calculate Final Scores
    ; P1
    mov esi, OFFSET ScoreHistory    
    mov ecx, ROW_SIZE                      
    mov ebx, 0                        
CalcP1_Final:
    mov al, [esi]                    
    movzx eax, al
    add ebx, eax
    inc esi
    loop CalcP1_Final
    mov FinalScore1, ebx

    ; P2
    mov esi, OFFSET ScoreHistory
    add esi, ROW_SIZE                
    mov ecx, ROW_SIZE
    mov ebx, 0
CalcP2_Final:
    mov al, [esi]
    movzx eax, al
    add ebx, eax
    inc esi
    loop CalcP2_Final
    mov FinalScore2, ebx

    ; Display
    mov edx, OFFSET p1ScoreMsg
    call WriteString
    mov eax, FinalScore1
    call WriteDec
    call CrLf
   
    mov edx, OFFSET p2ScoreMsg
    call WriteString
    mov eax, FinalScore2
    call WriteDec
    call CrLf

    ; Determine Winner
    mov eax, FinalScore1
    cmp eax, FinalScore2
    ja  P1_Wins
    jb  P2_Wins
   
    mov edx, OFFSET tieMsg
    call WriteString
    jmp QuitGame

P1_Wins:
    mov edx, OFFSET p1WinMsg
    call WriteString
    jmp QuitGame

P2_Wins:
    mov edx, OFFSET p2WinMsg
    call WriteString

QuitGame:
    call CrLf
    exit
main ENDP

; ===============================================
; ShowIntro PROC
; ===============================================
ShowIntro PROC
    call Clrscr
    mov eax, white
    call SetTextColor

    mov edx, OFFSET introTitle
    call WriteString
    mov edx, OFFSET introRule1
    call WriteString
    mov edx, OFFSET introRule2
    call WriteString
    mov edx, OFFSET introRule3
    call WriteString
    call CrLf

    ; --- SHOW TOTAL ROUNDS ---
    mov edx, OFFSET msgTotalRounds
    call WriteString
    mov eax, roundsLimit
    call WriteDec
    call CrLf
    call CrLf

    mov edx, OFFSET colorHeader
    call WriteString

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET txtGreen
    call WriteString
    mov eax, white
    call SetTextColor
    mov edx, OFFSET msgGreen
    call WriteString

    mov eax, yellow
    call SetTextColor
    mov edx, OFFSET txtYellow
    call WriteString
    mov eax, white
    call SetTextColor
    mov edx, OFFSET msgYellow
    call WriteString

    mov eax, lightRed
    call SetTextColor
    mov edx, OFFSET txtRed
    call WriteString
    mov eax, white
    call SetTextColor
    mov edx, OFFSET msgRed
    call WriteString

    call CrLf
    mov edx, OFFSET introStart
    call WriteString
    call ReadChar
    call Clrscr
    ret
ShowIntro ENDP

; ===============================================
; PlayRound PROC with strict 5-letter validation
; and case-insensitive comparisons (normalize to UPPER)
; ===============================================
PlayRound PROC,
    setterNum:DWORD,
    guesserNum:DWORD,
    roundIndex:DWORD

    mov attemptCounter, 0

    ; --- 1. START OF ROUND ---
    call Clrscr
   
    ; Display Header
    mov eax, white
    call SetTextColor
    mov edx, OFFSET msgRoundHeader
    call WriteString
    mov eax, roundIndex
    inc eax                
    call WriteDec
    mov edx, OFFSET msgRoundOf
    call WriteString
    mov eax, roundsLimit
    call WriteDec
    mov edx, OFFSET msgRoundEnd
    call WriteString

; -------------------
; GET SECRET WORD (read whole line into lineBuf, then validate exact 5 chars)
; -------------------
GetSecret:
    mov eax, white
    call SetTextColor
   
    mov edx, OFFSET promptSecret
    call WriteString
    mov eax, setterNum
    call WriteDec
    mov edx, OFFSET promptSet
    call WriteString

    ; read entire input line into lineBuf (prevents leftover characters)
    mov edx, OFFSET lineBuf
    mov ecx, LENGTHOF lineBuf
    call ReadString

    ; count chars in lineBuf (up to null)
    mov esi, OFFSET lineBuf
    xor ecx, ecx
CountSecretLen:
    cmp byte ptr [esi], 0
    je CheckSecretLen
    inc ecx
    inc esi
    jmp CountSecretLen
CheckSecretLen:
    cmp ecx, 5
    je SecretOk
    mov edx, OFFSET invalidLengthMsg
    call WriteString
    jmp GetSecret

SecretOk:
    ; copy first 5 chars into bufSecret and null terminate
    mov esi, OFFSET lineBuf
    mov edi, OFFSET bufSecret
    mov ecx, 5
    rep movsb
    mov byte ptr [bufSecret+5], 0

    ; ----- NORMALIZE SECRET TO UPPERCASE -----
    mov esi, OFFSET bufSecret
    mov ecx, 5
NormalizeSecretLoop:
    mov al, [esi]
    cmp al, 'a'
    jb SkipSecretUpper
    cmp al, 'z'
    ja SkipSecretUpper
    sub al, 32        ; convert to uppercase
    mov [esi], al
SkipSecretUpper:
    inc esi
    loop NormalizeSecretLoop

    ; --- 2. AFTER SECRET (CLEAR SCREEN) ---
    call Clrscr
   
    ; Display Header AGAIN
    mov eax, white
    call SetTextColor
    mov edx, OFFSET msgRoundHeader
    call WriteString
    mov eax, roundIndex
    inc eax                
    call WriteDec
    mov edx, OFFSET msgRoundOf
    call WriteString
    mov eax, roundsLimit
    call WriteDec
    mov edx, OFFSET msgRoundEnd
    call WriteString

; -------------------
; GUESSING LOOP
; -------------------
GuessLoop:
    inc attemptCounter
   
    mov eax, white
    call SetTextColor

    mov edx, OFFSET promptSecret
    call WriteString
    mov eax, guesserNum
    call WriteDec
    mov edx, OFFSET promptGuess
    call WriteString
    mov eax, attemptCounter
    call WriteDec
    mov edx, OFFSET promptRest
    call WriteString

GetGuess:
    ; read entire input line into lineBuf
    mov edx, OFFSET lineBuf
    mov ecx, LENGTHOF lineBuf
    call ReadString

    ; count chars in lineBuf (up to null)
    mov esi, OFFSET lineBuf
    xor ecx, ecx
CountGuessLen:
    cmp byte ptr [esi], 0
    je CheckGuessLen
    inc ecx
    inc esi
    jmp CountGuessLen
CheckGuessLen:
    cmp ecx, 5
    je GuessOk
    mov edx, OFFSET invalidLengthMsg
    call WriteString
    jmp GetGuess

GuessOk:
    ; copy first 5 chars into bufGuess and null terminate
    mov esi, OFFSET lineBuf
    mov edi, OFFSET bufGuess
    mov ecx, 5
    rep movsb
    mov byte ptr [bufGuess+5], 0

    ; ----- NORMALIZE GUESS TO UPPERCASE -----
    mov esi, OFFSET bufGuess
    mov ecx, 5
NormalizeGuessLoop:
    mov al, [esi]
    cmp al, 'a'
    jb SkipGuessUpper
    cmp al, 'z'
    ja SkipGuessUpper
    sub al, 32        ; convert to uppercase
    mov [esi], al
SkipGuessUpper:
    inc esi
    loop NormalizeGuessLoop

    ; --- prepare tempSecret (copy) ---
    cld
    mov esi, OFFSET bufSecret
    mov edi, OFFSET tempSecret
    mov ecx, 5
    rep movsb

    ; Initialize status buffer
    mov ecx, 5
    mov edi, OFFSET statusBuf
    mov al, '-'
    rep stosb

    ; --- Logic: Green Pass ---
    mov ecx, 5
    xor esi, esi
CheckGreen:
    mov al, bufGuess[esi]
    cmp al, tempSecret[esi]
    jne NextGreen
    mov statusBuf[esi], 'G'
    mov tempSecret[esi], 0
NextGreen:
    inc esi
    loop CheckGreen

    ; --- Logic: Yellow Pass ---
    mov ecx, 5
    xor esi, esi
OuterYellow:
    cmp statusBuf[esi], 'G'
    je EndInner
    push ecx
    mov al, bufGuess[esi]
    mov ecx, 5
    xor edi, edi
InnerScan:
    cmp tempSecret[edi], 0
    je NextInner
    cmp tempSecret[edi], al
    jne NextInner
    mov statusBuf[esi], 'Y'
    mov tempSecret[edi], 0
    jmp PopInner
NextInner:
    inc edi
    loop InnerScan
PopInner:
    pop ecx
EndInner:
    inc esi
    loop OuterYellow

    ; --- Print Colored Word ---
    xor esi, esi
    mov ecx, 5
PrintLoop:
    mov al, statusBuf[esi]
    cmp al, 'G'
    je ColGreen
    cmp al, 'Y'
    je ColYellow
    mov eax, lightRed
    jmp DoPrint
ColGreen:
    mov eax, lightGreen
    jmp DoPrint
ColYellow:
    mov eax, yellow
DoPrint:
    call SetTextColor
    mov al, bufGuess[esi]    ; bufGuess is normalized to UPPER
    call WriteChar
    inc esi
    loop PrintLoop

    mov eax, white
    call SetTextColor
    call CrLf

    ; --- Check Win ---
    mov ecx, 5
    mov esi, OFFSET statusBuf
CheckWin:
    cmp byte ptr [esi], 'G'
    jne NoWinYet
    inc esi
    loop CheckWin
    jmp RoundWon

NoWinYet:
    mov eax, attemptCounter
    cmp eax, guessesAllowed
    jb GuessLoop

    ; Round Lost
    mov edx, OFFSET roundLostMsg
    call WriteString
    mov edx, OFFSET bufSecret
    call WriteString
    call CrLf
    jmp EndRound

RoundWon:
    mov edx, OFFSET roundWinMsg
    call WriteString
    mov eax, guesserNum
    call WriteDec
    mov edx, OFFSET roundWinSuffix
    call WriteString

    ; Update 2D Array (mark 1 for this player/round)
    mov eax, guesserNum
    dec eax                 ; zero-based player index
    mov ebx, ROW_SIZE
    mul ebx
    add eax, roundIndex
    mov esi, OFFSET ScoreHistory
    mov byte ptr [esi + eax], 1

EndRound:
    ; --- DISPLAY CURRENT SCORECARD ---
    call CrLf
    mov edx, OFFSET scorecardHeader
    call WriteString

    mov edx, OFFSET scoreStatusMsg  
    call WriteString
    mov eax, roundIndex
    inc eax                          
    call WriteDec
    mov edx, OFFSET scoreOfMsg      
    call WriteString          ; <-- fixed earlier: ensured WriteString is present
    mov eax, roundsLimit            
    call WriteDec
    call CrLf
    call CrLf

    ; Calculate P1
    mov esi, OFFSET ScoreHistory
    mov ecx, ROW_SIZE
    mov ebx, 0
SumP1:
    mov al, [esi]
    movzx eax, al
    add ebx, eax
    inc esi
    loop SumP1

    mov edx, OFFSET p1ScoreMsg
    call WriteString
    mov eax, ebx
    call WriteDec
    call CrLf

    ; Calculate P2
    mov esi, OFFSET ScoreHistory
    add esi, ROW_SIZE
    mov ecx, ROW_SIZE
    mov ebx, 0
SumP2:
    mov al, [esi]
    movzx eax, al
    add ebx, eax
    inc esi
    loop SumP2

    mov edx, OFFSET p2ScoreMsg
    call WriteString
    mov eax, ebx
    call WriteDec
    call CrLf

    mov edx, OFFSET nextRoundMsg
    call WriteString
    call ReadChar
    call Clrscr
    ret
PlayRound ENDP

END main

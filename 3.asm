                                .MODEL SMALL
.STACK 100H

.DATA
    msg1 DB 'Enter first two-digit number: $'
    msg2 DB 0DH, 0AH, 'Enter second two-digit number: $'
    msgSum DB 0DH, 0AH, 'The sum of two numbers is: $'
    msgAcc DB 0DH, 0AH, 'The accumulate of two numbers is: $'
    
    num1 DB 0   ; S? d?u tiên (8 bit)
    num2 DB 0   ; S? th? hai (8 bit)
    sum  DB 0   ; Bi?n d? luu t?ng (8 bit)
    acc  DW 1   ; Bi?n d? luu tích luy (16 bit), kh?i t?o là 1

.CODE
START:
    MOV AX, @DATA  ; Kh?i t?o do?n d? li?u
    MOV DS, AX

    ; In thông báo và nh?p s? th? nh?t
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    ; Nh?p s? d?u tiên t? bàn phím
    CALL ReadTwoDigitNumber ; G?i hàm nh?p s?

    ; Luu s? d?u tiên vào num1
    MOV num1, AL

    ; In thông báo và nh?p s? th? hai
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    ; Nh?p s? th? hai t? bàn phím
    CALL ReadTwoDigitNumber ; G?i hàm nh?p s?

    ; Luu s? th? hai vào num2
    MOV num2, AL

    ; Tính t?ng
    MOV AL, num1      ; T?i s? d?u tiên vào AL
    ADD AL, num2      ; C?ng s? th? hai
    MOV sum, AL       ; Luu t?ng vào bi?n sum

    ; Tính tích luy
    MOV AL, num1      ; T?i s? d?u tiên vào AL
    MOV BL, num2      ; T?i s? th? hai vào BL
    MOV acc, 1        ; Kh?i t?o acc là 1
    MUL BL             ; Tính tích
    MOV acc, AX       ; Luu k?t qu? vào acc

    ; In k?t qu? t?ng
    LEA DX, msgSum
    MOV AH, 09H
    INT 21H
    MOV AL, sum
    CALL PrintNumber   ; G?i hàm in s?

    ; In k?t qu? tích luy
    LEA DX, msgAcc
    MOV AH, 09H
    INT 21H
    MOV AX, acc       ; L?y giá tr? tích luy t? AX
    CALL PrintNumber   ; G?i hàm in s?

    ; K?t thúc chuong trình
    MOV AH, 4CH       ; K?t thúc chuong trình
    INT 21H

; Hàm nh?p s? hai ch? s?
ReadTwoDigitNumber PROC
    MOV AX, 0         ; Ð?t AX v? 0
    MOV CX, 2         ; Ð?m s? ch? s? nh?p vào
    MOV BX, 10        ; Ð? chia l?y ch? s?

ReadLoop:
    MOV AH, 01H
    INT 21H           ; Nh?p ký t?
    SUB AL, 30H       ; Chuy?n t? ASCII sang s?
    ; Ki?m tra n?u là s? h?p l?
    CMP AL, 0
    JB ReadLoop       ; N?u AL < 0, quay l?i
    CMP AL, 9
    JA ReadLoop       ; N?u AL > 9, quay l?i

    ; Chuy?n d?i và luu vào AL
    MOV AH, AL        ; Luu ch? s? hàng don v?
    DEC CX
    JZ DoneRead       ; N?u dã nh?p d? ch? s?, k?t thúc

    MOV AL, AH        ; L?y l?i hàng ch?c
    MUL BX            ; Tính 10 * hàng ch?c
    ADD AL, AH        ; C?ng hàng don v?
    JMP ReadLoop

DoneRead:
    RET
ReadTwoDigitNumber ENDP

; Hàm in s? (16 bit)
PrintNumber PROC
    PUSH AX           ; Luu AX vào stack
    PUSH DX           ; Luu DX vào stack
    MOV CX, 0         ; Bi?n d?m s? ch? s?
    MOV BX, 10        ; Ð? chia l?y t?ng ch? s?

PrintLoop:
    XOR DX, DX        ; Xóa DX
    DIV BX            ; Chia AX cho 10, ph?n du vào DX
    ADD DL, 30H       ; Chuy?n ph?n du thành ký t? ASCII
    PUSH DX           ; Ð?y ký t? vào stack
    INC CX            ; Tang bi?n d?m
    OR AX, AX
    JNZ PrintLoop     ; Ti?p t?c n?u AX không b?ng 0

PrintDigits:
    POP DX            ; L?y ký t? t? stack
    MOV AH, 02H
    INT 21H           ; In ký t?
    LOOP PrintDigits  ; L?p l?i cho d?n khi h?t

    POP DX            ; L?y DX t? stack
    POP AX            ; L?y AX t? stack
    RET
PrintNumber ENDP

END START

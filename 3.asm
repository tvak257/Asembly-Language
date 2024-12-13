                                .MODEL SMALL
.STACK 100H

.DATA
    msg1 DB 'Enter first two-digit number: $'
    msg2 DB 0DH, 0AH, 'Enter second two-digit number: $'
    msgSum DB 0DH, 0AH, 'The sum of two numbers is: $'
    msgAcc DB 0DH, 0AH, 'The accumulate of two numbers is: $'
    
    num1 DB 0   ; S? d?u ti�n (8 bit)
    num2 DB 0   ; S? th? hai (8 bit)
    sum  DB 0   ; Bi?n d? luu t?ng (8 bit)
    acc  DW 1   ; Bi?n d? luu t�ch luy (16 bit), kh?i t?o l� 1

.CODE
START:
    MOV AX, @DATA  ; Kh?i t?o do?n d? li?u
    MOV DS, AX

    ; In th�ng b�o v� nh?p s? th? nh?t
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    ; Nh?p s? d?u ti�n t? b�n ph�m
    CALL ReadTwoDigitNumber ; G?i h�m nh?p s?

    ; Luu s? d?u ti�n v�o num1
    MOV num1, AL

    ; In th�ng b�o v� nh?p s? th? hai
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    ; Nh?p s? th? hai t? b�n ph�m
    CALL ReadTwoDigitNumber ; G?i h�m nh?p s?

    ; Luu s? th? hai v�o num2
    MOV num2, AL

    ; T�nh t?ng
    MOV AL, num1      ; T?i s? d?u ti�n v�o AL
    ADD AL, num2      ; C?ng s? th? hai
    MOV sum, AL       ; Luu t?ng v�o bi?n sum

    ; T�nh t�ch luy
    MOV AL, num1      ; T?i s? d?u ti�n v�o AL
    MOV BL, num2      ; T?i s? th? hai v�o BL
    MOV acc, 1        ; Kh?i t?o acc l� 1
    MUL BL             ; T�nh t�ch
    MOV acc, AX       ; Luu k?t qu? v�o acc

    ; In k?t qu? t?ng
    LEA DX, msgSum
    MOV AH, 09H
    INT 21H
    MOV AL, sum
    CALL PrintNumber   ; G?i h�m in s?

    ; In k?t qu? t�ch luy
    LEA DX, msgAcc
    MOV AH, 09H
    INT 21H
    MOV AX, acc       ; L?y gi� tr? t�ch luy t? AX
    CALL PrintNumber   ; G?i h�m in s?

    ; K?t th�c chuong tr�nh
    MOV AH, 4CH       ; K?t th�c chuong tr�nh
    INT 21H

; H�m nh?p s? hai ch? s?
ReadTwoDigitNumber PROC
    MOV AX, 0         ; �?t AX v? 0
    MOV CX, 2         ; �?m s? ch? s? nh?p v�o
    MOV BX, 10        ; �? chia l?y ch? s?

ReadLoop:
    MOV AH, 01H
    INT 21H           ; Nh?p k� t?
    SUB AL, 30H       ; Chuy?n t? ASCII sang s?
    ; Ki?m tra n?u l� s? h?p l?
    CMP AL, 0
    JB ReadLoop       ; N?u AL < 0, quay l?i
    CMP AL, 9
    JA ReadLoop       ; N?u AL > 9, quay l?i

    ; Chuy?n d?i v� luu v�o AL
    MOV AH, AL        ; Luu ch? s? h�ng don v?
    DEC CX
    JZ DoneRead       ; N?u d� nh?p d? ch? s?, k?t th�c

    MOV AL, AH        ; L?y l?i h�ng ch?c
    MUL BX            ; T�nh 10 * h�ng ch?c
    ADD AL, AH        ; C?ng h�ng don v?
    JMP ReadLoop

DoneRead:
    RET
ReadTwoDigitNumber ENDP

; H�m in s? (16 bit)
PrintNumber PROC
    PUSH AX           ; Luu AX v�o stack
    PUSH DX           ; Luu DX v�o stack
    MOV CX, 0         ; Bi?n d?m s? ch? s?
    MOV BX, 10        ; �? chia l?y t?ng ch? s?

PrintLoop:
    XOR DX, DX        ; X�a DX
    DIV BX            ; Chia AX cho 10, ph?n du v�o DX
    ADD DL, 30H       ; Chuy?n ph?n du th�nh k� t? ASCII
    PUSH DX           ; �?y k� t? v�o stack
    INC CX            ; Tang bi?n d?m
    OR AX, AX
    JNZ PrintLoop     ; Ti?p t?c n?u AX kh�ng b?ng 0

PrintDigits:
    POP DX            ; L?y k� t? t? stack
    MOV AH, 02H
    INT 21H           ; In k� t?
    LOOP PrintDigits  ; L?p l?i cho d?n khi h?t

    POP DX            ; L?y DX t? stack
    POP AX            ; L?y AX t? stack
    RET
PrintNumber ENDP

END START

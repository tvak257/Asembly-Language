; Simplified program to calculate factorial (n < 9)

.model small
.stack 100h
.data
    prompt db "Enter a number (n < 9): $"
    result_msg db 0Dh, 0Ah, "Factorial: $"
    newline db 0Dh, 0Ah, "$"
.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Display prompt message
    lea dx, prompt
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 01h           ; Function to read a character
    int 21h
    sub al, '0'           ; Convert ASCII to number
    mov bl, al            ; Store input in BL for calculations

    ; Initialize factorial calculation
    mov ax, 1             ; AX will hold the running factorial result

factorial_loop:
    cmp bl, 1             ; Check if BL == 1
    je push_result         ; If yes, go to push result
    mul bl                ; Multiply AX by BL (AX = AX * BL)
    dec bl                ; Decrement BL by 1
    jmp factorial_loop    ; Repeat the loop

push_result:
    ; Push digits of the result onto the stack
    mov bx, 10            ; Divisor for converting to ASCII
push_digits:
    xor dx, dx            ; Clear DX
    div bx                ; Divide AX by 10, quotient in AX, remainder in DX
    push dx               ; Push remainder (digit) onto the stack
    cmp ax, 0             ; Check if quotient is 0
    jne push_digits       ; Repeat until no more digits

    ; Display result message
    lea dx, result_msg
    mov ah, 09h
    int 21h

    ; Pop and display digits
display_digits:
    pop dx                ; Pop digit from the stack
    add dl, '0'           ; Convert to ASCII
    mov ah, 02h           ; Function to print a character
    int 21h
    cmp sp, 100h          ; Check if stack is empty
    jne display_digits    ; Repeat until all digits are printed

    ; Print a newline
    lea dx, newline
    mov ah, 09h
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h

main endp
end main
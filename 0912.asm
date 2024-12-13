.model small
.stack 100h

.data
    prompt_n db 'Enter the number of terms: $'
    prompt_num db 'Enter a number: $'
    sum_msg db 'The sum of the numbers is: $'
    num db 0  ; Variable to store each digit of the current number
    n db 0    ; Variable to store the number of terms
    sum dw 0  ; Variable to store the sum

.code
main:
    ; Set up the data segment
    mov ax, @data
    mov ds, ax
    
    ; Prompt for the number of terms
    lea dx, prompt_n
    mov ah, 09h
    int 21h

    ; Read the number of terms (n)
    lea dx, num
    mov ah, 01h
    int 21h
    sub al, '0'    ; Convert ASCII to integer
    mov n, al      ; Store the number of terms

    ; Initialize sum to 0
    mov sum, 0
    
    ; Loop to input n numbers and calculate sum
    mov cl, n      ; Set loop counter to n

input_loop:
    lea dx, prompt_num
    mov ah, 09h
    int 21h

    ; Read the number (multi-digit number input)
    xor bx, bx      ; Clear bx (to store the current number)
    lea dx, num
    mov ah, 01h
    int 21h         ; Read first digit
    sub al, '0'     ; Convert ASCII to integer
    mov bl, al      ; Store first digit in bl

    lea dx, num
    mov ah, 01h
    int 21h         ; Read second digit
    sub al, '0'     ; Convert ASCII to integer
    mov bh, al      ; Store second digit in bh

    ; Combine the digits (bl = tens, bh = ones)
    mov al, bl
    mov ah, bh
    mov bx, ax      ; Combine digits into bx

    ; Add the number to the sum
    add sum, bx

    dec cl         ; Decrease the loop counter
    jnz input_loop ; If counter is not zero, repeat the loop

    ; Display the sum message
    lea dx, sum_msg
    mov ah, 09h
    int 21h

    ; Display the sum
    mov ax, sum
    call PrintNum

    ; Exit program
    mov ah, 4Ch
    int 21h

PrintNum:
    ; Print the number in AX (handling up to two digits)
    ; Extract tens and ones
    mov bx, 10
    xor dx, dx      ; Clear dx for division
    div bx          ; AX / 10 -> quotient in AL (tens), remainder in AH (ones)

    ; Print the tens place if it's not zero
    add al, '0'     ; Convert to ASCII
    mov dl, al
    mov ah, 02h
    int 21h

    ; Print the ones place
    add ah, '0'     ; Convert to ASCII
    mov dl, ah
    mov ah, 02h
    int 21h
    ret

end main

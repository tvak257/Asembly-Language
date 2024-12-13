.model small
.stack 100h

.data
    prompt db 'Enter 5 numbers: $'
    newline db 0Dh,0Ah,'$'
    max_msg db 'Maximum number is: $'
    numbers db 5 dup(?)  ; Array to store the 5 numbers

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Print prompt message
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Input 5 numbers and store them in the array
    lea si, numbers  ; SI points to the array
    mov cx, 5         ; Loop counter for 5 numbers

input_loop:
    mov ah, 01h       ; DOS function to read a single character
    int 21h           ; Get the character from the keyboard
    sub al, 30h       ; Convert ASCII to integer (by subtracting '0')
    mov [si], al      ; Store the number in the array
    inc si            ; Move to next array element
    loop input_loop   ; Repeat for 5 numbers

    ; Find the maximum number
    lea si, numbers   ; SI points to the array
    mov bl, [si]      ; Load first number into AL (assume it's the maximum)
    inc si            ; Move to next element
    mov cx, 5         ; We already have the first number, so loop for 4 remaining

find_max:
    lodsb      ; Load next number into BL
    cmp bl, al        ; Compare current maximum (AL) with current number (BL)
    jge skip_update   ; If AL >= BL, skip updating
    mov bl, al        ; Update AL with the new maximum
skip_update:
    inc si            ; Move to the next number
    loop find_max     ; Repeat for all numbers

    ; Display the maximum number
    mov ah, 09h
    lea dx, max_msg
    int 21h

    ; Convert maximum number to ASCII and display it
    add bl, '0'       ; Convert the number back to ASCII
    mov dl, bl        ; Move the number to DL for printing
    mov ah, 02h       ; DOS function to display a character
    int 21h

    ; Print a newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Exit the program
    mov ah, 4Ch
    int 21h
main endp
end main

.model small
.stack 100h

.data
    msg1 db 'Enter first number: $'
    msg2 db 'Enter second number: $'
    resultMsg db 'The sum is: $'
    num1 db ?
    num2 db ?
    sum db ?

.code
main:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Input first number
    mov dx, offset msg1
    mov ah, 09h
    int 21h

    ; Read first number
    mov ah, 01h
    int 21h
    sub al, '0'     ; Convert ASCII to integer
    mov num1, al    ; Store first number

    ; Move to a new line after first number input
    mov ah, 02h
    mov dl, 0Dh       ; Carriage return
    int 21h
    mov dl, 0Ah       ; Line feed
    int 21h

    ; Input second number
    mov dx, offset msg2
    mov ah, 09h
    int 21h

    ; Read second number
    mov ah, 01h
    int 21h
    sub al, '0'     ; Convert ASCII to integer
    mov num2, al    ; Store second number

    ; Move to a new line after second number input
    mov ah, 02h
    mov dl, 0Dh       ; Carriage return
    int 21h
    mov dl, 0Ah       ; Line feed
    int 21h

    ; Calculate sum
    mov al, num1
    add al, num2   ; AL = num1 + num2
    mov sum, al    ; Store result

    ; Display result message
    mov dx, offset resultMsg
    mov ah, 09h
    int 21h

    ; Convert sum to ASCII
    add sum, '0'   ; Convert integer to ASCII
    mov dl, sum    ; Move result to DL for output
    mov ah, 02h    ; Function to display character
    int 21h

    ; Move to a new line after displaying result
    mov ah, 02h
    mov dl, 0Dh       ; Carriage return
    int 21h
    mov dl, 0Ah       ; Line feed
    int 21h

    ; Exit program
    mov ax, 4C00h
    int 21h
end main
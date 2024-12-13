.model small
.stack 100h
.data
f db 'Enter first num: $'
s db 10,13, 'Enter second number: $'
r db 10,13, 'Sub: $'
num1 db ?
num2 db ?

.code
main proc
    ; Initialize the data segment
    mov ax, @data
    mov ds, ax

    ; Prompt for first number
    mov ah, 09h
    lea dx, f
    int 21h

    ; Read first number (character input)
    mov ah, 01h
    int 21h
    sub al, 30h       ; Convert ASCII to integer
    mov bl, al        ; Store first number in bl

    ; Prompt for second number
    mov ah, 09h
    lea dx, s
    int 21h

    ; Read second number (character input)
    mov ah, 01h
    int 21h
    sub al, 30h       ; Convert ASCII to integer
    mov bh, al        ; Store second number in bh

    ; Perform subtraction (bl - bh)
    sub bl, bh        ; Subtract second number from first number

    ; Convert result back to ASCII
    add bl, 30h       ; Convert back to ASCII

    ; Display result message
    mov ah, 09h
    lea dx, r
    int 21h

    ; Display the result of the subtraction
    mov ah, 02h
    mov dl, bl        ; Output the result
    int 21h

    ; Exit program
exit:
    mov ah, 4Ch
    int 21h

main endp
end main

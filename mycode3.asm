.model small
.stack 100h

.data
prompt db 'Enter the number of stars: $'
newline db 0Ah, 0Dh, '$'


.code
main proc
    ; Initialize the data segment
    mov ax, @data
    mov ds, ax

    ; Display prompt message
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Read the input number (single digit) from the keyboard
    mov ah, 01h      ; Function to read a character from the keyboard
    int 21h          ; Wait for user input
    sub al, '0'      ; 
    mov bl, al       ; 
    
    ; Print newline after stars
    mov ah, 09h
    lea dx, newline
    int 21h


    ; Print stars in a loop
print_stars:
    mov ah, 02h      ; Function to print a character
    mov dl, '*'      ; 
    int 21h          ; Print the star

    dec bl       
    jnz print_stars 

    ; Exit the program
    mov ah, 4Ch
    int 21h

main endp
end main

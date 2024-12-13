.model small
.stack 100h

.data
    prompt1 db 'Enter the first two-digit number: $'
    prompt2 db 'Enter the second two-digit number: $'
    sum db 10,13, 'Sum: $'
    prod_msg db 'Product: $'
    newline db 0Dh,0Ah, '$'

.code
    main proc
    mov ax, @data
    mov ds, ax

    ; Prompt for the first number
    mov ah, 09h
    lea dx, prompt1
    int 21h

    ; Input the first number (2 digits)
    mov ah, 01h
    int 21h      
    mov bh, al        ; Store first digit in bl
    
    
    ; Read second digit
    mov ah, 01h
    int 21h    
    mov bl, al 
    

    ; Prompt for the second number
    mov ah, 09h
    lea dx, prompt2
    int 21h

    mov ah, 01h
    int 21h      
    mov ch, al        ; Store first digit in bl
    
    
    ; Read second digit
    mov ah, 01h
    int 21h      
    mov cl, al 

    ; Calculate sum (bl + bh)
    add bh, ch
    add bl, cl  ; 
   
    ; Display sum message
    mov ah, 09h
    lea dx, sum
    int 21h
    
    mov ah, 02h  ; Display character
    mov dl, bh   ; Move result to dl for printing
    sub dl, '0'
    int 21h
    
    mov ah, 02h  ; Display character
    mov dl, bl   ; Move result to dl for printing
    sub dl,'0'
    int 21h  
    
    
    sub bh, ch
    sub bl, cl


    
    main endp

end main

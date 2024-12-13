.model small
.stack 0100H
.data 
    num db 10,13, 'Enter number: $'
    ans db 10,13, 'The factorial is $'

.main proc

    mov ax, @data
    mov ds, ax

    lea dx,num
    mov ah, 09
    int 21H

    mov  ah, 01h
    int  21h       ; 
    sub  al, '0'
    
    mov  ax, 5h            ; -> AX is [1,5]
    mov  cx, ax
    dec  cx
fac:
    mul  cx
    loop fac
    cmp  bl, 2
    ja   fac

    lea dx,ans
    mov ah, 09
    int 21H

    mov ah, 02
    mov dl, bl
    int 21H

    mov ah, 4ch
    int 21H
    int 20H

end
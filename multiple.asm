.model small
.stack 100h
.data
f db 'enter first num: $'
s db 10,13, 'enter second number: $'
r db 10,13, 'mul: $'
num1 db ?
num2 db ?

.code
    main proc
        mov ax, @data
        mov ds, ax
        
        mov ah, 09h
        lea dx, f
        int 21h
        
        mov ah, 01h
        int 21h
        sub al, 48
        mov num1, al
        
        mov ah, 09h
        lea dx, s
        int 21h
        
        mov ah, 01h
        int 21h
        sub al,48
        mov num2, al
        
        mov al,num1
        mul num2
        aam
        
        mov bh, ah
        mov bl, al
        
        mov ah, 09h
        lea dx, r
        int 21h
        
        mov ah, 02h
        mov dl,bh
        add dl,48
        int 21h
        
        mov ah, 02h
        mov dl, bl
        add dl, 48
        int 21h
        
        exit:
            mov ah, 4ch
            int 21h
        
        
    main endp  
end main
.model small
.stack 100h

.data
    prompt1 db "Enter the number of terms: $"
    prompt2 db "Enter a number: $"
    resultMsg db "The sum is: $"
    sum dw 0          ; 
    n dw 0            ; 
    arr db 10 dup(0)  ; 
    muoi db 10
    
.code
    main proc
    ; data segment
    mov ax, @data
    mov ds, ax
    ; In ra thong bao"Enter the number of terms:"
    lea dx, prompt1
    mov ah, 09h
    int 21h

    ; Nhap vao so phan tu cua mang
    mov ah, 01h         
    int 21h
    sub al, 30h         
    mov bl, al          
    mov [n], bx          

    
    xor ax, ax

    
input_loop:
    mov bx, [n]         
    cmp bx, 0            
    je sum_loop          

    ; In ra "Enter a number:"
    lea dx, prompt2
    mov ah, 09h
    int 21h

    ; Nhap mot so
    mov ah, 01h         ; Nhap mot so tu ban phim
    int 21h
    sub al, 30h         ; Chuy?n d?i ASCII sang s? nguyên
    mov [arr + di], al  ; Luu s? vào m?ng

  
    inc di
    dec word ptr [n]    ; 

    jmp input_loop

                        ; 
xor ax, ax          ;
xor si, si
lea si, arr

sum_loop:
    xor bx, bx
    mov bl, [si]
    sub bl, 30h     
    add ax, bx  ; 
    inc si
    dec bx              ;               ; 
    jmp sum_loop        ; 



xor cx, cx

lapchia:

    xor dx, dx
    div muoi
    add ah, 30h
    mov dl, ah
    push dx
    inc cx
    xor ah, ah
    cmp ax, 0
    jne lapchia
    
    
 lea dx, resultMsg
 mov ah, 09h
 int 21h
print_result:
    pop dx        
    mov ah, 02h                   
    int 21h
    loop print_result

  mov ah, 4Ch         
    int 21h 
main endp
end main

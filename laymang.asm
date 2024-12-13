org 100h

.data      
num1_O db ?
num2_O db ?
num1_T db ?
num2_T db ? 
temp db ? 
carry db ? 
1st db ?
2nd db ?
3rd db ?
4th db ?
ent_num db " ENTER NUMBER $"
ans db "Products = $"

.code
start:                          
     mov ax, @data
     mov ds, ax
     mov dx, offset ent_num
     mov ah, 09h
     int 21h
     
     mov ah, 01h               ;1
     int 21h   
     sub al, 30h
     mov num1_T, al
     
     mov ah, 01h               ;2
     int 21h   
     sub al, 30h
     mov num1_O, al  
     
     
     mov dx, offset ent_num
     mov ah, 09h
     int 21h  
     
     mov ah, 01h                 ;1
     int 21h
     sub al, 30h
     mov num2_T, al
     
     mov ah, 01h                  ;2       al
     int 21h
     sub al, 30h 
     mov num2_O, al 
     
     mov 1st, 0
     mov 2nd, 0
     mov 3rd, 0
     mov 4th, 0
     
     
     
     mov al, num2_O
     mul num1_O
     mov ah, 00h
     aam
     
     add 3rd, ah         ;
     add 4th, al 
     
     
     mov al, num2_O
     mul num1_T
     mov ah, 00h
     aam
     
     add 2nd, ah            ;carry
     add 3rd, al  
                    
     
     mov al, num2_T
     mul num1_O
     mov ah, 00h
     aam
     
     add 2nd, ah            ;carry
     add 3rd, al   
     
     
     mov al, num2_T
     mul num1_T
     mov ah, 00h
     aam
     
     add 1st, ah            ;carry
     add 2nd, al   
     
     mov dl, 010
     mov ah, 02h
     int 21h
     mov dx, offset ans
     mov ah, 09h
     int 21h
     
     
     mov al, 3rd
     mov ah, 00h
     aam
     
     add 2nd, ah
     mov 3rd, al 
     
     
     mov al, 2nd
     mov ah, 00h
     aam
     
     mov 2nd, al
     add 1st, ah
     
     mov dl, 1st
     add dl, 30h
     mov ah, 02h
     int 21h 
     
     mov dl, 2nd
     add dl, 30h
     mov ah, 02h
     int 21h
     
     mov dl, 3rd
     add dl, 30h
     mov ah, 02h
     int 21h
     
     mov dl, 4th
     add dl, 30h
     mov ah, 02h
     int 21h
     end start
   

ret
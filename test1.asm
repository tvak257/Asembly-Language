.MODEL SMALL
.STACK 100H
.DATA
    prompt1 DB 'Enter first number: $'
    prompt2 DB 0DH,0AH, 'Enter second number: $'
    greaterMsg DB 0DH, 0AH, 'The first number is greater.$'
    lessMsg DB 0DH, 0AH, 'The second number is greater.$'
    equalMsg DB 0DH, 0AH, 'The numbers are equal.$'
    
    num1 DB ?        ; 
    num2 DB ?        ; 

.CODE
MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX
    
    
    MOV AH, 09H            ; 
    LEA DX, prompt1
    INT 21H                ; 

    MOV AH, 01H            ; 
    INT 21H                ; 
    SUB AL, 30H            ; 
    MOV num1, AL           ; 
    
    MOV AH, 09H            ; 
    LEA DX, prompt2
    INT 21H                ; 

    MOV AH, 01H            ; 
    INT 21H                ; 
    SUB AL, '0'            ; 
    MOV num2, AL           ; 
    

    MOV AL, num1           ;
    CMP AL, num2           ; 
    
    JG first_is_greater    ; 
    JL second_is_greater   ; 
    JE numbers_are_equal   ; 

first_is_greater:
   
    MOV AH, 09H
    LEA DX, greaterMsg
    INT 21H
    JMP end_program

second_is_greater:
   
    MOV AH, 09H
    LEA DX, lessMsg
    INT 21H
    JMP end_program

numbers_are_equal:
    
    MOV AH, 09H
    LEA DX, equalMsg
    INT 21H

end_program:
 
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN

include 'emu8086.inc'

.model small         
.stack 100h         
.data 
        
        thanks db "Thank you for using student database $" 
        welcome db "============= Welcome to VNU-IS Student Datbase ================$"
        informem1 db "Nguyen Ngoc Trung - 22070167 $"
        informem2 db "Dinh Ngoc Diep - 22071183 $"
        informem3 db "Pham Van Tai - 22070088 $"  
        
        inp_w db "Press 1 to enter student info$"
        view_all db "Press 2 to view all records$"
        search_by_dept db "Press 3 to search by Department$"  
        search_by_id db "Press 4 to search by ID$" 
        search_by_name db "Press 5 to search by Name$" 
        search_by_cgpa db "Press 6 to search by CGPA$"  
        comma_str db ',',0
        space_str db ' ',0 
        newline_str db 0Dh,0Ah,0
           
        PSWRD DB 'anhtrungdzvcl'
        BUFF DB 20 DUP(?)
        MSG1 DB 'Enter your password: $'
        MSG2 db 'Wrong password!$'
        MSG3 db 'Correct password!$'
        
           
        enter_dept_search db "Enter Department to search$"
        enter_id_search  db "Enter Id to search$"
        enter_name_search   db "Enter Name to search$"
        enter_cgpa_search   db  "Enter CGPA to search$"
        ; Define the CSV file name and buffer for writing data
        file_name db "data.csv", 0
        filename db 'data.csv', 0
        msg      db ' ',0Dh,0Ah,'$'
        file_error_msg db 'Failed to open file.',0Dh,0Ah,'$'
        csv_buffer db 255 dup(0)    ; Buffer to hold the CSV line  
        buffer   db 256 dup(?)  
           
           
       exit db  "Press 7 to exit$"
       ent_name db "Enter Student Name$"
       ent_id db "Enter Student Id$"
       ent_dept db "Enter Student Department$"
       ent_cgpa db "Enter Student CGPA$"
       space db "     $"
        
       id db 25 dup('$')
       names db 25 dup('$')
       dept db 25 dup('$')  
       cgpa db 25 dup('$')
        
       idsearch db 10 dup('$')
       namesearch db 5 dup('$')
       deptsearch db 5 dup('$')
       cgpasearch db 5 dup('$') 
       msg_no_file     db 0Dh,0Ah, "Cannot open file data.csv ...$"
       msg_done        db 0Dh,0Ah, "Done searching!$"
        
       id_search_var    db 25 dup('$')    
       msg_done_id      db 0Dh,0Ah, "Done ID search!$"
       msg_no_file_id   db 0Dh,0Ah, "Cannot open file data.csv for ID search...$"
       printed_count_id db 0                                                        
       name_search_var    db 30 dup('$')  
       enter_name_search2 db 0Dh,0Ah, "Enter Name to search (partial): $"
       msg_done_name      db 0Dh,0Ah, "Done Name search!$"
       msg_no_file_name   db 0Dh,0Ah, "Cannot open file data.csv for NAME search...$"  
       cgpa_search_var    db 30 dup('$')  
       enter_cgpa_search2 db 0Dh,0Ah, "Enter CGPA to search (partial): $"
        
       msg_done_cgpa      db 0Dh,0Ah, "Done CGPA search!$"
       msg_no_file_cgpa   db 0Dh,0Ah, "Cannot open file data.csv for CGPA search...$"         
       printed_count_cg   db 0        
                                                                  
       a db 0       
       b db 0       
       c db 0
       d db 0        
       i db 0  
       index dw 0
       printed_count db 0  


.code 
        
        mov ax,@data
        mov ds,ax
        main proc        
        mov si,0
        mov bl,0 
                              
        lea dx,welcome    ;msg-welcome to student database$
        mov ah,9
        int 21h
        call newline
        call newline
        call reset    
           
            
        ;msg-infor123 
         lea dx,informem1    
         mov ah,9
         int 21h
         call newline
         call newline
         call reset   
         lea dx,informem2   
         mov ah,9
         int 21h
         call newline
         call newline
         call reset     
         lea dx,informem3   
         mov ah,9
         int 21h
         call newline
         call newline
         call reset
         
         ; Buffer, MSG1, MSG2, MSG3, PSWRD, initial, newline, reset 

         lea dx, BUFF
         mov ah, 0Ah   ; DOS read buffered string? 
                      
         int 21h

         ;  If the password is wrong, restart from label 'adu'
         
adu:     lea dx, MSG1    ; "Enter password" 
         mov ah, 09h     ; DOS function to display a string
         int 21h
        
         ; Clear the contents of BUFF before input
         
         lea di, BUFF
         mov cx, 13      ; Set up a loop to clear 13 bytes
clear_buff:
         mov byte ptr [di], 0  ; Set each byte in BUFF to 0
         inc di
         loop clear_buff

         ; Start password input (up to 13 characters, Enter ends input)

         lea di, BUFF       ; Set DI to point to the buffer for user input
         mov cx, 13         ; Maximum 13 characters allowed
input_loop:
         mov ah, 7          ; DOS function 7: read one character from the keyboard (no echo)
         int 21h
         cmp al, 13         ; Check if the Enter key was pressed
         je compare         ; If Enter is pressed, jump to comparison
         cmp al, 8          ; Backspace?
         je handle_bksp

         ; If a regular character is entered
         cmp cx, 0
         je skip_char       ; If quota of 13 characters is exhausted, skip further input

         mov [di], al       ; Store the entered character in the buffer
         inc di             ; Move to the next position in the buffer
         dec cx             ; Decrease the available quota
         mov ah, 2          ; DOS function to display a single character
         mov dl, '*'        ; Display '*' for each character entered
         int 21h
         jmp input_loop     ; Repeat input loop

handle_bksp:
         ; If the user presses Backspace, delete one character if possible
         lea bx, BUFF       ; Load the starting address of BUFF
         cmp di, bx
         jbe input_loop     ; If DI <= start of buffer, no deletion is possible
         dec di             ; Move one step back in the buffer
         inc cx             ; Increase the available quota
         mov [di], 0        ; Clear the last character in the buffer 
         
         ; Erase '*' from the screen by sending backspace, space, backspace
         mov ah, 2
         mov dl, 8          ; backspace
         int 21h
         mov dl, ' '        ; Space
         int 21h
         mov dl, 8          ; Backspace again to move the cursor back
         int 21h
         jmp input_loop     ; Return to the input loop

skip_char:
         ; Skip the character if the 13-character limit is reached
         jmp input_loop

compare:
         ; End of input => Add a null byte (0) at the end of the buffer
         mov byte ptr [di], 0
         
         ; Compare BUFF with PSWRD 
         ;====================================================
         call newline
         lea si, PSWRD      ; Load the correct password into SI
         lea di, BUFF       ; Load the entered password into DI

         mov cx, 13         ; Compare up to 13 characters
         mov bx, 0          ; Clear BX for use in comparison

YY:      mov bl, [si]       ; Load a byte from the correct password
         mov bh, [di]       ; Load a byte from the entered password
         inc si             ; Move to the next character in PSWRD
         inc di             ; Move to the next character in BUFF
         cmp bl, 0          ; Check if the end of the correct password is reached
         je check_len       ; If yes, verify the lengths match
         cmp bh, 0          ; Check if the entered password is shorter
         je ZZ              ; If yes, passwords do not match
         cmp bl, bh         ; Compare the characters
         jne ZZ             ; If any character differs, passwords do not match
         loop YY            ; Continue comparing until CX is exhausted

check_len:
         ; If the correct password (PSWRD) is longer than 13 characters, 
         ; the loop will finish comparing all characters. However, BUFF might  
         ; end earlier (user entered a shorter password).
         ; To allow access in this scenario, assume a match is valid 
         ; if the loop does not jump to ZZ (mismatch).   
         
         ; If match => grant access 
         call newline       ; Print a newline for formatting
         mov ah, 09h        ; DOS function to display a string
         lea dx, MSG3       ; Load the address of MSG3 (success message)
         int 21h 
         call newline       ; Print a newline
         call newline       ; Print an additional newline for spacing
         jmp initial        ; Jump to the `initial` label to restart or proceed

ZZ:      call newline
         ; If passwords do not match, deny access and go back to 'adu'
         lea dx, MSG2       ; Load the address of MSG2 (failure message)
         mov ah, 09h        ; DOS function to display a string
         int 21h
         call newline
         jmp adu            ; Jump back to the 'adu' label for retrying password

          
initial:                    ; Main program logic starting point     
         call starting      ; Call a subroutine to set up the program
         call input         ; Call a subroutine to get input from the user        
         cmp al,037h        ; Compare input (ASCII value of '7')
         je end_print           ; If input matches '7', jump to `end_print`
         call newline           ; Otherwise, print a newline for formatting
         jmp initial            ; Restart the main logic loop
             
end_print:                      ; Exit sequence and thank the user
         call reset             ; Call reset subroutine (cleanup/reset program state)
         call newline           
         call newline           
         call reset             ; Call reset subroutine again for thorough cleanup
         lea dx, thanks         ; Load the address of `thanks` message ("Thank you!")
         mov ah, 9              ; DOS function to display a string
         int 21h
         call reset             ; Call reset subroutine again

done:                           ; Terminate the program
         mov ah, 4Ch            ; DOS terminate program function
         int 21h
        
         endp main              ; End of the main procedure      
         
                  
         ;//////////////////// procedures//////////////////////////////////////// 
          
proc starting    ; Procedure to display the start screen with menu options
         lea dx, inp_w       ; Load address of the message: "Press 1 to enter student info"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline        ; Move to a new line
         call reset          ; Reset all register values

         lea dx, view_all    ; Load address of the message: "Press 2 to view all records"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         lea dx, search_by_dept ; Load address of the message: "Press 3 to search by department"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         lea dx, search_by_id ; Load address of the message: "Press 4 to search by ID"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         lea dx, search_by_name ; Load address of the message: "Press 5 to search by name"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         lea dx, search_by_cgpa ; Load address of the message: "Press 6 to search by CGPA"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         lea dx, exit        ; Load address of the message: "Press 7 to exit"
         mov ah, 9           ; DOS function to display a string
         int 21h
         call newline
         call reset          ; Reset all register values

         ret                 ; Return from the procedure
         endp starting       ; End of the starting procedure


proc newline    ; Procedure to print a new line (carriage return and line feed)
          mov ah, 2          ; DOS function to output a single character
          mov dl, 13         ; ASCII code for carriage return
          int 21h

          mov ah, 2          ; DOS function to output a single character
          mov dl, 10         ; ASCII code for line feed
          int 21h
          ret                ; Return from the procedure
          endp newline       ; End of the newline procedure


proc reset      ; Procedure to reset all register values to 0
          mov ax, 0          ; Clear AX register
          mov bx, 0          ; Clear BX register
          mov cx, 0          ; Clear CX register
          mov dx, 0          ; Clear DX register
          ret                ; Return from the procedure
          endp reset         ; End of the reset procedure


proc input      ; Procedure to handle menu input from the user
          call newline       ; Move to a new line
          call reset         ; Reset all register values
          mov ah, 1          ; DOS function to read a single character from the keyboard
          int 21h

          cmp al, 031h       ; Compare input with ASCII code for '1'
          je student_entry   ; Jump to `student_entry` if user presses '1'

          cmp al, 032h       ; Compare input with ASCII code for '2'
          je record_view     ; Jump to `record_view` if user presses '2'

          cmp al, 033h       ; Compare input with ASCII code for '3'
          je searchdept      ; Jump to `searchdept` if user presses '3'

          cmp al, 034h       ; Compare input with ASCII code for '4'
          je searchid        ; Jump to `searchid` if user presses '4'

          cmp al, 035h       ; Compare input with ASCII code for '5'
          je searchname      ; Jump to `searchname` if user presses '5'

          cmp al, 036h       ; Compare input with ASCII code for '6'
          je searchcgpa      ; Jump to `searchcgpa` if user presses '6'

          ret                ; Return from the procedure if no valid input
          endp input         ; End of the input procedure
                
       
proc student_entry  ; ===== Procedure for entering student information into the database =====

    call newline      ; Move to a new line for better formatting
    call reset        ; Reset all register values

; =================== INPUT STUDENT ID =======================
id_input:
    mov si, 0         ; Initialize index to 0
    call reset        ; Reset all registers

    lea dx, ent_id    ; Load message: "Enter Student ID"
    mov ah, 9         ; DOS function to display a string
    int 21h
    call newline      ; Move to a new line
    call reset        ; Reset all registers

taking_id_input:      ; Loop to take input for the student ID
    mov ah, 1         ; DOS function to read a single character
    int 21h
    cmp al, 13        ; Check if the user pressed Enter (ASCII 13)
    je end_id_input   ; If Enter, finish ID input
    mov id[si], al    ; Store character in the `id` array
    inc si            ; Increment index
    jmp taking_id_input ; Repeat for the next character

end_id_input:         ; End of ID input
    mov id[si], 0     ; Null-terminate the ID string

; =================== INPUT STUDENT NAME =======================
    call newline
    mov si, 0         ; Reset index
    call reset

    lea dx, ent_name  ; Load message: "Enter Student Name"
    mov ah, 9         ; DOS function to display a string
    int 21h
    call newline
    call reset

name_input:           ; Loop to take input for the student name
    mov ah, 1
    int 21h
    cmp al, 13        ; Check if Enter is pressed
    je end_name_input ; Finish name input if Enter is pressed
    mov names[si], al ; Store character in the `names` array
    inc si            ; Increment index
    jmp name_input    ; Repeat for the next character

end_name_input:       ; End of name input
    mov names[si], 0  ; Null-terminate the name string

; =================== INPUT STUDENT DEPARTMENT =======================
    call newline
    mov si, 0
    call reset

    lea dx, ent_dept  ; Load message: "Enter Student Department"
    mov ah, 9         ; DOS function to display a string
    int 21h
    call newline
    call reset

dept_input:           ; Loop to take input for the student department
    mov ah, 1
    int 21h
    cmp al, 13        ; Check if Enter is pressed
    je end_dept_input ; Finish department input if Enter is pressed
    mov dept[si], al  ; Store character in the `dept` array
    inc si            ; Increment index
    jmp dept_input    ; Repeat for the next character

end_dept_input:       ; End of department input
    mov dept[si], 0   ; Null-terminate the department string

; =================== INPUT STUDENT CGPA =======================
    call newline
    mov si, 0
    call reset

    lea dx, ent_cgpa  ; Load message: "Enter Student CGPA"
    mov ah, 9         ; DOS function to display a string
    int 21h
    call newline
    call reset

cgpa_input:           ; Loop to take input for the student CGPA
    mov ah, 1
    int 21h
    cmp al, 13        ; Check if Enter is pressed
    je end_cgpa_input ; Finish CGPA input if Enter is pressed
    mov cgpa[si], al  ; Store character in the `cgpa` array
    inc si            ; Increment index
    jmp cgpa_input    ; Repeat for the next character

end_cgpa_input:       ; End of CGPA input
    mov cgpa[si], 0   ; Null-terminate the CGPA string

    call newline
    call reset

; =================== OPEN/APPEND FILE TO CSV =======================
    lea dx, file_name ; Load the file name
    mov ah, 3Dh       ; DOS open file function
    mov al, 2         ; Open for read/write
    int 21h
    mov bx, ax        ; Save the file handle
    jmp seek_eof      ; Jump to seek the end of the file

seek_eof:             ; Move the file pointer to the end
    mov ah, 42h       ; DOS move file pointer function
    mov al, 2         ; Move to the end of the file
    xor cx, cx        ; Clear CX and DX (offset 0)
    xor dx, dx
    int 21h

; =================== WRITE RECORD: "ID NAME DEPT CGPA\r\n" =======================
    ; Write student ID
    lea dx, id
    call write_to_file

    ; Write a separator (e.g., a comma or space)
    lea dx, comma_str ; String: ','
    call write_to_file

    ; Write student name
    lea dx, names
    call write_to_file

    lea dx, comma_str ; Separator
    call write_to_file

    ; Write student department
    lea dx, dept
    call write_to_file

    lea dx, comma_str ; Separator
    call write_to_file

    ; Write student CGPA
    lea dx, cgpa
    call write_to_file

    ; Add a newline to the file
    lea dx, newline_str ; String: "\r\n"
    call write_to_file

    call reset          ; Reset registers

    ; Close the file
    mov ah, 3Eh         ; DOS close file function
    int 21h

    ret                 ; Return from the procedure
endp student_entry      ; End of `student_entry` procedure



;===============================================
; WRITE_TO_FILE: Write the string at DS:DX (null-terminated) to file handle in BX
;===============================================
proc write_to_file
        push ax        ; Save AX register
        push bx        ; Save BX register (file handle)
        push cx        ; Save CX register (length of string)
        push dx        ; Save DX register (start address of string)
        push si        ; Save SI register (used for calculating string length)

        mov si, dx     ; Load string starting address into SI
find_len:
        mov al, [si]   ; Read a character from the string
        cmp al, 0      ; Check for null-terminator
        je done_len    ; If null-terminator, string length calculation is done
        inc si         ; Move to the next character
        jmp find_len   ; Repeat until null-terminator is found

done_len:
        mov cx, si     ; Load the end address of the string into CX
        sub cx, dx     ; Calculate the string length (CX = SI - DX)

        mov ah, 40h    ; DOS function to write to file
        int 21h        ; Call DOS interrupt to write the string

        pop si         ; Restore SI register
        pop dx         ; Restore DX register
        pop cx         ; Restore CX register
        pop bx         ; Restore BX register
        pop ax         ; Restore AX register
        ret            ; Return from procedure
endp write_to_file

;===============================================
; COUNTER_CHECK: Multiply the value in variable 'b' by 5 and store in 'a'
;===============================================
proc counter_check
        mov ax, 0      ; Clear AX register
        mov bx, 0      ; Clear BX register
        mov bl, 5      ; Load multiplier (5) into BL
        mov al, b      ; Load the value of variable 'b' into AL
        mul bl         ; Multiply AL by BL (result stored in AX)
        mov a, al      ; Store the lower byte of the result into variable 'a'
        ret            ; Return from procedure
endp counter_check
       
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       
proc record_view ; Procedure to view all student records
    call reset         ; Reset registers
    call newline       ; Move to a new line
    lea dx, filename   ; DX points to the file name "data.csv"
    mov ah, 3Dh        ; DOS function 3Dh = Open file
    mov al, 0          ; AL=0 => Open file in read-only mode
    int 21h            ; Call DOS interrupt

    mov bx, ax         ; BX = File handle (if the file opened successfully)

read_file:    
    ;-----------------------------------------------------------------
    ; READ FILE (Using DOS interrupt 21h, function 3Fh)
    ;-----------------------------------------------------------------
    lea dx, buffer      ; DX points to the buffer to store data
    mov ah, 3Fh        ; DOS function 3Fh = Read from file
    mov cx, 256        ; Request to read 256 bytes
    int 21h            ; Call DOS interrupt
    ; AX = Number of bytes actually read

    cmp ax, 0          ; Compare AX with 0
    je close_file      ; If AX=0 => End of file (EOF), close the file

    ; Temporarily save AX (number of bytes read) on the stack
    push ax

    mov cx, ax         ; CX = Number of bytes read
    mov si, offset buffer ; SI points to the start of the buffer

print_loop1:
    cmp cx, 0          ; Check if all bytes are printed
    je read_continue   ; If no more bytes, jump to continue reading

    mov dl, [si]       ; Load one byte from the buffer into DL
    mov ah, 2          ; DOS function 2 = Output a character to the screen (DL = character)
    int 21h            ; Display the character

    inc si             ; Move to the next byte in the buffer
    dec cx             ; Decrease the byte counter
    jmp print_loop1    ; Repeat the loop for the next byte

read_continue:
    pop ax             ; Restore the number of bytes read from the stack
    jmp read_file      ; Continue reading from the file

close_file:
    mov ah, 3Eh        ; DOS function 3Eh = Close file
    int 21h            ; Call DOS interrupt to close the file

    ret                ; Return from procedure
    call reset         ; Reset registers
    call newline       ; Move to a new line
endp record_view   
call newline           ; Additional new lines for formatting
call newline
call newline

;----------------------------------------------------------------------------
; ============/////////////////// searchdept//////////////////// ============  
;----------------------------------------------------------------------------

searchdept proc
    ; (1) Display "Enter Dept to search"
    lea dx, enter_dept_search
    mov ah, 9           ; DOS function 9 to display a string
    int 21h

    ; (2) Read department input to search
    call read_dept_input

    ; (3) Open file "data.csv" in read-only mode
    lea dx, filename
    mov ah, 3Dh         ; DOS function 3Dh = Open file
    mov al, 0           ; AL=0 => Read-only mode
    int 21h
    mov bx, ax          ; BX = file handle

    ; (A) Set printed_count = 0
    mov byte ptr [printed_count], 0

SEARCH_LOOP:
    ; (4) Read one line from the file
    call read_line
    cmp al, 0
    je DONE_SEARCH       ; AL=0 => EOF => stop

    ; (5) Search for "deptsearch" in the CSV buffer
    push bx
    lea si, csv_buffer   ; SI points to the CSV buffer
    lea di, deptsearch   ; DI points to the search input
    call find_substring  ; ZF=1 if found
    pop bx

    jnz NOT_FOUND        ; ZF=0 => Not found, jump to NOT_FOUND

    ; (If found, print the line)
    lea si, csv_buffer   ; SI points to the CSV buffer
    call print_line

    ; (B) Increment printed_count
    mov al, [printed_count] ; Load current count
    inc al                  ; Increment count
    mov [printed_count], al ; Save back
    cmp al, 10              ; Check if 10 lines have been printed
    je DONE_SEARCH          ; If 10, stop

NOT_FOUND:
    jmp SEARCH_LOOP         ; Continue searching

DONE_SEARCH:
    ; (6) Close the file
    mov ah, 3Eh             ; DOS function 3Eh = Close file
    int 21h

    ; (7) Display "Done searching!"
    mov ah, 9
    lea dx, msg_done        ; DX points to the "Done searching!" message
    int 21h
    ret
searchdept endp

; ============ read_dept_input ============
; Read department input from the keyboard
; Ends when Enter key is pressed
; Saves the input to "deptsearch" (terminated by null byte)
read_dept_input proc
    mov si, 0              ; SI = 0 (start index)
READ_DEPT_LOOP:
    mov ah, 1              ; DOS function 1 = Read one character (with echo)
    int 21h
    cmp al, 13             ; Check if Enter key (ASCII 13)
    je DONE_DEPT
    mov deptsearch[si], al ; Store character in deptsearch array
    inc si                 ; Move to next index
    jmp READ_DEPT_LOOP

DONE_DEPT:
    mov deptsearch[si], 0  ; Null-terminate the string
    ret
read_dept_input endp

; ============ read_line ============
; Reads one line from the file (file handle in BX)
; Stops at carriage return (0Dh), line feed (0Ah), or EOF
; AL = 1 => Successfully read a line
; AL = 0 => End of file (EOF)
read_line proc
    push ax
    push cx
    push dx
    push si

    ; Clear the csv_buffer
    mov si, offset csv_buffer
    mov cx, 256
    xor ax, ax
clr_loop:
    mov [si], al           ; Fill buffer with null bytes
    inc si
    loop clr_loop

    mov si, offset csv_buffer ; SI points to the start of csv_buffer

READ_BYTE_LOOP:
    mov ah, 3Fh            ; DOS function 3Fh = Read file
    mov cx, 1              ; Read one byte at a time
    lea dx, buffer
    int 21h
    cmp ax, 0
    je NO_MORE_DATA        ; AX=0 => EOF, no more data

    mov al, [buffer]       ; Load the byte read
    cmp al, 0Dh            ; Check for carriage return
    je END_OF_LINE
    cmp al, 0Ah            ; Check for line feed
    je END_OF_LINE

    mov [si], al           ; Store the byte in csv_buffer
    inc si
    jmp READ_BYTE_LOOP

END_OF_LINE:
    mov byte ptr [si], 0   ; Null-terminate the string
    mov al, 1
    jmp END_READ

NO_MORE_DATA:
    mov byte ptr [si], 0   ; Null-terminate the string
    mov al, 0              ; AL=0 to indicate EOF

END_READ:
    pop si
    pop dx
    pop cx
    pop ax
    ret
read_line endp

; ============ print_line ============
; Prints a string from DS:SI until a null byte is found
; Ends with a new line (CR LF)
print_line proc
    push ax
    push dx

PRINT_LOOP:
    mov al, [si]           ; Load the current character
    cmp al, 0              ; Check for null byte (end of string)
    je PRINT_DONE
    mov dl, al             ; Move character to DL
    mov ah, 2              ; DOS function 2 = Display character
    int 21h
    inc si                 ; Move to the next character
    jmp PRINT_LOOP

PRINT_DONE:
    ; Print a new line (CR LF)
    mov ah, 2
    mov dl, 0Dh            ; Carriage return
    int 21h
    mov dl, 0Ah            ; Line feed
    int 21h

    pop dx
    pop ax
    ret
print_line endp

; ============ find_substring ============
; DS:SI => Source string (csv_buffer)
; DS:DI => Substring to search (deptsearch)
; ZF=1 => Substring found, ZF=0 => Not found
find_substring proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si             ; Save start of source string in BX
    mov dx, di             ; Save start of substring in DX

OUTER_LOOP:
    mov si, bx
    mov al, [si]
    cmp al, 0
    je NOT_FOUND2          ; End of source string => Not found

    ; Compare substring at DI with source string at SI
    push bx
    push dx
    push si

    mov di, dx
COMPARE_CHAR:
    mov al, [si]
    mov ah, [di]
    cmp ah, 0
    je FOUND_IT            ; End of substring => Found match

    cmp al, 0
    je RESTORE_NOT_FOUND

    cmp al, ah
    jne RESTORE_NOT_FOUND

    inc si
    inc di
    jmp COMPARE_CHAR

FOUND_IT:
    ; ZF=1 (Substring found)
    pop si
    pop dx
    pop bx
    mov ax, 0
    cmp ax, 0              ; Force ZF=1
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

RESTORE_NOT_FOUND:
    pop si
    pop dx
    pop bx
    inc bx                 ; Move to the next character in source string
    jmp OUTER_LOOP

NOT_FOUND2:
    ; ZF=0 (Substring not found)
    mov ax, 1
    cmp ax, 0
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
find_substring endp


; ============ read_id_input ============ 
; Reads the ID input from the keyboard, terminates when Enter is pressed
; Saves the input to the id_search_var array (ends with a byte 0)
read_id_input proc
    mov si, 0
READ_ID_LOOP:
    mov ah, 1       ; DOS function 1 => read 1 character (with echo)
    int 21h
    cmp al, 13      ; Enter?
    je DONE_ID
    mov id_search_var[si], al
    inc si
    jmp READ_ID_LOOP

DONE_ID:
    mov id_search_var[si], 0 ; terminate the string
    ret
read_id_input endp
                                                                   
;-----------------------------------------------------------------                                                      
; ============ ///////////////searchid /////////////============== 
;----------------------------------------------------------------- 

; Searches for a given ID in a file
searchid proc
    ; (1) Display "Enter ID to search"
    lea dx, enter_id_search
    mov ah, 9
    int 21h

    ; (2) Read the ID
    call read_id_input

    ; (3) Open the file data.csv (for reading only)
    lea dx, filename
    mov ah, 3Dh
    mov al, 0
    int 21h
    jc CANNOT_OPEN_FILE_ID
    mov bx, ax  ; BX = file handle

SEARCH_LOOP_ID:
    ; (4) Read 1 line
    call read_line_id
    cmp al, 0
    je DONE_SEARCH_ID   ; AL=0 => EOF => end

    ; (5) Search for id_search_var in csv_buffer
    push bx
    lea si, csv_buffer
    lea di, id_search_var
    call find_substring_id  ; ZF=1 => found
    pop bx

    jnz NOT_FOUND_ID        ; ZF=0 => jump to NOT_FOUND_ID

    ; => ZF=1 => print the line
    lea si, csv_buffer
    call print_line_id

    ; *** After printing, STOP ***
    jmp DONE_SEARCH_ID

NOT_FOUND_ID:
    jmp SEARCH_LOOP_ID

DONE_SEARCH_ID:
    ; (6) Close the file
    mov ah, 3Eh
    int 21h

    ; (7) Print "Done ID search!"
    mov ah, 9
    lea dx, msg_done_id
    int 21h
    ret

CANNOT_OPEN_FILE_ID:
    mov ah, 9
    lea dx, msg_no_file_id
    int 21h
    ret
searchid endp


; ============ read_line_id ============ 
; Reads a single line from the file handle BX
; Stops when encountering 0Dh (\r), 0Ah (\n), or EOF
; AL = 1 => successfully read 1 line
; AL = 0 => EOF
read_line_id proc
    push ax
    push cx
    push dx
    push si

    ; Clear csv_buffer
    mov si, offset csv_buffer
    mov cx, 256
    xor ax, ax
clr_loop_id:
    mov [si], al
    inc si
    loop clr_loop_id

    mov si, offset csv_buffer

READ_BYTE_LOOP_ID:
    mov ah, 3Fh      ; DOS read file
    mov cx, 1
    lea dx, buffer
    int 21h
    cmp ax, 0
    je NO_MORE_DATA_ID

    mov al, [buffer]
    cmp al, 0Dh
    je END_OF_LINE_ID
    cmp al, 0Ah
    je END_OF_LINE_ID

    mov [si], al
    inc si
    jmp READ_BYTE_LOOP_ID

END_OF_LINE_ID:
    mov byte ptr [si], 0
    mov al, 1
    jmp END_READ_ID

NO_MORE_DATA_ID:
    mov byte ptr [si], 0
    mov al, 0

END_READ_ID:
    pop si
    pop dx
    pop cx
    pop ax
    ret
read_line_id endp


; ============ print_line_id ============ 
; Prints the string from DS:SI until byte 0 is encountered
; Then moves to the next line (CR LF)
print_line_id proc
    push ax
    push dx

PRINT_LOOP_ID:
    mov al, [si]
    cmp al, 0
    je PRINT_DONE_ID
    mov dl, al
    mov ah, 2
    int 21h
    inc si
    jmp PRINT_LOOP_ID

PRINT_DONE_ID:
    ; Move to the next line (CRLF)
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    pop dx
    pop ax
    ret
print_line_id endp


; ============ find_substring_id ============ 
; Searches for the string at DS:SI (csv_buffer) in the string at DS:DI (id_search_var)
; Returns ZF=1 if found, ZF=0 if not
find_substring_id proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si
    mov dx, di

OUTER_LOOP_ID:
    mov si, bx
    mov al, [si]
    cmp al, 0
    je NOT_FOUND_ID2

    push bx
    push dx
    push si

    mov di, dx
COMPARE_CHAR_ID:
    mov al, [si]
    mov ah, [di]
    cmp ah, 0
    je FOUND_IT_ID

    cmp al, 0
    je RESTORE_NOT_FOUND_ID

    cmp al, ah
    jne RESTORE_NOT_FOUND_ID

    inc si
    inc di
    jmp COMPARE_CHAR_ID

FOUND_IT_ID:
    pop si
    pop dx
    pop bx
    mov ax,0
    cmp ax,0   ; => ZF=1
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

RESTORE_NOT_FOUND_ID:
    pop si
    pop dx
    pop bx
    inc bx
    jmp OUTER_LOOP_ID

NOT_FOUND_ID2:
    mov ax,1
    cmp ax,0   ; => ZF=0
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
find_substring_id endp

;-----------------------------------------------------------------
;/////////////////////////  search name //////////////////////////
;-----------------------------------------------------------------
                
; ============ read_name_input ============

read_name_input proc
    mov si, 0                      ; Initialize index to 0 (start of the name buffer)
READ_NAME_LOOP:
    mov ah, 1                      ; DOS function 1 => read 1 character (with echo)
    int 21h
    cmp al, 13                     ; Check if Enter key (ASCII 13) is pressed
    je DONE_NAME                   ; If Enter is pressed, exit the loop
    mov name_search_var[si], al    ; Store the input character in the name_search_var buffer
    inc si                         ; Increment the index for the next character
    jmp READ_NAME_LOOP             ; Loop back to read the next character

DONE_NAME:
    mov name_search_var[si], 0     ; Null-terminate the string (end of input)
    ret
read_name_input endp

; ============ searchname ============

searchname proc
    ; (1) Display "Enter Name to search (partial)"
    lea dx, enter_name_search2
    mov ah, 9
    int 21h

    ; (2) Read the input name => name_search_var
    call read_name_input

    ; (3) Open file "data.csv" for reading
    lea dx, filename
    mov ah, 3Dh
    mov al, 0
    int 21h
    jc CANNOT_OPEN_FILE_NAME       ; If carry flag is set, file opening failed
    mov bx, ax                     ; Store file handle in BX

SEARCH_LOOP_NAME:
    ; (4) Read one line from the file
    call read_line_name
    cmp al, 0                      ; Check if EOF (End of File) is reached
    je DONE_SEARCH_NAME            ; If EOF, end the search

    ; (5) Partial match: Check if name_search_var is in csv_buffer
    push bx
    lea si, csv_buffer
    lea di, name_search_var
    call find_substring_name       ; Call the substring search function (ZF=1 means found)
    pop bx

    jnz NOT_FOUND_NAME             ; If not found (ZF=0), continue the loop

    ; If found, print the matching line
    lea si, csv_buffer
    call print_line_name

    ; Finish search after printing
    jmp DONE_SEARCH_NAME

NOT_FOUND_NAME:
    jmp SEARCH_LOOP_NAME           ; Continue searching for the next line

DONE_SEARCH_NAME:
    ; (6) Close the file
    mov ah, 3Eh
    int 21h

    ; (7) Display "Done Name search!"
    mov ah, 9
    lea dx, msg_done_name
    int 21h
    ret

CANNOT_OPEN_FILE_NAME:
    ; Display error message if file cannot be opened
    mov ah, 9
    lea dx, msg_no_file_name
    int 21h
    ret
searchname endp

; ============ read_line_name ============

read_line_name proc
    push ax
    push cx
    push dx
    push si

    ; Clear the csv_buffer
    mov si, offset csv_buffer
    mov cx, 256
    xor ax, ax
clear_loop_name:
    mov [si], al
    inc si
    loop clear_loop_name

    mov si, offset csv_buffer

READ_BYTE_LOOP_NAME:
    mov ah, 3Fh       ; DOS function 3Fh => Read from file
    mov cx, 1
    lea dx, buffer
    int 21h
    cmp ax, 0
    je NO_MORE_DATA_NAME

    mov al, [buffer]
    cmp al, 0Dh      ; Check if carriage return (end of line)
    je END_OF_LINE_NAME
    cmp al, 0Ah      ; Check if newline (end of line)
    je END_OF_LINE_NAME

    mov [si], al
    inc si
    jmp READ_BYTE_LOOP_NAME

END_OF_LINE_NAME:
    mov byte ptr [si], 0  ; Null-terminate the line
    mov al, 1
    jmp END_READ_NAME

NO_MORE_DATA_NAME:
    mov byte ptr [si], 0  ; Null-terminate in case of no more data
    mov al, 0

END_READ_NAME:
    pop si
    pop dx
    pop cx
    pop ax
    ret
read_line_name endp

; ============ print_line_name ============

print_line_name proc
    push ax
    push dx

PRINT_LOOP_NAME:
    mov al, [si]
    cmp al, 0           ; Check if the end of string is reached
    je PRINT_DONE_NAME
    mov dl, al
    mov ah, 2
    int 21h
    inc si
    jmp PRINT_LOOP_NAME

PRINT_DONE_NAME:
    ; Print newline (CRLF)
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    pop dx
    pop ax
    ret
print_line_name endp

; ============ find_substring_name ============

find_substring_name proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si
    mov dx, di

OUTER_LOOP_NAME:
    mov si, bx
    mov al, [si]
    cmp al, 0
    je NOT_FOUND_NAME2

    push bx
    push dx
    push si

    mov di, dx
COMPARE_CHAR_NAME:
    mov al, [si]
    mov ah, [di]
    cmp ah, 0
    je FOUND_IT_NAME

    cmp al, 0
    je RESTORE_NOT_FOUND_NAME

    cmp al, ah
    jne RESTORE_NOT_FOUND_NAME

    inc si
    inc di
    jmp COMPARE_CHAR_NAME

FOUND_IT_NAME:
    pop si
    pop dx
    pop bx
    mov ax, 0        ; ZF=1 if found
    cmp ax, 0        ; Check for ZF
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

RESTORE_NOT_FOUND_NAME:
    pop si
    pop dx
    pop bx
    inc bx
    jmp OUTER_LOOP_NAME

NOT_FOUND_NAME2:
    mov ax, 1        ; ZF=0 if not found
    cmp ax, 0
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
find_substring_name endp


           ;---------------------------------------------------------------------     
           ;///////////////////////////// search cgpa ///////////////////////////
           ;---------------------------------------------------------------------
                
read_cgpa_input proc
    mov si, 0                      ; Initialize index (si) to 0
READ_CGPA_LOOP:
    mov ah, 1                      ; DOS function 1 => read 1 character (with echo)
    int 21h
    cmp al, 13                     ; Compare with Enter key (13 = Enter)
    je DONE_CGPA                   ; If Enter, finish input
    mov cgpa_search_var[si], al    ; Store the character in cgpa_search_var
    inc si                         ; Increment index
    jmp READ_CGPA_LOOP             ; Continue the loop

DONE_CGPA:
    mov cgpa_search_var[si], 0     ; Null terminate the string
    ret
read_cgpa_input endp

searchcgpa proc
    ; (1) Display message "Enter CGPA to search (partial)"
    lea dx, enter_cgpa_search2
    mov ah, 9
    int 21h

    ; (2) Read CGPA input into cgpa_search_var
    call read_cgpa_input

    ; (A) Initialize printed_count_cg to 0
    mov byte ptr [printed_count_cg], 0

    ; (3) Open file "data.csv" in read-only mode
    lea dx, filename
    mov ah, 3Dh
    mov al, 0
    int 21h
    jc CANNOT_OPEN_FILE_CG         ; If CF=1, file opening failed
    mov bx, ax                    ; BX = file handle

SEARCH_LOOP_CG:
    ; (4) Read 1 line from file
    call read_line_cg
    cmp al, 0                      ; Check for EOF (AL=0)
    je DONE_SEARCH_CG              ; If EOF, exit loop

    ; (5) Search for cgpa_search_var in csv_buffer
    push bx
    lea si, csv_buffer
    lea di, cgpa_search_var
    call find_substring_cg         ; ZF=1 means found
    pop bx

    jnz NOT_FOUND_CG               ; If ZF=0, continue to search

    ; => ZF=1 => print the line
    lea si, csv_buffer
    call print_line_cg

    ; Increment printed count:
    mov al, [printed_count_cg]
    inc al
    mov [printed_count_cg], al
    cmp al, 2                      ; Have we printed 2 lines yet?
    je DONE_SEARCH_CG              ; If 2, finish search

NOT_FOUND_CG:
    jmp SEARCH_LOOP_CG

DONE_SEARCH_CG:
    ; (6) Close the file
    mov ah, 3Eh
    int 21h

    ; (7) Display "Done CGPA search!"
    mov ah, 9
    lea dx, msg_done_cgpa
    int 21h
    ret

CANNOT_OPEN_FILE_CG:
    mov ah, 9
    lea dx, msg_no_file_cgpa
    int 21h
    ret
searchcgpa endp

read_line_cg proc
    push ax
    push cx
    push dx
    push si

    ; Clear csv_buffer
    mov si, offset csv_buffer
    mov cx, 256
    xor ax, ax
clear_loop_cg:
    mov [si], al
    inc si
    loop clear_loop_cg

    mov si, offset csv_buffer

READ_BYTE_LOOP_CG:
    mov ah, 3Fh                   ; DOS read function
    mov cx, 1                      ; Read 1 byte
    lea dx, buffer
    int 21h
    cmp ax, 0                      ; Check if end of file (EOF)
    je NO_MORE_DATA_CG             ; If EOF, exit

    mov al, [buffer]
    cmp al, 0Dh                    ; Check for carriage return (end of line)
    je END_OF_LINE_CG
    cmp al, 0Ah                    ; Check for line feed (end of line)
    je END_OF_LINE_CG

    mov [si], al
    inc si
    jmp READ_BYTE_LOOP_CG

END_OF_LINE_CG:
    mov byte ptr [si], 0           ; Null terminate the string
    mov al, 1
    jmp END_READ_CG

NO_MORE_DATA_CG:
    mov byte ptr [si], 0           ; Null terminate the string
    mov al, 0                      ; Return 0 to indicate no more data

END_READ_CG:
    pop si
    pop dx
    pop cx
    pop ax
    ret
read_line_cg endp


print_line_cg proc
    push ax
    push dx

PRINT_LOOP_CG:
    mov al, [si]
    cmp al, 0                      ; Check for end of string
    je PRINT_DONE_CG
    mov dl, al
    mov ah, 2                      ; DOS function to print character
    int 21h
    inc si
    jmp PRINT_LOOP_CG

PRINT_DONE_CG:
    ; Print newline (CRLF)
    mov ah, 2
    mov dl, 0Dh                    ; Carriage return
    int 21h
    mov dl, 0Ah                    ; Line feed
    int 21h

    pop dx
    pop ax
    ret
print_line_cg endp


find_substring_cg proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, si                     ; Set bx to point to si
    mov dx, di                     ; Set dx to point to di

OUTER_LOOP_CG:
    mov si, bx
    mov al, [si]
    cmp al, 0                      ; If al is 0, end of string
    je NOT_FOUND_CG2

    push bx
    push dx
    push si

    mov di, dx                     ; Set di to point to dx
COMPARE_CHAR_CG:
    mov al, [si]
    mov ah, [di]
    cmp ah, 0                      ; If end of substring
    je FOUND_IT_CG

    cmp al, 0                      ; If end of string
    je RESTORE_NOT_FOUND_CG

    cmp al, ah                     ; Compare characters
    jne RESTORE_NOT_FOUND_CG

    inc si                         ; Move to next character
    inc di
    jmp COMPARE_CHAR_CG

FOUND_IT_CG:
    pop si
    pop dx
    pop bx
    mov ax, 0                      ; Clear ax
    cmp ax, 0                      ; ZF=1 means found
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

RESTORE_NOT_FOUND_CG:
    pop si
    pop dx
    pop bx
    inc bx                         ; Increment bx to check the next substring
    jmp OUTER_LOOP_CG

NOT_FOUND_CG2:
    mov ax, 1                      ; Return 1 if not found
    cmp ax, 0                      ; ZF=0 means not found
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
find_substring_cg endp


                                 
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  
DEFINE_PTHIS
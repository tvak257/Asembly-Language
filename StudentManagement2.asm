           
        include 'emu8086.inc'
        
       
        
        
       
         .model small
         
         .stack 100h
        
        .data 
        
          thanks db "Thank you for using student database $" 
        welcome db "============= Welcome to Student Datbase ================$" 
        inp_w db "Press 1 to enter student info$"
        view_all db "Press 2 to view all records$"
        search_by_dept db "Press 3 to search by Department$"  
         search_by_id db "Press 4 to search by ID$" 
          search_by_name db "Press 5 to search by Name$" 
           search_by_cgpa db "Press 6 to search by CGPA$" 
           
           
           
           enter_dept_search db "Enter Department to search$"
            enter_id_search  db "Enter Id to search$"
             enter_name_search   db "Enter Name to search$"
              enter_cgpa_search   db  "Enter CGPA to search$"
           
           
           
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
        
        idsearch db 5 dup('$')
        namesearch db 5 dup('$')
        deptsearch db 5 dup('$')
        cgpasearch db 5 dup('$') 
      
       a db 0 ; counter for dept,cgpa,name
       
       b db 0 ; counter for id only 
       
       c db 0
       d db 0
        
       i db 0  
       index dw 0
        
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
         
          initial: 
     
         call starting
         call input
        
         cmp al,037h
         je end_print  
         call newline
         jmp initial
         
          
        
         
         end_print:
         call reset 
         call newline 
         call newline 
          call reset
          lea dx,thanks    ;msg-thank you$
         mov ah,9
         int 21h
         call reset
          
          mov ah,4ch 
         int 21h               
          endp main 
          
         ;//////////////////// procedures//////////////////////////////////////// 
          

         proc starting    ; proc for start screen input and view all
         lea dx,inp_w     ;msg-Press 1 to enter student info$
         mov ah,9
         int 21h
         call newline
         call reset
       
         lea dx,view_all    ;msg-Press 2 to view all records$
         mov ah,9
         int 21h
         call newline
         call reset    
                   
         lea dx,search_by_dept    ;msg-Press 3 to search  by dept$
         mov ah,9
         int 21h
         call newline
         call reset  
         
         lea dx,search_by_id    ;msg-Press 4 to search  by id$
         mov ah,9
         int 21h
         call newline
         call reset  
         
         
          lea dx,search_by_name    ;msg-Press 5 to search  by name$
         mov ah,9
         int 21h
         call newline
         call reset  
           
           
           lea dx,search_by_cgpa    ;msg-Press 6 to search  by cgpa$
         mov ah,9
         int 21h
         call newline
         call reset  
         
         
         
          lea dx,exit    ;msg-Press 7 to exit$
         mov ah,9
         int 21h
         call newline
         call reset
         
         
         ret
         endp starting    
         
          
          
          
          proc newline    ;procedure for next line
          mov ah,2
          mov dl,13
          int 21h
         
          mov ah,2
          mov dl,10
          int 21h
          ret
          endp newline   
          
          
          
          
           proc reset      ;procedure to reset all register values
            mov ax,0
            mov bx,0
            mov cx,0
            mov dx,0
            ret
           endp reset 
           
           
           
        proc input            ; starting menu input
        call newline
        call reset
        mov ah,1
        int 21h
        cmp al,031h 
        je student_entry        ; press 1 to jump to student entry
        cmp al,032h
        je record_view          ;press 2 to jump to view records
        
        cmp al,033h
        je searchdept                 ;press 3 to jump to deptsearch
         
          cmp al,034h
        je searchid
        
         cmp al,035h
        je searchname
        
         cmp al,036h
        je searchcgpa
         
         
         
        ret 
        endp input
         
       
       
       proc student_entry  ;================== entry into student database =======================
        call newline
         call reset
        mov si,0
          mov bl,0 
          mov bh,0
          
        
        
        id_input:        ;input for id 
         mov si,0
          mov bl,0
          mov bh,0   
          mov ax,0
          
          call counter_check
          mov bl,a
          mov si,bx        ; index number for id
          call reset
          
           
        lea dx,ent_id     ;msg-enter student id $
         mov ah,9
         int 21h
         call newline
         call reset  
         
        jmp taking_id_input
        
        
        
        taking_id_input:
         mov ah,1
          int 21h
          cmp al,13
          je end_id_input
          mov id[si],al
           inc si
           jmp taking_id_input
         
         
         
         
         
        end_id_input: 
        call newline
          mov si,0
          mov bl,0
          mov bh,0   
          mov ax,0
          
          call counter_check
          mov bl,a
          mov si,bx           ;index number for name
          call reset 
          
           lea dx,ent_name     ;msg-enter student name $
         mov ah,9
         int 21h
         call newline
         call reset
          jmp name_input
      
    

           name_input:      ; input for names  
          
           mov ah,1
          int 21h
          cmp al,13
          je end_name_input
          mov names[si],al
           inc si
           jmp name_input 
           
           
           
           end_name_input:     
            call newline  
          mov si,0
          mov bl,0
          mov bh,0 
          mov ax,0 
           
             call counter_check
           mov bl,a
          mov si,bx                      ;index numner for dept
          call reset 
          
          lea dx,ent_dept     ;msg-enter student dept $
         mov ah,9
         int 21h
         call newline
         call reset
          jmp  dept_input
          
          
          dept_input:   ; input for dept   
          
          mov ah,1
          int 21h
          cmp al,13
          je end_dept_input
          mov dept[si],al
           inc si
           jmp dept_input
        
          
          
          
         end_dept_input: 
         call newline  
          mov si,0
          mov bl,0
          mov bh,0 
          mov ax,0 
           
             call counter_check
           mov bl,a
          mov si,bx           ;index number for cgpa
          call reset 
           
          lea dx,ent_cgpa     ;msg-enter student cgpa$
         mov ah,9
         int 21h
         call newline
         call reset
          jmp  cgpa_input
          
          
           cgpa_input:   ; input for cgpa
          mov ah,1
          int 21h
          cmp al,13
          je end_cgpa_input
          mov cgpa[si],al
           inc si
           jmp cgpa_input
          
          
          end_cgpa_input:
          call newline  
          mov si,0
          mov bl,0
          mov bh,0 
          mov ax,0 
        
          inc a   ; counter increment for dept,cgpa,name
          inc b   ;  counter increment for id only
          
           ret 
          endp student_entry
       
       
       
       
       
       
       
       
       
       
          
       proc counter_check
       mov ax,0
       mov bx,0
       mov bl,5
       mov al,b
       mul bl
       mov a,al   
    
       ret 
       endp counter_check
       
       
       
 
       
        
        
       proc record_view ; view all student records
        call reset
        call newline
        
         call print_dept_string
         
         call reset
        call newline 
        call reset
       
        call print_names_string
        
     
          call reset
          call newline
         call reset
         
        call print_id_string
        
        

       
        call reset 
        call newline  
        call reset      
        
         call print_cgpa_string
        
        
 
        call reset
        call newline 
         call reset
        
       ret 
       endp record_view
       
       
                 proc print_id_string   ; prints the whole id string
           
           mov bl,0
           mov si,0
            
            printid:
           cmp bl,25
           je end_printid
           mov cl,id[si]
          cmp cl,024h
          je changeid
  
            mov dl, cl 
            mov ah,2
            int 21h   
            inc bl
            inc si
       
            jmp printid
         
      
          changeid:
           mov dl,020h 
           mov ah,2
           int 21h 
           inc bl
           inc si
           jmp printid
        
       
          end_printid:
           

           ret 
           endp print_id_string
                                     
         
         
         
          
           proc print_names_string   ; prints the whole names string
           
           mov bl,0
           mov si,0
            
            print1:
           cmp bl,25
           je end_print1
           mov cl,names[si]
          cmp cl,024h
          je change1
  
            mov dl, cl 
            mov ah,2
            int 21h   
            inc bl
            inc si
       
            jmp print1
         
      
          change1:
           mov dl,020h 
           mov ah,2
           int 21h 
           inc bl
           inc si
           jmp print1
        
       
          end_print1:
           

           ret 
           endp print_names_string
                                            
                                            
                                            
                                            
              proc print_dept_string   ; prints the whole dept string
           
           mov bl,0
           mov si,0
            
            print2:
           cmp bl,25
           je end_print2
           mov cl,dept[si]
          cmp cl,024h
          je change2
  
            mov dl, cl 
            mov ah,2
            int 21h   
            inc bl
            inc si
       
            jmp print2
         
      
          change2:
           mov dl,020h 
           mov ah,2
           int 21h 
           inc bl
           inc si
           jmp print2
        
       
           end_print2:
           

           ret 
           endp print_dept_string
                                         
          
                                         
              proc print_cgpa_string   ; prints the whole cgpa string
           
           mov bl,0
           mov si,0
            
            print3:
           cmp bl,25
           je end_print3
           mov cl,cgpa[si]
          cmp cl,024h
          je change3
  
            mov dl, cl 
            mov ah,2
            int 21h   
            inc bl
            inc si
       
            jmp print3
         
      
          change3:
           mov dl,020h 
           mov ah,2
           int 21h 
           inc bl
           inc si
           jmp print3
        
       
           end_print3:
           

           ret 
              endp print_cgpa_string
              
            
            
              ;//////////// dept search/////////////// ///////////////////////
            
            
               proc  searchdept
                
       
                 mov si,0 
                 mov di,0 
                 
                 call newline 
                 call newline
                 
                 lea dx,enter_dept_search
                 mov ah,9
                 int 21h
                 
                 call newline
                 
                 call reset

  
    mov bl,13
     mov c,0 
                
               
               
                


   
   myline1:
  
  
        ; mov al,0
  mov ah,1
  int 21h 
      cmp al,bl
  je myline2
  mov deptsearch[si],al
  
  inc si
  
    jmp myline1
    
    myline2:
     call newline ;/////
     call reset  ; ////
    mov si,0
    mov di,0 
    
    
    
    
    
    
    
    mov c,0  
    mov d,0
    
    
    
    
    s7: 
    
     cmp c,5
     je endo
    
      cmp d,5
         je s5
          
         
         mov bh, deptsearch[si]
         
         cmp dept[di],bh 
         
          jne s4
         je jk
         
         jk:
         inc d
         inc si
         inc di
         jmp s7  
         s5: 
         mov al,c
         mov cl,d
         mul cl
         mov index,ax
          mov bl,0
          
          s0:
         jmp goprint
         
         s4:
    
    inc c
     mov ch,5
     cmp ch,c
     je endo
   
    mov si,0 
    
      mov ah,0
   mov al,5
    mov cl,c
    mul cl
    mov di,ax 
    mov d,0
      jmp s7
      
     
    
         
         
    goprint:
    
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
         
         sf:
         
        
         
         cmp bl,5
         je dd
         mov ch,dept[di]
         cmp ch,'$'
         je dd
         inc bl
         
         mov dh,0 
         
         mov dl,dept[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sf
         
            dd:
            
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
        
           s9:
         cmp bl,5
         je cc
         mov ch,names[di]
         cmp ch,'$'
         je cc
         inc bl
         
         mov dh,0 
         
         mov dl,names[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s9
         
         
         cc:
         
           mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
         
             s11:
             
                cmp bl,5
         je aa
         mov ch,id[di]
         cmp ch,'$'
         je aa
         inc bl
         
         mov dh,0 
         
         mov dl,id[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s11
         
         aa:
         
          mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
            
            sd:
          cmp bl,5
         je go
         mov ch,cgpa[di]
         cmp ch,'$'
         je end_of_block
         inc bl
         
         mov dh,0 
         
         mov dl,cgpa[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sd   
         
         
         
         end_of_block:
         inc c
         mov d,0
         mov si,0
         mov di,0
         call reset
         mov al,c
         mov cl,5
         mul cl
         mov di,ax 
         call newline  ;//////
         call reset
         jmp s7
         
         
         go:
           call reset
           call newline ;///
           call newline  ;/////
           call reset    ;/////
           mov si,0
           mov di,0
           mov c,0
           mov d,0
           mov index,0
            
         
           endo:
         
         
              call newline  ;////
              call reset   ;////
         
      
         
  
              
                ret
                endp searchdept  
                
                
                
       ;      /////////////////// id search//////////////////////////   
             
             
             
             
                proc searchid
                
       
                 mov si,0 
                 mov di,0 
                 
               call newline 
                 call newline
                 
                 lea dx,enter_id_search
                 mov ah,9
                 int 21h
                 
                 call newline
                 
                 call reset

  
    mov bl,13
     mov c,0 
                
               
               
                


   
   myline14:
  
  
        ; mov al,0
  mov ah,1
  int 21h 
      cmp al,bl
  je myline24
  mov idsearch[si],al
  
  inc si
  
    jmp myline14
    
    myline24:
     call newline ;/////
     call reset  ; ////
    mov si,0
    mov di,0 
    
    
    
    
    
    
    
    mov c,0  
    mov d,0
    
    
    
    
    s74: 
    
     cmp c,5
     je endo4
    
      cmp d,5
         je s54
          
         
         mov bh, idsearch[si]
         
         cmp id[di],bh 
         
          jne s44
         je jk4
         
         jk4:
         inc d
         inc si
         inc di
         jmp s74  
         s54: 
         mov al,c
         mov cl,d
         mul cl
         mov index,ax
          mov bl,0
          
          s04:
         jmp goprint4
         
         s44:
    
    inc c
     mov ch,5
     cmp ch,c
     je endo4
   
    mov si,0 
    
      mov ah,0
   mov al,5
    mov cl,c
    mul cl
    mov di,ax 
    mov d,0
      jmp s74
      
     
    
         
         
    goprint4:
    
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
         
         sf4:
         
        
         
         cmp bl,5
         je dd4
         mov ch,dept[di]
         cmp ch,'$'
         je dd4
         inc bl
         
         mov dh,0 
         
         mov dl,dept[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sf4
         
            dd4:
            
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
        
           s94:
         cmp bl,5
         je cc4
         mov ch,names[di]
         cmp ch,'$'
         je cc4
         inc bl
         
         mov dh,0 
         
         mov dl,names[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s94
         
         
         cc4:
         
           mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
         
             s114:
             
                cmp bl,5
         je aa4
         mov ch,id[di]
         cmp ch,'$'
         je aa4
         inc bl
         
         mov dh,0 
         
         mov dl,id[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s114
         
         aa4:
         
          mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
            
            sd4:
          cmp bl,5
         je go4
         mov ch,cgpa[di]
         cmp ch,'$'
         je end_of_block4
         inc bl
         
         mov dh,0 
         
         mov dl,cgpa[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sd4   
         
         
         
         end_of_block4:
         inc c
         mov d,0
         mov si,0
         mov di,0
         call reset
         mov al,c
         mov cl,5
         mul cl
         mov di,ax 
         call newline  ;//////
         call reset
         jmp s74
         
         
         go4:
           call reset
           call newline ;///
           call newline  ;/////
           call reset    ;/////
           mov si,0
           mov di,0
           mov c,0
           mov d,0
           mov index,0
            
         
           endo4:
         
         
              call newline  ;////
              call reset   ;////
         
      
         
  
              
                ret
                endp searchid  
              
          
          
                ;/////////////////////////  search name ///////////////////////////
                
                
                
                   proc searchname
                
       
                 mov si,0 
                 mov di,0 
                 
                 call newline 
                 call newline
                 
                 lea dx,enter_name_search
                 mov ah,9
                 int 21h
                 
                 call newline
                 
                 call reset
  
    mov bl,13
     mov c,0 
                
               
               
                


   
   myline15:
  
  
        ; mov al,0
  mov ah,1
  int 21h 
      cmp al,bl
  je myline25
  mov namesearch[si],al
  
  inc si
  
    jmp myline15
    
    myline25:
     call newline ;/////
     call reset  ; ////
    mov si,0
    mov di,0 
    
    
    
    
    
    
    
    mov c,0  
    mov d,0
    
    
    
    
    s75: 
    
     cmp c,5
     je endo5
    
      cmp d,5
         je s55
          
         
         mov bh, namesearch[si]
         
         cmp names[di],bh 
         
          jne s45
         je jk5
         
         jk5:
         inc d
         inc si
         inc di
         jmp s75  
         s55: 
         mov al,c
         mov cl,d
         mul cl
         mov index,ax
          mov bl,0
          
          s05:
         jmp goprint5
         
         s45:
    
    inc c
     mov ch,5
     cmp ch,c
     je endo5
   
    mov si,0 
    
      mov ah,0
   mov al,5
    mov cl,c
    mul cl
    mov di,ax 
    mov d,0
      jmp s75
      
     
    
         
         
    goprint5:
    
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
         
         sf5:
         
        
         
         cmp bl,5
         je dd5
         mov ch,dept[di]
         cmp ch,'$'
         je dd5
         inc bl
         
         mov dh,0 
         
         mov dl,dept[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sf5
         
            dd5:
            
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
        
           s95:
         cmp bl,5
         je cc5
         mov ch,names[di]
         cmp ch,'$'
         je cc5
         inc bl
         
         mov dh,0 
         
         mov dl,names[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s95
         
         
         cc5:
         
           mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
         
             s115:
             
                cmp bl,5
         je aa5
         mov ch,id[di]
         cmp ch,'$'
         je aa5
         inc bl
         
         mov dh,0 
         
         mov dl,id[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s115
         
         aa5:
         
          mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
            
            sd5:
          cmp bl,5
         je go5
         mov ch,cgpa[di]
         cmp ch,'$'
         je end_of_block5
         inc bl
         
         mov dh,0 
         
         mov dl,cgpa[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sd5   
         
         
         
         end_of_block5:
         inc c
         mov d,0
         mov si,0
         mov di,0
         call reset
         mov al,c
         mov cl,5
         mul cl
         mov di,ax 
         call newline  ;//////
         call reset
         jmp s75
         
         
         go5:
           call reset
           call newline ;///
           call newline  ;/////
           call reset    ;/////
           mov si,0
           mov di,0
           mov c,0
           mov d,0
           mov index,0
            
         
           endo5:
         
         
              call newline  ;////
              call reset   ;////
         
      
         
  
              
                ret
                endp searchname  
              
                
                
           ;///////////////////////////// search cgpa ///////////////////////////     
                
                
                 proc searchcgpa
                
       
                 mov si,0 
                 mov di,0 
                 
                call newline 
                 call newline
                 
                 lea dx,enter_cgpa_search
                 mov ah,9
                 int 21h
                 
                 call newline
                 
                 call reset

  
    mov bl,13
     mov c,0 
                
               
               
                


   
   myline16:
  
  
        ; mov al,0
  mov ah,1
  int 21h 
      cmp al,bl
  je myline26
  mov cgpasearch[si],al
  
  inc si
  
    jmp myline16
    
    myline26:
     call newline ;/////
     call reset  ; ////
    mov si,0
    mov di,0 
    
    
    
    
    
    
    
    mov c,0  
    mov d,0
    
    
    
    
    s76: 
    
     cmp c,5
     je endo6
    
      cmp d,5
         je s56
          
         
         mov bh, cgpasearch[si]
         
         cmp cgpa[di],bh 
         
          jne s46
         je jk6
         
         jk6:
         inc d
         inc si
         inc di
         jmp s76  
         s56: 
         mov al,c
         mov cl,d
         mul cl
         mov index,ax
          mov bl,0
          
          s06:
         jmp goprint6
         
         s46:
    
    inc c
     mov ch,5
     cmp ch,c
     je endo6
   
    mov si,0 
    
      mov ah,0
   mov al,5
    mov cl,c
    mul cl
    mov di,ax 
    mov d,0
      jmp s76
      
     
    
         
         
    goprint6:
    
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
         
         sf6:
         
        
         
         cmp bl,5
         je dd6
         mov ch,dept[di]
         cmp ch,'$'
         je dd6
         inc bl
         
         mov dh,0 
         
         mov dl,dept[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sf6
         
            dd6:
            
         mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
        
           s96:
         cmp bl,5
         je cc6
         mov ch,names[di]
         cmp ch,'$'
         je cc6
         inc bl
         
         mov dh,0 
         
         mov dl,names[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s96
         
         
         cc6:
         
           mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
         
         
             s116:
             
                cmp bl,5
         je aa6
         mov ch,id[di]
         cmp ch,'$'
         je aa6
         inc bl
         
         mov dh,0 
         
         mov dl,id[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp s116
         
         aa6:
         
          mov di,index
         mov bl,0
          call newline 
         mov ah,0
         mov dx,0
            
            mov bl,0
            
            sd6:
          cmp bl,5
         je go6
         mov ch,cgpa[di]
         cmp ch,'$'
         je end_of_block6
         inc bl
         
         mov dh,0 
         
         mov dl,cgpa[di]  
         
         mov ah,2
         
         int 21h
         
         inc di
         jmp sd6   
         
         
         
         end_of_block6:
         inc c
         mov d,0
         mov si,0
         mov di,0
         call reset
         mov al,c
         mov cl,5
         mul cl
         mov di,ax 
         call newline  ;//////
         call reset
         jmp s76
         
         
         go6:
           call reset
           call newline ;///
           call newline  ;/////
           call reset    ;/////
           mov si,0
           mov di,0
           mov c,0
           mov d,0
           mov index,0
            
         
           endo6:
         
         
              call newline  ;////
              call reset   ;////
         
      
         
  
              
                ret
                endp searchcgpa  
                
                
                
                
            
                
                
                
          DEFINE_SCAN_NUM
         DEFINE_PRINT_STRING
         DEFINE_PRINT_NUM
         DEFINE_PRINT_NUM_UNS  
          DEFINE_PTHIS
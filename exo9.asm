cds segment para stack 'pile'
    db 256 dup (0)
cds ends

lds segment

;/*************************/        \_Data Zone_/ you are allowed to change the variables that doesn't contains "*"
msg db 'input a number: $' ; the first messege

mmsg db 'the maximum is: $'    ; the last messege

num db 3,4,2 dup(0)        ; the numbers will be stored here  *
    db '$'

max db 0                   ; the max will be stored here
    db 0

lign db 10,13,'$'          ; new lign code      *

ten db 10                  ; the value of 10    *

Nloops db 2                ; number of loops and the number of the numbers to insert and compaire

;/************************/

lds ends

lps segment
;/-------------------------/        \_Code Zone_/ WARNING: code so sensible "DO NOT TOUCH THIS ZONE" {read only}
phrase proc far
                  ; setting the system stuffs DO NOT MODIFY THIS

                         ASSUME CS :  LPS      
                         ASSUME DS : LDS 
                         ASSUME SS : CDS  
                         MOV AX , LDS 
                         MOV DS , AX
                         
                  ; /********************************************/    
      
      mov cl,Nloops                 ; for( cx=0 ; sx<=Nloops ; cx++)
      mov ch,0

      procedure:
            mov dx,offset msg       ; printting the message
            mov ah,9
            int 21h 

            mov dx, offset num      ;reading the number
            mov ah,10
            int 21h

            mov dl,offset lign      ; printting a new lign
            mov ah,9
            int 21h

            sub num[2],48           ; transforming the character to numeric form
            sub num[3],48


            mov al,num[2]           ; forming the number and putting it on 'al' ==> X*10 + y = Xy
            mov ah,0
            mul ten

            add al,num[3]           ; finishing the forming


            cmp al,max              ; if(al>max) set a new max
                  jg  newmax
                  jle oldmax        ; else do nothing

            newmax: mov max,al      ; setting new max 
            oldmax:                 ; do nothing

      loop procedure

            print:                  ;printing the max
            mov dx,offset mmsg      ; printting the message
            mov ah,9
            int 21h

            mov al,max              ; splitting the number 
            mov ah,0
            div ten

            mov max,ah              ; saving the result 
            mov [max+1],al

            add max,48              ; transforming the number in to ASCII form
            add [max+1],48

            mov dl,[max+1]          ; printing the max
            mov ah,2
            int 21h 

            mov dl,max              ; printing the max
            mov ah,2
            int 21h  

            theEND:                 ; the end of the program (no real need for this lign)

       MOV AH,4CH                   ; closing the programme                               
       INT 21H     

phrase endp
;/-------------------------/
lps ends
    end phrase         
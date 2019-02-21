.model small  
    
.stack 100h 
    
.data
    message1 db 0Dh, 0Ah, 'Input array: ', '$'
    message2 db 0Dh, 0Ah, 'Result: ', '$'
    message3 db 0Dh, 0Ah, 'Columns: ', '$'
    message4 db 0Dh, 0Ah, 'Rows: ', '$' 
    message5 db 0Dh, 0Ah, 'Incorrectly, Enter again. ', '$' 
    message6 db 0Dh, 0Ah, 'Overflow! Enter again. ', '$'
    endl     db 0Dh, 0Ah, '$'
    
    columns  db 0
    rows     db 0
    
    number   db 7, 0, 7 dup ('$')
                  
    array  dw 31 dup (0)
    result dw 6 dup (0)     
    flag    db  0    
    enter db 0Dh, 0Ah, '$'
    symbol db '$$'
        
.code
START:     
   mov   AX, @data
   mov   DS, AX
   
;;;;;;get number of column;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hc:

   mov   AH, 09h
   lea   DX, message3
   int   21h
           
   xor   AX, AX
   mov   AH, 01h          
   int   21h
   
   mov   AH, 0
   cmp   AL, '0'   
   jl    hcerror
   cmp   AL, '5'
   jg    hcerror
   and   AX, 0Fh
   mov   columns, AL
   jmp   hr
   
   
hcerror:                    ; error of input
   mov   AH, 09h
   lea   DX, message5
   int   21h
   jmp   hc 
   
;;;;;;get number of column;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     

;;;;;;get number of row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
hr:

   mov   AH, 09h
   lea   DX, message4
   int   21h
           
   xor   AX, AX
   mov   AH, 01h          
   int   21h
   
   mov   AH, 0
   cmp   AL, '0'   
   jl    hrerror
   cmp   AL, '6'
   jg    hrerror
   and   AX, 0Fh
   mov   rows, AL
   jmp   INPUT_ARRAY
   
   
hrerror:

   mov   AH, 09h              ; error of input
   lea   DX, message5
   int   21h
   jmp   hr 

;;;;;;get number of row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   


;;;;;;loop to input array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

INPUT_ARRAY:

   mov   AH, 09h
   lea   DX, message1
   int   21h
   
   xor   CX, CX
   mov   CL, rows
   mov   SI, 00h
loop1:
   push  CX
   
   mov   AH, 09h
   lea   DX, endl
   int   21h
   xor   CX, CX
   mov   CL, columns

loop2:
   
   call  get_number
   mov   array[SI], AX
   inc   SI
   inc   SI  
   
   mov   AH, 09h
   lea   DX, endl
   int   21h 
   
   loop  loop2
   pop   CX
   loop  loop1
   
;;;;;;loop for input array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   

;;;;;;loop for calculate the sum in a row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
SUM: 

   xor   CX, CX
   mov   CL, rows
   mov   SI, 00h
   xor   DI, DI
sum_loop1:
   push  CX 
   xor   CX, CX
   mov   CL, columns
   
sum_loop2:
   
   
   mov   AX, array[SI]
   add   result[DI], AX
   jo    sum_error
   inc   SI
   inc   SI  
   loop  sum_loop2   
after_sum_error:   
   pop   CX
   inc   DI
   inc   DI
   loop  sum_loop1
   jmp   OutputResult
   
sum_error:                  ;error of sum
   mov  result[DI], 00h
   jmp  after_sum_error 
   

;;;;;;loop for calculate the sum in a row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                                                                  
                                                                                                                                  
OutputResult: 

   mov  AH, 09h
   lea  DX, message2
   int 21h
   
   xor  CX, CX
   mov  CL, rows
   xor  SI, SI
output_loop:
   mov  AX, result[SI]
   call OutInt
   inc  SI
   inc  SI
   
   mov  AH, 02h
   mov  DL, ' '
   int 21h
   
   loop output_loop
   jmp exit
                                                                                                                                     
           
;;;;;;process to get the number;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           
get_number proc          ; void get_number (void)
                         ; {
   push  CX                    ; push CX, BX, SI, DI to stack
   push  BX 
   push  SI 
   push  DI
    
start_gc:
   
   ; get string with number
   mov   AH, 0Ah             ; 09h - function for get string     
   lea   DX, number          ; recipient's address
   int   21h                 ; interrupt for implementation
   
check:                             
   xor   CX, CX              ; CX = 0
   mov   CL, number[1]       ; CL = len of string with number
   cmp   CX, 0               ; did string enter?
   jle   geterror            ; sting did't enter Í> error of input
   mov   SI, 02h             ; SI = 2  (number[2] = firs sumbol of number)
   mov   AH, 00h             ; AH = 00h
   mov   AL, number[SI]      ; AL = number[2]
   cmp   AL, '-'             ; ? number[2] != '-' goto check_loop
   jne   check_loop
   cmp   CL, 2               ; ? sting == "-" goto geterror
   jl    geterror
   inc   SI                  ; SI = 3 (++CX)
   dec   CX                  ; --CX
        
check_loop:                  ; do{
   mov   AL, number[SI]      ;  AL = number[SI]
   cmp   AL, '0'             ;  {
   jl    geterror            ;   if( '0'<= AL && AL<='9')
   cmp   AL, '9'             ;      goto geterror
   jg    geterror            ;  }
   inc   SI                  ;  SI++
   loop check_loop           ; }while(CX!=0)
   jmp   converting          ; goto converting
   
geterror:                    ; number input error
   mov   AH, 09h
   lea   DX, message5
   int   21h
   jmp   start_gc            ; inmut nember again
         
         
converting:                  ; form string to int
   
   xor   CX, CX              ; CX = 0
   mov   CL, number[1]       ; CL = len of string with number
   mov   SI, CX              ; SI = CX
   inc   SI                  ; ++SI - set on last sumbol of sting
   xor   BX, BX              ; BX = 0 - stores the result                                
   mov   DX, 1               ; DX = 1 - discharge multiplier
   push  DX                  ; push DX to stack
   xor   AX, AX              ; AX = 0 - value of discharge                                
converting_loop:             ; do{
   mov   AL, number[SI]      ;      AL = number[SI]
   cmp   AL, '-'             ;      ? AL == '-' goto to_neg
   je    to_neg              ;
   and   AX, 0Fh             ;      AL -= 0Fh (48) - char to int 
   mul   DX                  ;      AX = AX*DX, DX=0
   pop   DX                  ;      pop DX from stack
   jo    overflow            ;      ? OF==1 goto overflow (overflow flag)
   add   BX, AX              ;      BX +=AX
   js    overflow            ;      ? SF==1 goto overflow (sign flag)
   jo    overflow            ;      ? OF==1 goto overflow (overflow flag)
   cmp   SI, 02h             ;      ? SI==02h goto end_get
   je    end_get             ;      02h - start of number
   xchg  AX, DX              ;      AX <-> DX
   mov   DX, 10              ;      DX = 10
   mul   DX                  ;      AX = AX*DX
   jo    overflow            ;      ? OF==1 goto overflow (overflow flag)
   xchg  DX, AX              ;      AX <-> DX
   push  DX                  ;      push DX to stack
   dec   SI                  ;      --SI
   loop  converting_loop     ; } while(CX==0)
   jmp   end_get             ; goto end_get
   
   
to_neg:                      ; convert to neg
   pop   DX                  ; pop form stack 
   neg   BX                  ; BX = -BX conversion to reverse code
   jo    overflow            ; ? OF==1 goto overflow (overflow flag)
   jmp   end_get             ; goto end_get


overflow:                    ; overflow
   mov   AH, 09h
   lea   DX, message6
   int   21h
   jmp   start_gc            ; enter again
                             
end_get:                   
   mov   AX, BX              ; result to AX
   pop   DI                  ; recovery DI, SI, BX. CX
   pop   SI                  ;
   pop   BX                  ;
   pop   CX                  ;
   ret                       ; return
get_number endp          ; }  
   

;;;;;;process to get the number;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    
 
 
OutInt proc
    push CX
    test AX, AX
    jns  oi1

    mov  CX, AX
    mov  AH, 02h
    mov  DL, '-'
    int  21h
    mov  AX, CX
    neg  AX
oi1:  
    xor  CX, CX
    mov  BX, 10 
oi2:
    xor  DX,DX
    div  BX
    push DX
    inc  CX
    test AX, AX
    jnz  oi2
    mov  AH, 02h
oi3:
    pop  DX
    add  DL, '0'
    int  21h
    loop oi3
    pop  CX
    ret
 
OutInt endp
       
   
exit:  
       
end START
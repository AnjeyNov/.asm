.model small                                                    ; .exe programm
    
.stack 100h                                                     ; 256B fo stack
   
;;;;;;;;;DATA SEGMENT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
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
;;;;;;;;;END DATA SEGMENT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;CODE SEGMENT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
.code

START:     
   mov   AX, @data          ; AX = *data
   mov   DS, AX             ; SET DATA SEGMENT
   
;;;;;;get number of column;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hc:

   mov   AH, 09h            ; cout << message3
   lea   DX, message3       ;
   int   21h                ;
           
   xor   AX, AX             ; AX = 0
   mov   AH, 01h            ; AH = 01h - read one sumbol, result in AL  (getchar())
   int   21h                ; interrupt for implementation
   
   mov   AH, 0              ; AH = 0 
   cmp   AL, '0'            ; {  
   jl    hcerror            ;   if( '0'> AL || AL > '5')
   cmp   AL, '5'            ;       goto hcerror
   jg    hcerror            ; }
   and   AX, 0Fh            ; AX -= 0Fh (48) - char to int
   mov   columns, AL        ; column = AL
   jmp   hr                 ; goto hr
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
hcerror:                    ; error of input 
                            ;
   mov   AH, 09h            ; cout << message5
   lea   DX, message5       ;
   int   21h                ;
   jmp   hc                 ; goto hc
   
;;;;;;get number of column;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     

;;;;;;get number of row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
hr:

   mov   AH, 09h            ; cout << message4
   lea   DX, message4       ;
   int   21h                ;
           
   xor   AX, AX             ; AX = 0
   mov   AH, 01h            ; AH = 01h - read one sumbol, result in AL (getchar())
   int   21h                ; interrupt for implementation
   
   mov   AH, 0              ; AH = 0 
   cmp   AL, '0'            ; {  
   jl    hrerror            ;   if( '0'> AL || AL > '6')
   cmp   AL, '6'            ;       goto hrerror
   jg    hrerror            ; }
   and   AX, 0Fh            ; AX -= 0Fh (48) - char to int
   mov   rows, AL           ; column = AL
   jmp   INPUT_ARRAY        ; goto INPUT_ARRAY   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                        
hrerror:                    ; error of input
                            ;
   mov   AH, 09h            ; cout << message5
   lea   DX, message5       ;
   int   21h                ;
   jmp   hr                 ; goto hr

;;;;;;get number of row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   


;;;;;;loop to input array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

INPUT_ARRAY:

   mov   AH, 09h            ; cout << messahe1
   lea   DX, message1       ;
   int   21h                ;
   
   xor   CX, CX             ; CX = 0
   mov   CL, rows           ; CL = rows
   xor   SI, SI             ; SI = 0 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
loop1:                      ; do{
   push  CX                 ;   push CX to stack
                            ;
   mov   AH, 09h            ;   cout << endl
   lea   DX, endl           ;
   int   21h                ;
                            ;
   xor   CX, CX             ;   CX = 0
   mov   CL, columns        ;   CL = columns
                            ;
loop2:                      ;   do{  
                            ;
   call  get_number         ;       get_number() - result in AX
   mov   array[SI], AX      ;       array[SI] = AX
   inc   SI                 ;       ++SI
   inc   SI                 ;       ++SI
                            ;
   mov   AH, 09h            ;       cout << endl;
   lea   DX, endl           ;
   int   21h                ;
                            ;      
   loop  loop2              ;       }while(--CX!=0)
   pop   CX                 ;   pop CX form stack
   loop  loop1              ;   }while(CX--!=0)    
   
;;;;;;loop for input array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   

;;;;;;loop for calculate the sum in a row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
SUM: 

   xor   CX, CX             ; CX = 0
   mov   CL, rows           ; CL = rows
   xor   SI, SI             ; SI = 0
   xor   DI, DI             ; DI = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum_loop1:                  ; do{
   push  CX                 ;   push CX to stack
   xor   CX, CX             ;   CX = 0
   mov   CL, columns        ;   CL = columns
                            ;
sum_loop2:                  ;   do{
                            ;       
                            ;
   mov   AX, array[SI]      ;       AX = array[SI]
   add   result[DI], AX     ;       result[DI] += AX
   jo    sum_error          ;       ? OF==1 goto sum_error (overflow flag) - set sum in row = 0
   inc   SI                 ;       ++SI
   inc   SI                 ;       ++SI
   loop  sum_loop2          ;   }while(--CX!=0)
after_sum_error:            ;
   pop   CX                 ;   pop CX from stack
   inc   DI                 ;   ++DI
   inc   DI                 ;   ++DI
   loop  sum_loop1          ; }while(CX--!=0)
   jmp   OutputResult       ; goto OuputResult
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum_error:                  ; error of sum
   mov  result[DI], 00h     ; result[DI] = 0
   jmp  after_sum_error     ; goto after_sum_error
   

;;;;;;loop for calculate the sum in a row;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                                                                  
                                                                                                                                  
OutputResult: 

   mov  AH, 09h             ; cout << message2
   lea  DX, message2        ;
   int 21h                  ;
                            ;
   xor  CX, CX              ; CX = 0
   mov  CL, rows            ; CL = rows
   xor  SI, SI              ; SI = 0
output_loop:                ; do{
   mov  AX, result[SI]      ;   AX = result[SI]
   call OutInt              ;   OutInt()
   inc  SI                  ;   ++SI
   inc  SI                  ;   ++SI
                            ;
   mov  AH, 02h             ;   cout << ' '
   mov  DL, ' '             ;
   int 21h                  ;
                            ;
   loop output_loop         ; }while(CX--!=0)
   jmp exit                 ; goto exit
                                                                                                                                     
           
;;;;;;process to get the number;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           
get_number proc          ; void get_number (void)
                         ; {
   push  CX                    ; push CX, BX, SI, DI to stack
   push  BX 
   push  SI 
   push  DI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
start_gc:                    ; get string with number 
   
   
   mov   AH, 0Ah             ; 09h - function for get string     
   lea   DX, number          ; recipient's address
   int   21h                 ; interrupt for implementation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
check:                       ;      
   xor   CX, CX              ; CX = 0
   mov   CL, number[1]       ; CL = len of string with number
   cmp   CX, 0               ; did string enter?
   jle   geterror            ; sting did't enter Í> error of input
   mov   SI, 02h             ; SI = 2  (number[2] = firs sumbol of number)
   mov   AH, 00h             ; AH = 00h
   mov   AL, number[SI]      ; AL = number[2]
   cmp   AL, '-'             ; ? number[2] != '-' goto check_loop
   jne   check_loop          ;
   cmp   CL, 2               ; ? sting == "-" goto geterror
   jl    geterror            ;
   inc   SI                  ; SI = 3 (++CX)
   dec   CX                  ; --CX
                             ;
check_loop:                  ; do{
   mov   AL, number[SI]      ;  AL = number[SI]
   cmp   AL, '0'             ;  {
   jl    geterror            ;   if( '0'> AL || AL > '9')
   cmp   AL, '9'             ;      goto geterror
   jg    geterror            ;  }
   inc   SI                  ;  SI++
   loop check_loop           ; }while(CX--!=0)
   jmp   converting          ; goto converting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
geterror:                    ; number input error
   mov   AH, 09h             ;                                          
   lea   DX, message5        ;
   int   21h                 ;
   jmp   start_gc            ; inmut nember again
                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
converting:                  ; form string to int
                             ;
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
   loop  converting_loop     ; } while(CX--!=0)
   jmp   end_get             ; goto end_get
                             ;
                             ;
to_neg:                      ; convert to neg
   pop   DX                  ; pop form stack 
   neg   BX                  ; BX = -BX conversion to reverse code
   jo    overflow            ; ? OF==1 goto overflow (overflow flag)
   jmp   end_get             ; goto end_get
                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
overflow:                    ; overflow
   mov   AH, 09h             ;
   lea   DX, message6        ;
   int   21h                 ;
   jmp   start_gc            ; enter again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end_get:                     ;
   mov   AX, BX              ; result to AX
   pop   DI                  ; recovery DI, SI, BX. CX
   pop   SI                  ;
   pop   BX                  ;
   pop   CX                  ;
   ret                       ; return
get_number endp          ; }  
   

;;;;;;process to get the number;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    
 
 
OutInt proc               ;void output_int(void)
                          ;{
    push CX                  ; push CX to stack
    test AX, AX              ; if(AX>=0)
    jns  oi1                 ;  goto oi1
                             ;
    mov  BX, AX              ; BX = AX
    mov  AH, 02h             ; {
    mov  DL, '-'             ;  cout << '-'
    int  21h                 ; }
    mov  AX, BX              ; AX = BX
    neg  AX                  ; AX = -AX
oi1:                         ;
    xor  CX, CX              ; CX = 0
    mov  BX, 10              ; BX = 10
oi2:                         ; do{
    xor  DX,DX               ;  DX = 0
    div  BX                  ;  AX /= BX, DX = AX % BX
    push DX                  ;  push DX to stack
    inc  CX                  ;  ++CX
    test AX, AX              ; 
    jnz  oi2                 ; }while(AX!=0)
    mov  AH, 02h             ; AH = O2h - output one sumbol
oi3:                         ; do{
    pop  DX                  ;  pop DX from stack 
    add  DL, '0'             ;  DL += '0' (48) - char to int
    int  21h                 ;  interrupt for implementation
    loop oi3                 ; }while(CX--!=0)
    pop  CX                  ; pop CX from stack
    ret                      ; return
                             ;
OutInt endp              ;}
       
   
exit:  
       
end START
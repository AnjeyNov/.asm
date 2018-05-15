.model small  
    
.stack 100h 
    
.data
    message1 db 'Input 5x6: ',0Dh, 0Ah, '$'
    message2 db 'Result: $'
    enter db 0Dh, 0Ah, '$'              
    array  db 31 dup (0)
    result dw 6 dup (0)     
    flag    db  0    
    symbol db '$$'
    num db 1
        
.code
START:     
   mov   AX, @data
   mov   DS, AX  
   
   mov   AH, 09h         
   mov   DX, offset Message1
   int   21h 
                    
   mov   CX,30               
   xor   BX,BX              
   lea   DI,array 
   lea   SI,result           
cycle:                   
   mov   AL,' '    
   mov   BP, AX
   mov   [symbol], AL 
   mov   AH, 09h         
   mov   DX, offset symbol
   int   21h
   mov   AX, BP  
   call  ASC2HEX 
   cmp   flag, 1
   jne   ppp
   sub   [SI], AX
   neg   AX
   dec   flag
   jmp   pp1:
   
ppp:                             
   mov   [DI], AX
   add   [SI], AX 
pp1:
   inc   DI
   inc   SI 
   inc   SI
   dec   CX                     
   inc   BX                  
   cmp   BX, 5                
   jnz   next 
   lea   SI, result                
   xor   BX,BX                            
   mov   DX,offset enter               
   mov   AH,9                 
   int   21h                  
next:
   cmp   CX, 0                                    
   jne   cycle
   lea   SI, result
   mov   CX, 5
   mov   AH, 09h         
   mov   DX, offset Message2
   int   21h    
   jmp   exit              
    
    
   
   
    
ASC2HEX proc                                             
   push  CX 
   push  BX 
   push  SI 
   push  DI          
   xor   SI,SI               
   mov   BX,10                
   mov   CX,2                 
typeDigit:                    
   xor   AX,AX                
   int   16h    
   
   mov   BP, AX
   mov   [symbol], AL
   mov   AH, 09h         
   mov   DX, offset symbol
   int   21h
   mov   AX, BP
                    
   cmp   AL,'-'             
   jne   positive
   
   inc   flag
positive:                     
   cmp   AL,'0'               
   jb    typeDigit            
   cmp   AL,'9'               
   ja    typeDigit 
   and   AX,0Fh              
   xchg  AX,SI                
   mul   BX              
   add   SI,AX             
   loop  typeDigit           
   xchg  AX,SI               
   pop   DI 
   pop   SI 
   pop   BX 
   pop   CX        
RET
ASC2HEX endp
 
 
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
   mov AX, [SI]
   call OutInt
   mov DX, ' '
   int 21h
   inc SI
   inc SI
   dec CX
   cmp CX, 0
   jne exit
         
   lea SI, result
   lea DI, num     
   mov CX, 2
   mov AX, [SI]
   inc SI
   inc SI 
search:
   cmp [SI], AX
   jg s1
   mov [DI], CX
s1:   
   mov AX, [SI]
   inc SI
   inc SI
   inc CX
   cmp CX, 6
   jne search
   
   mov AH, 09h         
   mov DX, offset enter
   int 21h
   mov AX, [DI]
   call OutInt        
end START
.model small  
    
.stack 100h 
    
.data
    message1 db 'Input 5x6: $'
    message2 db 'Result: $'
                  
    array  db 30 dup (0)
    result db 6 dup (1)     
    flag    db  0    
    enter db 0Dh, 0Ah, '$'
    symbol db '$$'
        
.code
START:     
   mov ax, @data
   mov ds, ax   
                    
   mov   cx,30               
   xor   bx,bx              
   lea   DI,array            
cycle:                   
   mov   al,' '
    
   mov   bp, ax
   mov   [symbol], al 
   mov   ah, 09h         
   mov   dx, offset symbol
   int   21h
   mov   ax, bp 
                
   call  ASC2HEX 
   cmp   flag, 1
   jne ppp
   neg AX
   dec flag
   
ppp:                             
   mov   [di], AX
   inc   di
   dec   cx                     
   inc   bx                  
   cmp   bx, 5                
   jnz   next                 
   xor   bx,bx                            
   mov   dx,offset enter               
   mov   ah,9                 
   int   21h                  
next:
   cmp cx, 0                                    
   jne  cycle
   lea si, array
   lea di, result
   mov ax, 0
   mov bx, 0 
   
   jmp search              
    
    
   
   
    
ASC2HEX:                                             
   push cx 
   push bx 
   push si 
   push di          
   xor   si,si               
   mov   bx,10                
   mov   cx,2                 
typeDigit:                    
   xor   ax,ax                
   int   16h    
   
   mov   bp, ax
   mov   [symbol], al 
   mov   ah, 09h         
   mov   dx, offset symbol
   int   21h
   mov   ax, bp
                    
   cmp   al,'-'             
   jne   positive
   
   inc   flag
positive:                     
   cmp   al,'0'               
   jb    typeDigit            
   cmp   al,'9'               
   ja    typeDigit 
   and   ax,0Fh              
   xchg  ax,si                
   mul   bx              
   add   si,ax             
   loop  typeDigit           
   xchg  ax,si               
   pop   di 
   pop si 
   pop bx 
   pop cx        
RET                           

search:
   cmp bx, 6
   je exit 
a1:   
   cmp ax, 7
    jne a2
   mov ax,0
   inc bx
   lea si, array
   inc di
   add si, bx
   jmp a2
a2:      
   add si, ax
   mov dx, [si]
   sub [di], dx
   inc ax
   jmp search
       
   
exit:  


   mov   ah, 09h         
   lea   dx, result
   int   21h
       
end START
    .model small  ;.com programm     
    
    .stack 100h   ; 256 Byte fo stack
    
    .data         ; data initialization
        string db 200, 0, 200 dup ('$')
        size db 0
        
    .code         ; code segment
START:  
  
    mov AX, @data
    mov DS, AX    ; set data segment pointer
                                       
INPUT:
    
    mov AH, 0Ah
    mov DX, offset string
    int 21h    
    
    mov AL, string[1]
    mov size, AL 
    
SORT:     

    loop1:
        xor SI, SI
        mov SI, 2      ;start string  
        xor CX,CX
        mov CL, size 
        dec CL
        mov DL, 1
        loop2:
            mov AL, string[SI]
            cmp AL, string[SI+1]
            jng nxt
            xchg AL, string[SI+1]
            mov string[SI],AL
            xor DL, DL       
nxt:    
        inc SI
        loop loop2
        or DL, DL        
        jz loop1           
     
OUTPUT:
    
    mov AH, 02h
    mov DX, 0Ah
    int 21h
    
    mov DX, 0Dh
    int 21h
    
    mov AH, 09h
    mov DX, offset string
    inc DX
    inc DX
    int 21h

end START    

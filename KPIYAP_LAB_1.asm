    .model small
    
    .stack 100h 
    
    .data
        message1 db 'Found: $'
        message2 db 'String: $'
        message3 db 'Word: $'
                  
        symbols  db 200 dup('$')
        string   db 200 dup('$')
        
        enter db 0Dh, 0Ah, '$'
        
    .code
     
    mov ax, @data
    mov ds, ax   
    ;typing "String" 
    mov ah, 09h         
    mov dx, offset Message2
    int 21h
    ;reading string                         
    mov ah, 0Ah         
    mov dx, offset string
    int 21h   
    ;typing Enter
    mov ah, 09h
    mov dx, offset enter
    int 21h
    ;typing "Word:"     
    mov ah, 09h         
    mov dx, offset Message3
    int 21h
    ;reading word
    mov ah, 0Ah         
    mov dx, offset symbols
    int 21h
    ;typing Enter
    mov ah, 09h
    mov dx, offset enter
    int 21h
    
    ; nachlo pervogo slova v stroke     
    mov di, offset string
    inc di
    inc di
    
    ; nachalo slova
    mov si, offset symbols
    inc si
    inc si
    
    ; obnulenie schetchika simvolov v slove v stroke
    xor cx, cx
    inc cx
    
    ; schetchik simvolov v slove
    xor ax, ax
    inc ax 
    
go_to_new_word:
    cmp [di], ' '
    je check0
    inc di
    cmp [di], 13
    je SDWIG
    inc cx
    jmp go_to_new_word

check0:
    inc di
    mov bl, [si]       

check:
    cmp bl, [di]
    jne ne_sovpadayt
    inc si
    inc ax
    inc di
    cmp [di], ' '
    je konec1
    cmp [di], 13
    je konec1
    mov bl, [si]
    cmp bl, ' '
    je konec2
    cmp bl, 13
    je konec2
    jmp check
    
ne_sovpadayt:
    mov cx, ax
    xor ax, ax
    
    ; nachalo slova
    mov si, offset symbols
    inc si
    inc si
      
    ; schetchik simvolov v slove
    xor ax, ax
    inc ax
    jmp go_to_new_word

konec1:
    mov bl, [si]
    cmp bl, ' '
    je zamena
    cmp bl, 13
    je zamena
    cmp [di], 13
    je SDWIG
    mov cx, ax
    inc di 
     
    ; nachalo slova
    mov si, offset symbols
    inc si
    inc si
      
    ; schetchik simvolov v slove
    xor ax, ax
    inc ax
    jmp check

konec2:
    cmp [di], ' '
    je zamena
    cmp [di], 13
    je zamena
    mov cx, ax
    inc di
    inc cx
    
    ; nachalo slova
    mov si, offset symbols
    inc si
    inc si
      
    ; schetchik simvolov v slove
    xor ax, ax
    inc ax
    jmp go_to_new_word
    
zamena:
    xor bx,bx
    mov bx, cx
    add bx, ax
    dec bx
    
k_nachaly:
    dec di
    dec bx
    cmp bx, 0
    jne k_nachaly
    mov bx, cx

prod_zamena:
    mov [di], ' '
    dec bx               
    inc di
    cmp bx, 0
    jne prod_zamena
    mov bx,ax
    
cherez_slovo:
    inc di
    dec bx
    cmp bx, 0
    jne cherez_slovo
    mov cx, ax
    
    ; nachalo slova
    mov si, offset symbols
    inc si
    inc si
      
    ; schetchik simvolov v slove
    xor ax, ax
    inc ax
    jmp check
    
SDWIG:
    mov di, offset string
    inc di
    inc di
    mov si, di
    inc si
    
SEARCH:
    mov bl, [si]
    cmp [di], bl
    je SEARCH1
    inc si
    inc di
    jmp SEARCH
    
SEARCH1:
    cmp [di], ' '
    je SDWIG1
    cmp [di], '$'
    je OUTPUT
    inc si
    inc di
    jmp SEARCH
    
SDWIG1:
    inc di
    inc si

SDWIG2:
    cmp [si], ' '
    jne PERENOS
    inc si
    jmp SDWIG2
    
PERENOS:
    mov bl, [si]
    mov [di], bl
    mov [si], '$'
    inc si
    inc di
    cmp [si], '$'
    je OUTPUT
    cmp [si], ' '
    jne PERENOS
    mov [di], ' '
    mov [si], '$'
    inc di
    inc si
    jmp SDWIG2
              
OUTPUT:
    ;typing Enter
    mov ah, 09h
    mov dx, offset enter
    int 21h
    ;typing Enter
    mov ah, 09h
    mov dx, offset enter
    int 21h
    ;typing "Found:"     
    mov ah, 09h         
    mov dx, offset Message1
    int 21h
    ;tyoing string
    mov ah, 09h         
    mov dx, offset string+2
    int 21h    
    end
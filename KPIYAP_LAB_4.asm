.model small
 stack segment
    dw   128  dup(0)
ends

data segment
Player db 219,219, 219,"$"
h_line db "========================================$" ;40    
v_line db "|$" 
MsgW db "You WIN$"
MsgC db "Your count: $" 
MsgL db " You LOSE$"  
info db "YOUR LIFE:  $"
Bots db "     ý      ý      ý      ý      ý$"  
Bot1 db 1
Bot2 db 1
Bot3 db 1
Bot4 db 1
Bot5 db 1        
WhichBot db 1
 
PlayerShotFlag db 0 
BotShotFlag db 0
xBotShot db 7
yBotShot db 3
life db 3                                  
count db 0
yPlayerShot db 0
xPlayerShot db 0
yBots db 2
xBotsend  db 35
xPlayer db 6
xPlayerEnd db 8 
wait_time dw 0 
cur_dir db 0
ends                                        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro SetPos X,Y
mov AH,02h             ;Cursor position
mov DH,Y               ;Stroka
mov DL,X               ;Stolbec
int 10h                
endm
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
macro Paint_h Horizontal
SetPos 1,1             ;otput horizontal(1,1)
mov AH, 09h            ;otput horizontal(11,1)
lea DX,Horizontal      ;
int 21h                ;
                       ;
SetPos 1,11            ;
mov AH, 09h            ;
lea DX, Horizontal     ;
int 21h                ;
endm                   ;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro Paint_v Vertical
mov CX, 11             ;do
for: SetPos 0,CL       ;otput vertical(0,CL)
mov AH, 09h            ;otput vercical(40,CL)
lea DX, Vertical       ;--CX
int 21h                ;
                       ;
SetPos 40,CL           ;
mov AH, 09h            ;
lea DX, Vertical       ;
int 21h                ;
loop for               ;while(CX!=0)
endm                   ;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro PaintPlayer
mov AH, 09h           ;output Palayer
push BX               ;?!
mov BL, 01h           ;?!
lea DX, Player        ;
int 21h               ;
pop BX                ;?!
endm                  ;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro PaintBots
mov AH, 09h
push BX
mov BL, 01h
lea DX, Bots
int 21h
pop BX
endm 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro PrintLife
SetPos 54,1
mov AH, 02h 
mov DL, life  
add DL, 30h
int 21h
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro PrintCount
SetPos 54, 3
mov AH, 02h 
mov DL, count  
add DL, 30h
int 21h
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro Clear
mov AH,02h
mov DL,00h
int 21h
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro PrintShot
mov AH, 09h            
lea DX, v_line       
int 21h
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro SwipeBotShot
SetPos xBotShot, yBotShot
Clear
add yBotShot, 01h
SetPos xBotShot, yBotShot 
PrintShot
cmp yBotShot, 0Ah
je Got
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code segment
main:
mov AX, @data	; set data segment;
mov	DS, AX
mov BH, 00 
mov AH, 0		; function 0 (set video mode)

mov AL, 02h	
int 10h   

call  Init_all

mov AH,10h
int 16h

xor DI,DI
push DI
         
game:

mov AH, 01h    ;scan key and save to AX
int 16h 
je next1    ;if(ZF!=0)

what_key:
cmp AL, 073h
je end   
mov cur_dir, AL 

cmp cur_dir,061h
je GoLeft  

cmp cur_dir,064h
je GoRight  

cmp cur_dir, 077h
je   flagUP

next:

mov AH, 00h  ;pulls the value of the key pressed
int 16h
    
mov AL,00h

next1:

cmp BotShotFlag, 1
jne BotShot  

SwipeBotShot
next2:

cmp PlayerShotFlag, 1
je SwipePlayerShot  

next3:

jmp game
                 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

flagUp:
cmp PlayerShotFlag,1
jne PlayerShot
jmp next1                
                 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GoLeft:
cmp xPlayer, 1
je noBuffer
SetPos xPlayerEnd, 10
Clear
sub xPlayer, 1
sub xPlayerEnd,1
SetPos xPlayer, 10 
PaintPlayer 
mov cur_dir,0   
jmp next   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               
GoRight:
cmp xPlayerEnd, 38
je noBuffer
SetPos xPlayer, 10
Clear
add xPlayer, 1 
add xPlayerEnd, 1
SetPos xPlayer, 10
PaintPlayer
mov cur_dir,0    
jmp next               

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayerShot:
mov PlayerShotFlag, 1
push AX
mov AL,xPlayer
mov xPlayerShot, AL
pop AX
add xPlayerShot, 1
mov yPlayerShot, 9
SetPos xPlayerShot, yPlayerShot 
PrintShot
jmp next

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                       
                                                                       
SwipePlayerShot:
SetPos xPlayerShot, yPlayerShot
Clear
sub yPlayerShot, 1
SetPos xPlayerShot, yPlayerShot
PrintShot
cmp yPlayerShot, 2
jne next3
sp1:
cmp xPlayerShot, 7
jne sp2
cmp Bot1, 1
jne sp0
mov Bot1, 0
add count, 1
PrintCount
cmp count, 5
je win
jmp sp0 
sp2:
cmp xPlayerShot, 14
jne sp3
cmp Bot2, 1
jne sp0
mov Bot2, 0
add count, 1
PrintCount
cmp count, 5
je win
jmp sp0 
sp3:
cmp xPlayerShot, 21
jne sp4
cmp Bot3, 1
jne sp0
mov Bot3, 0
add count, 1
PrintCount
cmp count, 5
je win
jmp sp0 
sp4:
cmp xPlayerShot, 28
jne sp5
cmp Bot4, 1
jne sp0
mov Bot4, 0
add count, 1
PrintCount
cmp count, 5
je win
jmp sp0 
sp5:
cmp xPlayerShot, 35
jne sp0
cmp Bot5, 1
jne sp0
mov Bot5, 0
add count, 1
PrintCount
cmp count, 5
je win
sp0:
SetPos xPlayerShot, yPlayerShot
Clear
mov PlayerShotFlag, 0
jmp next3
                                                                       
                                                                       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NoBuffer:
mov cur_dir,0 
jmp next

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BotShot:
mov BotShotFlag, 1
SetPos xBotShot, yBotShot
PrintShot
add WhichBot, 1
cmp WhichBot, 6
jne next2
mov WhichBot, 1
jmp next2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               
Got:
push AX
mov AL, xPlayer
cmp AL, xBotShot 
je DownLife     
add AL, 1
cmp AL, xBotShot 
je DownLife
add AL, 1
cmp AL, xBotShot 
je DownLife
SetPos xBotShot, 10
Clear
b0:
mov BotShotFlag, 0
mov yBotShot, 3
b1:
cmp WhichBot, 1
jne b2
cmp Bot1, 1
jne b2
mov xBotShot, 7
jmp next2 
b2:
cmp WhichBot, 2
jne b3
cmp Bot2, 1
jne b3
mov xBotShot, 14
jmp next2
b3:
cmp WhichBot, 3
jne b4
cmp Bot3, 1
jne b4
mov xBotShot, 21
jmp next2
b4:
cmp WhichBot, 4
jne b5
cmp Bot4, 1
jne b5
mov xBotShot, 28
jmp next2
b5:
mov xBotShot, 35
jmp next2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DownLife:
sub life, 1
PrintLife 
cmp life, 0
je Lose
SetPos xPlayer, 10
PaintPlayer
jmp b0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Lose:
PrintLife
SetPos 42, 2
mov AH, 09h
lea DX, MsgL
int 21h
jmp end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

win: 
PrintCount
SetPos 42, 2
mov AH, 09h
lea DX, MsgW
int 21h
jmp end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Init_all proc near   ;print game area 
Paint_h h_line
Paint_v v_line
SetPos 6,10   
PaintPlayer    
SetPos 2,2
PaintBots     
SetPos 42,1 
mov AH, 09h
lea DX, Info
int 21h
PrintLife
SetPos 42,3
mov AH, 09h
lea DX, MsgC
int 21h 
PrintCount

    
mov Al, 0 
ret       
Init_all endp    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ends
end:
end main                  
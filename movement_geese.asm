global processMovementGoose
extern checkCollisions
extern puts
extern gets

%macro mPuts 0
  sub     rsp,8
  call    puts
  add     rsp,8
%endmacro
%macro mGets 0
  sub     rsp,8
  call    gets
  add     rsp,8
%endmacro

section .data
  msgTurn           db  "[GEESE'S TURN]",0
  msgInput          db  "Insert a character (send A, S, D to move, R to select another goose, Enter to skip or Q to quit)",0
  msgInvalid        db  "Invalid direction!",0
  letterA           db "a", 0
  letterS           db "s", 0
  letterD           db "d", 0
  letterR           db "r", 0
  letterQ           db "q", 0
  letterEnter       db 0
  posWalls          db 2,1, 6,1, 2,2, 6,2, 1,2, 7,2, 1,6, 2,6, 6,6, 7,6, 2,7, 6,7

section .bss
  newPos            resb 2
  keyboardInput     resb 500

section .text
processMovementGoose:
  ; input:
  ; r12 -> posGoose
  ; r13 -> posGeese
  ; r14 -> posFox

  mov     rdi,msgTurn
  mPuts

inputChar:
  ; parse param
  mov     al, byte [r12]
  mov     [newPos], al
  mov     al, byte [r12 + 1]
  mov     [newPos + 1], al

  ; ask input
  mov     rdi, msgInput
  mPuts
  mov     rdi, keyboardInput
  mGets
  mov     al, byte[keyboardInput]

  mov     r10, 0
  mov     r11, 0

  ; parse input
  cmp     al, [letterA]
  je      isA
  cmp     al, [letterS]
  je      isS
  cmp     al, [letterD]
  je      isD
  cmp     al, [letterR]
  je      isR
  cmp     al, [letterQ]
  je      isQ
  cmp     al, [letterEnter]
  je      isEnter

  jmp     inputChar

isA:
  mov     al, [newPos]
  dec     al
  mov     [newPos], al

  jmp     verify_position

isS:
  mov     al, [newPos + 1]
  inc     al
  mov     [newPos + 1], al

  jmp     verify_position

isD:
  mov     al, [newPos]
  inc     al
  mov     [newPos], al

  jmp     verify_position

isQ:
  mov     r11, 1
  jmp     end_movement

isR:
  mov     r10, 1
  jmp     end_movement

isEnter:
  jmp     end_movement

verify_position:
  ; if new position is out of bounds it's invalid
  cmp     byte[newPos], 0
  jle     invalid_movement
  cmp     byte[newPos], 8
  jge     invalid_movement
  cmp     byte[newPos + 1], 0
  jle     invalid_movement
  cmp     byte[newPos + 1], 8
  jge     invalid_movement

  ; check collisions with walls
  mov     r8, newPos
  mov     r9, posWalls
  mov     r10, 12
  sub     rsp, 8
  call    checkCollisions
  add     rsp, 8
  cmp     r11, 0
  jg      invalid_movement

  ; check collisions with other geese
  mov     r8, newPos
  mov     r9, r13
  mov     r10, 17
  sub     rsp, 8
  call    checkCollisions
  add     rsp, 8
  cmp     r11, 0
  jg      invalid_movement

  ; check collisions with the fox
  mov     r8, newPos
  mov     r9, r14
  mov     r10, 1
  sub     rsp, 8
  call    checkCollisions
  add     rsp, 8
  cmp     r11, 0
  jg      invalid_movement

  ; apply new movement
  mov     al, [newPos]
  mov     [r12], al
  mov     al, [newPos + 1]
  mov     [r12 + 1], al

  mov     r10, 0

  ret

end_movement:
  ; output:
  ; r10 -> selection again flag
  ; r11 -> interruption flag

  ret

invalid_movement:
  mov     rdi, msgInvalid
  mPuts
  jmp     inputChar
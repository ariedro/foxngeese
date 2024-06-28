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
  msgInput          db  "[GEESE'S TURN]",10,"Insert a character (send A, S, D or Enter)",0
  letterA           db "a", 0
  letterS           db "s", 0
  letterD           db "d", 0
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

  ; parse input
  cmp     al, [letterA]
  je      isA
  cmp     al, [letterS]
  je      isS
  cmp     al, [letterD]
  je      isD
  cmp     al, [letterEnter]
  je      isEnter

  jmp     processMovementGoose

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

  ret

end_movement:
  ret

invalid_movement:
  jmp     processMovementGoose
global main
extern checkBlockedFox
extern gameOver
extern printBoard
extern processMovementFox
extern processMovementGoose
extern resetSelectGoose
extern selectGoose

section .data
  posFox            db  4,5
  posGeese          db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,4,  5,3,  6,3,  7,3,  1,4,  7,4,  1,5,  7,5
  turn              db  1 ; 1 - fox, 2 - geese
  selectedGoose     db  1
  selectingGoose    db  0 ; 0 - no, 1 - yes
  eatenGeese        db  0

section .bss
section .text
main:
main_loop:
  mov     r8, posFox
  mov     r9, posGeese
  mov     r12,0
  mov     r12b,[selectedGoose]
  mov     r13,0
  mov     r13b,[selectingGoose]
  sub     rsp,8
  call    printBoard
  add     rsp,8

  ; check turn
  mov     rax, 0
  mov     al, [turn]
  cmp     al, 1
  je      fox_turn

geese_turn:
  mov     r14, posGeese
  sub     rsp,8
  call    selectGoose
  add     rsp,8
  mov     [selectingGoose],al
  mov     [selectedGoose],bl

  ; if keeps selecting the turns continue
  cmp     al,1
  je      main_loop

  ; call goose movement process
  mov     rcx,posGeese
  mov     rax,0
  mov     al,byte[selectedGoose]
  sub     al,1
  add     al,al
  add     rcx,rax
  mov     r12,rcx
  mov     r13,posGeese
  mov     r14,posFox
  sub     rsp,8
  call    processMovementGoose
  add     rsp,8

  ; else its fox turn
  mov     al,1
  mov     [turn],al

  ; check if game is over
  mov     r12,posGeese
  mov     r13,posFox
  sub     rsp,8
  call    checkBlockedFox
  add     rsp,8
  cmp     r14,0
  je      main_loop

  mov     r12,2
  jmp     game_over

fox_turn:
  ; update next turn
  mov     al,2
  mov     [turn],al

  ; call fox movement process
  mov     r12, posFox
  mov     r13, posGeese
  mov     r14, eatenGeese
  mov     r15, turn
  sub     rsp,8
  call    processMovementFox
  add     rsp,8

  ; reset the geese selection state
  mov     r12,selectedGoose
  mov     r13,posGeese
  sub     rsp,8
  call    resetSelectGoose
  add     rsp,8

  mov     al, 1
  mov     [selectingGoose],al

 ; check if game is over
 cmp     byte[eatenGeese],12
 jl      main_loop

 mov     r12,1
 
game_over:
 sub     rsp,8
 call    gameOver
 add     rsp,8

 ret

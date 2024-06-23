global main
extern printBoard
extern processMovementFox
extern processMovementGoose
extern selectGoose

section .data
  posFox            db  4,5
  posGeese          db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,4,  5,3,  6,3,  7,3,  1,4,  7,4,  1,5,  7,5
  turn              db  1 ; 1 - fox, 2 - geese
  selectedGoose     db  3
  selectingGoose    db  0 ; 0 - no, 1 - yes

section .bss
section .text
main:
  push    rbp
  mov     rbp, rsp
  sub     rsp, 16

main_loop:
  mov     r8, posFox
  mov     r9, posGeese
  mov     r12,0
  mov     r12b,[selectedGoose]
  mov     r13,0
  mov     r13b,[selectingGoose]
  call    printBoard

  ; check turn
  mov     rax, 0
  mov     al, [turn]
  cmp     al, 1
  je      fox_turn

geese_turn:
  call    selectGoose
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
  call    processMovementGoose

  ; else its fox turn
  mov     al,[turn]
  dec     al
  mov     [turn],al

  jmp     main_loop

fox_turn:
  ; update next turn
  inc     al
  mov     [turn],al

  ; call fox movement process
  mov     r12, posFox
  mov     r13, posGeese
  call    processMovementFox

  mov     al, 1
  mov     [selectingGoose],al

  jmp     main_loop

  ret

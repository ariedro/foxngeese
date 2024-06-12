global main
extern printBoard
extern gets
extern puts
extern processMovement

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
  posFox    db  4,5
  posGeese  db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,4,  5,3,  6,3,  7,3,  1,4,  7,4,  1,5,  7,5
  msgInChar db  "insert a character",0

section .bss
  text            resb 500

section .text
main:
  push    rbp
  mov     rbp, rsp
  sub     rsp, 16

main_loop:
  mov     r8, posFox
  mov     r9, posGeese
  call    printBoard

  ; insert char
  mov     rdi, msgInChar
  mPuts
  mov     rdi, text
  mGets

  ; call movement process
  mov     rdi, posFox
  mov     rsi, text
  call    processMovement

  jmp     main_loop

  ret

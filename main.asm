global main
extern printBoard
extern gets
extern puts

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
  posGeese  db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,3,  5,3,  6,3,  7,3,  1,4,  7,4,  1,5,  7,5
  msgInChar db  "insert a character",0
  letterW db "w", 0
  letterA db "a", 0
  letterS db "s", 0
  letterD db "d", 0

section     .bss
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

  ; Insert char
  mov     rdi, msgInChar
  mPuts
  mov     rdi, text
  mGets

  ; Compare the char
  mov     bl, byte [text]

  cmp     bl, [letterW]
  je      isW

  cmp     bl, [letterA]
  je      isA

  cmp     bl, [letterS]
  je      isS

  cmp     bl, [letterD]
  je      isD


  jmp     endComparison

isW:
  mov     al, [posFox + 1]
  dec     al
  mov     [posFox + 1], al
  jmp     main_loop

isS:
  mov     al, [posFox + 1]
  inc     al
  mov     [posFox + 1], al
  jmp     main_loop

isA:
  mov     al, [posFox]
  dec     al
  mov     [posFox], al
  jmp     main_loop

isD:
  mov     al, [posFox]
  inc     al
  mov     [posFox], al
  jmp     main_loop

endComparison:
  mov     rsp, rbp
  pop     rbp
  ret

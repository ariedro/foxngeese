global main
extern printBoard
extern gets

section .data
  posFox    db  4,5
  posGeese  db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,3,  5,3,  6,3,  7,3,  1,4,  7,4,  1,5,  7,5

section .text
main:
  sub   rsp,8
  mov   r8,posFox
  mov   r9,posGeese
  call  printBoard
  add   rsp,8
  ret

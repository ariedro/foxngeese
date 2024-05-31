global main
extern printBoard
extern gets

section .data
  posFox  db  4,3

section .text
main:
  sub   rsp,8
  mov   r8,posFox
  call  printBoard
  add   rsp,8
  ret

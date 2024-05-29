global main
extern printBoard

section .data
section .text
main:
  sub   rsp,8
  call  printBoard
  add   rsp,8
  ret

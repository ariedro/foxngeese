global printBoard
extern system
extern puts

section .data
  cmd_clear   db  "clear",0
  board       db  "    ╔═╤═╤═╗",10, "    ║ │ │ ║",10, "    ╟─┼─┼─╢",10, "    ║ │ │ ║",10,\
                  "╔═╤═╝─┼─┼─╚═╤═╗",10, "║ │ │ │ │ │ │ ║",10, "╟─┼─┼─┼─┼─┼─┼─╢",10,\
                  "║ │ │ │ │ │ │ ║",10, "╟─┼─┼─┼─┼─┼─┼─╢",10, "║ │ │ │ │ │ │ ║",10,\
                  "╚═╧═╗─┼─┼─╔═╧═╝",10, "    ║ │ │ ║",10, "    ╟─┼─┼─╢",10, "    ║ │ │ ║",10,\
                  "    ╚═╧═╧═╝"
section .text
printBoard:
  sub   rsp,8
  mov   rdi,cmd_clear
  call  system
  add   rsp,8
  sub   rsp,8
  mov   rdi,board
  call  puts
  add   rsp,8
  ret

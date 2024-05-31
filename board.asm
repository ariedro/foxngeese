global printBoard
extern system
extern strcpy
extern puts

section .bss
  screen      resb  475
section .data
  cmd_clear   db  "clear",0
  board       db  "    ╔═╤═╤═╗",10, "    ║ │ │ ║",10, "    ╟─┼─┼─╢",10, "    ║ │ │ ║",10,\
                  "╔═╤═╝─┼─┼─╚═╤═╗",10, "║ │ │ │ │ │ │ ║",10, "╟─┼─┼─┼─┼─┼─┼─╢",10,\
                  "║ │ │ │ │ │ │ ║",10, "╟─┼─┼─┼─┼─┼─┼─╢",10, "║ │ │ │ │ │ │ ║",10,\
                  "╚═╧═╗─┼─┼─╔═╧═╝",10, "    ║ │ │ ║",10, "    ╟─┼─┼─╢",10, "    ║ │ │ ║",10,\
                  "    ╚═╧═╧═╝",0
section .text
printBoard:
  initialize:
  sub   rsp,8
  mov   rsi,board
  mov   rdi,screen
  call  strcpy
  add   rsp,8
 
  ; pos fox comes in r8
  mov   rax,0
  mov   rbx,0
  mov   al,[r8]
  mov   bl,[r8 + 1]
 
  sub   rbx,1
  cmp   rbx,2
  jl    upperSector
  cmp   rbx,5
  jl    middleSector

  lowerSector:
  mov   rcx,141
  imul  rbx,46
  jmp   sumItUp
  middleSector:
  mov   rcx,-15
  imul  rbx,78
  jmp   sumItUp
  upperSector:
  mov   rcx,25
  imul  rbx,46

  sumItUp:
  sub   rax,1
  imul  rax,4

  add   rcx,rax
  add   rcx,rbx

  mov   byte[screen + rcx],88

  print:
  sub   rsp,8
  mov   rdi,cmd_clear
  call  system
  add   rsp,8
  sub   rsp,8
  mov   rdi,screen
  call  puts
  add   rsp,8
  ret

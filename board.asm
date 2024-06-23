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
 
  mov   rsi,0
  initloop:
  mov   rax,0
  mov   rbx,0

  ; pos fox comes in r8
  mov   al,[r8]
  mov   bl,[r8 + 1]

  cmp   rsi,0
  jz    calculatePos

  ; pos goose comes in r9
  mov   al,[r9 + ((rsi - 1) * 2)]
  mov   bl,[r9 + ((rsi - 1) * 2) + 1]
 
  calculatePos:
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

  mov   rax,0
  mov   al,79 ; O

  cmp   rsi,0
  jnz   insertSelect
  mov   al,88 ; X

  insertSelect:
  cmp   r13,1
  jne   insertPiece
  cmp   rsi,r12
  jne   insertPiece
  mov   al,83 ; S


  insertPiece:
  mov   byte[screen + rcx],al

  inc   rsi 
  cmp   rsi,17
  jle   initloop

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

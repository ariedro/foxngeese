global gameOver
extern system
extern puts

%macro mSystem 0
  sub   rsp,8
  call  system
  add   rsp,8
%endmacro
%macro mPuts 0
  sub     rsp,8
  call    puts
  add     rsp,8
%endmacro

section .data
  cmdClear      db "clear",0
  msgBeggining  db  "▓▓▒▒░░   ░░▒▒▓▓", 10, "▓▓▒▒░░   ░░▒▒▓▓", 10, "▓▓▒▒╔════╗░▒▒▓▓", 10,\
                    "▓▓▒▒║GAME╚╗▒▒▓▓", 10, "▓▓▒▒╚╗OVER║▒▒▓▓", 10, "▓▓▒▒░╚════╝▒▒▓▓", 10,\
                    "▓▓▒▒░░   ░░▒▒▓▓", 10, "▓▓▒▒░░   ░░▒▒▓▓", 10, "▓▓▒▒░░   ░░▒▒▓▓", 10,\
                    "▓▓╔═════════╗▓▓", 10, "▓▓║ Winner: ║▓▓", 0
  msgFox        db  "▓▓║   FOX   ║▓▓", 0
  msgGeese      db  "▓▓║  GEESE  ║▓▓", 0
  msgFinal      db  "▓▓╚═════════╝▓▓", 10, "▓▓▒▒░░   ░░▒▒▓▓", 10, "▓▓▒▒░░   ░░▒▒▓▓", 0

section .bss
  screen        resb  600

section .text
gameOver:
  ; input:
  ; r12 -> 1 - fox win, 2 - geese win
  mov   rdi,cmdClear
  mSystem
  mov   rdi,msgBeggining
  mPuts
  cmp   r12,1
  jne   geeseWin
  mov   rdi,msgFox
  mPuts
  jmp final

geeseWin:
  mov   rdi,msgGeese
  mPuts

final:
  mov   rdi,msgFinal
  mPuts

  ret
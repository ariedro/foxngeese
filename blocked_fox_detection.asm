global checkBlockedFox
extern checkCollisions

section .data
  posWalls            db 1,1, 2,1, 6,1, 7,1, 1,2, 2,2, 6,2, 7,2, 1,6, 2,6, 6,6, 7,6, 1,7, 2,7, 6,7, 7,7
  amountWalls         db 16
  posRelativeFox      db -1,-1, 0,-1, 1,-1, -1,0, 1,0, -1,1, 0,1, 1,1, -2,-2, 0,-2, 2,-2, -2,0, 2,0, -2,2, 0,2, 2,2
  amountRelativeFox   db 32

section .bss
  posCurrent         resb 2
section .text

checkBlockedFox:
  ; input:
  ; r12 -> posGeese
  ; r13 -> posFox

  ; output:
  ; r14 -> 0 - not blocked, 1 - blocked

  mov r14,1

  ; loop through all possible movements
  mov rdi, 0
  check_movement_loop:
  ; pos x in relative coords
  mov dl, [posRelativeFox + rdi]
  ; pos x in absolute coords
  mov al, byte[r13]
  add al, dl
  mov [posCurrent], al

  ; pos y in relative coords
  mov dl, [posRelativeFox + rdi + 1]
  ; pos y in absolute coords
  mov al, byte[r13 + 1]
  add al, dl
  mov [posCurrent + 1], al

  ; if current position is out of bounds it's invalid
  cmp     byte[posCurrent], 0
  jle     blocked_movement
  cmp     byte[posCurrent], 8
  jge     blocked_movement
  cmp     byte[posCurrent + 1], 0
  jle     blocked_movement
  cmp     byte[posCurrent + 1], 8
  jge     blocked_movement

  ; check collisions with walls
  mov     r8, posCurrent
  mov     r9, posWalls
  mov     r10, 16
  sub     rsp, 8
  call    checkCollisions
  add     rsp, 8
  cmp     r11, 0
  jg      blocked_movement

  ; check collisions with geese
  mov     r8, posCurrent
  mov     r9, r12
  mov     r10, 17
  sub     rsp, 8
  call    checkCollisions
  add     rsp, 8
  cmp     r11, 0
  jg      blocked_movement

  ; there exists a non-blocked movement
  mov     r14, 0
  jmp     exit

blocked_movement:
  add     rdi, 2
  cmp     dil, byte[amountRelativeFox]
  jl      check_movement_loop

exit:
  ret
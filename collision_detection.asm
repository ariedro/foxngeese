global checkCollisions

section .text
checkCollisions:
  ; input:
  ; r8 -> object position
  ; r9 -> blocks positions
  ; r10 -> blocks amount

  ; output:
  ; r11 -> collisions amount

  mov     r11, 0
  mov     rcx, r10
  ; index
  mov     rsi, 0
compare_block_loop:
  ; block x
  mov     dl, [r9 + rsi]
  ; compare with object x
  cmp     dl, [r8]
  jne     next_block

  ; block y
  mov     dl, [r9 + rsi + 1]
  ; compare with object y
  cmp     dl, [r8 + 1]
  jne     next_block

  ; is block, can't move
  add     r11,1

next_block:
  add     rsi, 2
  loop    compare_block_loop

end:
  ret
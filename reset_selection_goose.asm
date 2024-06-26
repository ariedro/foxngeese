global resetSelectGoose

section .text
resetSelectGoose:
  ; input:
  ; r12 -> selectedGoose
  ; r13 -> posGeese

  ; search for first goose alive
  mov   rsi, 0
search_first_goose_alive_loop:
  mov   al, byte[r13 + rsi * 2]
  cmp   al, 0
  jne   update_selected_goose
  add   rsi, 1
  cmp   rsi, 17
  jl    search_first_goose_alive_loop

update_selected_goose:
  add   rsi, 1
  mov   [r12],sil

  ret

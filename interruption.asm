global interruption
extern puts
extern gets

%macro mPuts 0
  sub     rsp,8
  call    puts
  add     rsp,8
%endmacro
%macro mGets 0
  sub     rsp,8
  call    gets  
  add     rsp,8
%endmacro

section .data
  msgInterrupt  db "Are you sure you want to exit? (Send Y or N)",0
  letterY       db "y"
  letterN       db "n"

section .bss
  keyInput      resb 500
section .text
interruption:
  ; ask input
  mov     rdi,msgInterrupt
  mPuts
  mov     rdi,keyInput
  mGets
  mov     al,byte [keyInput]

  ; parse input
  cmp     al, [letterY]
  je      isY
  cmp     al, [letterN]
  je      isN
  jmp     interruption

isY:
  mov     r11, 1
  jmp     exit

isN:
  mov     r11, 0
  jmp     exit

exit:
  ; output:
  ; r11 -> interruption flag

  ret

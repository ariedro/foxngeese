global selectGoose
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
  msgInput        db  "[GEESE'S TURN]",10,"Select a goose (send  A, D or enter)",0
  letterA         db "a"
  letterD         db "d"
  letterEnter     db 0
  selectingGoose  db 1

section .bss
  keyboardInput   resb 500
  selectedGoose   resb  1

section .text
selectGoose:
  ; input:
  ; r12 -> selectedGoose

  mov     byte[selectingGoose],1
  mov     [selectedGoose],r12b

  ; ask input
  mov     rdi,msgInput
  mPuts
  mov     rdi,keyboardInput
  mGets
  mov     al,byte [keyboardInput]

  ; parse input
  cmp     al, [letterA]
  je      isA
  cmp     al, [letterD]
  je      isD
  cmp     al, [letterEnter]
  je      isEnter
  jmp     exit

isA:
  ; check if it is out of bounds
  cmp     byte[selectedGoose],1
  je      exit
  ; sub 1 to selected goose index
  sub     byte[selectedGoose],1
  jmp     exit
isD:
  ; check if it is out of bounds
  cmp     byte[selectedGoose],16
  jg      exit
  ; add 1 to selected goose index
  add     byte[selectedGoose],1
  jmp     exit

isEnter:
  mov     byte[selectingGoose],0
  jmp     exit

exit:
  ; output:
  ; al -> if still selecting goose
  ; bl -> new goose selected

  mov al,[selectingGoose]
  mov bl,[selectedGoose]

  ret
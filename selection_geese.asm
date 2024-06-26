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
  ; r14 -> posGeese

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
  ; search first goose to the left that is alive
  movzx   rax, byte[selectedGoose]
  left_loop:
  sub     al, 1
  ; check if it is out of bounds 
  cmp     al,0
  je      exit
  mov     bl, byte[r14 + (2 * (rax - 1))]
  ; if its not alive then search the next one to the left
  cmp     bl, 0
  je      left_loop
  ; update selected goose index
  mov     byte[selectedGoose],al
  jmp     exit
isD:
  ; search first goose to the right that is alive
  movzx   rax, byte[selectedGoose]
  right_loop:
  add     al, 1
  ; check if it is out of bounds 
  cmp     al,18
  je      exit
  mov     bl, byte[r14 + (2 * (rax - 1))]
  ; if its not alive then search the next one to the right
  cmp     bl, 0
  je      right_loop
  ; update selected goose index
  mov     byte[selectedGoose],al
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
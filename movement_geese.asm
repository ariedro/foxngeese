global processMovementGoose
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
  msgInput          db  "[GEESE'S TURN]",10,"Insert a character (send W, A, S or D)",0
  letterW           db "w", 0
  letterA           db "a", 0
  letterS           db "s", 0
  letterD           db "d", 0
  selectingGoose    db 1
  posBoard          db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,3,  5,3,  6,3,  7,3,  1,4,  2,4,  3,4,  4,4,  5,4,  6,4,  7,4,  1,5,  2,5,  3,5,  4,5,  5,5,  6,5,  7,5, 3,6,  4,6,  5,6, 3,7,  4,7,  5,7

section .bss
  posOriginalGoose  resb 2
  keyboardInput     resb 500

section .text
processMovementGoose:
  ; input:
  ; r12 -> posGeese

  ; parse param
  mov     al, byte [r12]
  mov     [posOriginalGoose], al
  mov     al, byte [r12 + 1]
  mov     [posOriginalGoose + 1], al

  ; ask input
  mov     rdi, msgInput
  mPuts
  mov     rdi, keyboardInput
  mGets
  mov     al, byte[keyboardInput]

  ; parse input
  cmp     al, [letterW]
  je      isW
  cmp     al, [letterA]
  je      isA
  cmp     al, [letterS]
  je      isS
  cmp     al, [letterD]
  je      isD
  jmp     verifyValidPosition

isW:
  mov     al, [r12 + 1]
  dec     al
  mov     [r12 + 1], al

  jmp     verifyValidPosition

isA:
  mov     al, [r12]
  dec     al
  mov     [r12], al

  jmp     verifyValidPosition

isS:
  mov     al, [r12 + 1]
  inc     al
  mov     [r12 + 1], al
  
  jmp     verifyValidPosition

isD:
  mov     al, [r12]
  inc     al
  mov     [r12], al

  jmp     verifyValidPosition

verifyValidPosition:
  mov     rax, r12        ; save new goose position
  mov     rbx, posBoard   ; load posBoard base address
  mov     rcx, 36         ; amount of posBoard elements

compare_loop:
  mov     dl, [rbx]       ; posBoard x
  mov     dh, [rbx + 1]   ; posBoard y
  cmp     dl, [rax]       ; compare with goose x
  jne     next
  cmp     dh, [rax + 1]   ; compare with goose y
  jne     next

  jmp     end_compare  ; it matches, its a board position

next:
  add     rbx, 2          ; next board pos
  loop    compare_loop

  ; no one matches, return to original position
  mov     al, [posOriginalGoose]
  mov     [r12], al
  mov     al, [posOriginalGoose + 1]
  mov     [r12 + 1], al

end_compare:
  ret

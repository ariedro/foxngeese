extern system
extern strcpy
extern puts
global processMovement

%macro mPuts 0
  sub     rsp,8
  call    puts
  add     rsp,8
%endmacro

section .data
  letterW   db "w", 0
  letterA   db "a", 0
  letterS   db "s", 0
  letterD   db "d", 0
  posBoard  db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,3,  5,3,  6,3,  7,3,  1,4,  2,4,  3,4,  4,4,  5,4,  6,4,  7,4,  1,5,  2,5,  3,5,  4,5,  5,5,  6,5,  7,5, 3,6,  4,6,  5,6, 3,7,  4,7,  5,7

section .bss
  posOriginalFox     resb 2

section .text

processMovement:
  ; Input args:
  ; rdi -> posFox
  ; rsi -> text

  mov     al, byte [rdi]
  mov     [posOriginalFox], al
  mov     al, byte [rdi + 1]
  mov     [posOriginalFox + 1], al

  mov     bl, byte [rsi]
  mov     bh, byte [rsi + 1]

  cmp     bl, [letterW]
  jne     compareDiagSupRight
  cmp     bh, [letterA]
  je      isWA

compareDiagSupRight:
  cmp     bl, [letterW]
  jne     compareDiagInfLeft
  cmp     bh, [letterD]
  je      isWD

compareDiagInfLeft:
  cmp     bl, [letterS]
  jne     compareDiagInfRight
  cmp     bh, [letterA]
  je      isSA

compareDiagInfRight:
  cmp     bl, [letterS]
  jne     individualComparisons
  cmp     bh, [letterD]
  je      isSD

individualComparisons:
  cmp     bl, [letterW]
  je      isW

  cmp     bl, [letterA]
  je      isA

  cmp     bl, [letterS]
  je      isS

  cmp     bl, [letterD]
  je      isD

  jmp     verifyValidPosition

isW:
  mov     al, [rdi + 1]
  dec     al
  mov     [rdi + 1], al

  jmp     verifyValidPosition

isWA:
  mov     al, [rdi + 1]
  dec     al
  mov     [rdi + 1], al
  mov     al, [rdi]
  dec     al
  mov     [rdi], al

  jmp     verifyValidPosition

isWD:
  mov     al, [rdi + 1]
  dec     al
  mov     [rdi + 1], al
  mov     al, [rdi]
  inc     al
  mov     [rdi], al

  jmp     verifyValidPosition

isSA:
  mov     al, [rdi + 1]
  inc     al
  mov     [rdi + 1], al
  mov     al, [rdi]
  dec     al
  mov     [rdi], al

  jmp     verifyValidPosition

isSD:
  mov     al, [rdi + 1]
  inc     al
  mov     [rdi + 1], al
  mov     al, [rdi]
  inc     al
  mov     [rdi], al

  jmp     verifyValidPosition

isS:
  mov     al, [rdi + 1]
  inc     al
  mov     [rdi + 1], al
  
  jmp     verifyValidPosition

isA:
  mov     al, [rdi]
  dec     al
  mov     [rdi], al

  jmp     verifyValidPosition

isD:
  mov     al, [rdi]
  inc     al
  mov     [rdi], al

  jmp     verifyValidPosition

verifyValidPosition:
  mov     rax, rdi              ; save the new fox position
  mov     rbx, posBoard         ; load the base address of posBoard
  mov     rcx, 36               ; number of board elements

compare_loop:
  mov     dl, [rbx]             ; posBoard x
  mov     dh, [rbx + 1]         ; posBoard y
  cmp     dl, [rax]             ; compare with fox x
  jne     next
  cmp     dh, [rax + 1]         ; compare with fox y
  jne     next

  jmp     endComparison         ; matches, its a board position

next:
  add     rbx, 2                ; next pos on the board
  loop    compare_loop

  mov     al, [posOriginalFox]  ; none match, return to the original position
  mov     [rdi], al
  mov     al, [posOriginalFox + 1]
  mov     [rdi + 1], al

endComparison:
  ret

extern system
extern strcpy
extern puts
extern gets
global processMovementFox

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
  letterW         db "w", 0
  letterA         db "a", 0
  letterS         db "s", 0
  letterD         db "d", 0
  posBoard        db  3,1,  4,1,  5,1,  3,2,  4,2,  5,2,  1,3,  2,3,  3,3,  4,3,  5,3,  6,3,  7,3,  1,4,  2,4,  3,4,  4,4,  5,4,  6,4,  7,4,  1,5,  2,5,  3,5,  4,5,  5,5,  6,5,  7,5, 3,6,  4,6,  5,6, 3,7,  4,7,  5,7
  numGeese        equ 17 ; numbers of pairs of posGeese
  numBoard        equ 33 ; numbers of pairs of posBoard
  posFoxAux       db  0,0
  msgInChar       db  "[FOX'S TURN]",10,"Insert a character: ",0

section .bss
  posFoxOriginal  resb 2
  result          resb 1 ; result (0 = not found, 1 = found)
  gooseIndex      resb 1 ; index of the goose found
  keyInput        resb 500

section .text

processMovementFox:
  ; input:
  ; r12 -> posFox
  ; r13 -> posGeese

  mov     rdi,msgInChar
  mPuts
  mov     rdi,keyInput
  mGets
  mov     r8,r12
  mov     r9,r13

  xor     r10, r10       ; index/counter
  xor     r11, r11       ; result (0 = not found, 1 = found)
  xor     r12, r12       ; index of the goose found
  mov     r13, posFoxAux
  mov     byte [r13], 0
  mov     byte [r13+1], 0
  mov     byte [result], 0

  mov     al, byte [r8]
  mov     [posFoxOriginal], al
  mov     al, byte [r8 + 1]
  mov     [posFoxOriginal + 1], al

  mov     bl, byte [keyInput]
  mov     bh, byte [keyInput + 1]

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
  jne     compareIndividual
  cmp     bh, [letterD]
  je      isSD

compareIndividual:
  cmp     bl, [letterW]
  je      isW

  cmp     bl, [letterA]
  je      isA

  cmp     bl, [letterS]
  je      isS

  cmp     bl, [letterD]
  je      isD

  jmp     verifyGooseEaten

isW:
  mov     al, [r8 + 1]
  dec     al
  mov     [r8 + 1], al

  mov     al, [r13 + 1]
  dec     al
  mov     [r13 + 1], al

  jmp     verifyGooseEaten

isWA:
  mov     al, [r8 + 1]
  dec     al
  mov     [r8 + 1], al
  mov     al, [r8]
  dec     al
  mov     [r8], al

  mov     al, [r13 + 1]
  dec     al
  mov     [r13 + 1], al
  mov     al, [r13]
  dec     al
  mov     [r13], al

  jmp     verifyGooseEaten

isWD:
  mov     al, [r8 + 1]
  dec     al
  mov     [r8 + 1], al
  mov     al, [r8]
  inc     al
  mov     [r8], al

  mov     al, [r13 + 1]
  dec     al
  mov     [r13 + 1], al
  mov     al, [r13]
  inc     al
  mov     [r13], al

  jmp     verifyGooseEaten

isSA:
  mov     al, [r8 + 1]
  inc     al
  mov     [r8 + 1], al
  mov     al, [r8]
  dec     al
  mov     [r8], al

  mov     al, [r13 + 1]
  inc     al
  mov     [r13 + 1], al
  mov     al, [r13]
  dec     al
  mov     [r13], al

  jmp     verifyGooseEaten

isSD:
  mov     al, [r8 + 1]
  inc     al
  mov     [r8 + 1], al
  mov     al, [r8]
  inc     al
  mov     [r8], al

  mov     al, [r13 + 1]
  inc     al
  mov     [r13 + 1], al
  mov     al, [r13]
  inc     al
  mov     [r13], al

  jmp     verifyGooseEaten

isS:
  mov     al, [r8 + 1]
  inc     al
  mov     [r8 + 1], al
  
  mov     al, [r13 + 1]
  inc     al
  mov     [r13 + 1], al

  jmp     verifyGooseEaten

isA:
  mov     al, [r8]
  dec     al
  mov     [r8], al

  mov     al, [r13]
  dec     al
  mov     [r13], al

  jmp     verifyGooseEaten

isD:
  mov     al, [r8]
  inc     al
  mov     [r8], al

  mov     al, [r13]
  inc     al
  mov     [r13], al

  jmp     verifyGooseEaten

verifyGooseEaten:
  mov     rax, r8             ; save the new fox position
  mov     rbx, r9             ; load the base address of posGeese
  mov     rcx, 17             ; amount of geese

eat_goose_loop:
  cmp     r10, numGeese
  je      verifyValidPositionGoose

  mov     dl, [rbx]           ; posGeese x
  cmp     dl, [rax]           ; compare with fox x
  jne     next_goose_eat

  mov     dh, [rbx + 1]       ; posGeese y
  cmp     dh, [rax + 1]       ; compare with fox y
  jne     next_goose_eat

  jmp     pos_goose_equal      ; matches

next_goose_eat:
  add     rbx, 2               ; next position
  inc     r10
  jmp    eat_goose_loop

pos_goose_equal:
  ; add to posFox the auxiliary of sum in r13
  movzx   eax, byte [r8]     ; load posFox x in eax
  movzx   ebx, byte [r8+1]   ; load posFox y in ebx
  movzx   ecx, byte [r13]    ; load aux of sum x in ecx
  movzx   edx, byte [r13+1]  ; load aux of sum y in edx

  add     eax, ecx             ; sum x
  add     ebx, edx             ; sum y

  mov     [r8], al             ; save new posFox x
  mov     [r8+1], bl           ; save new posFox y

  mov     r11, 1
  mov     [result], r11
  mov     r12, r10
  mov     [gooseIndex], r12

verifyValidPositionGoose:
  mov     rax, r8             ; save the new fox position
  mov     rbx, r9             ; load the base address of posGeese
  mov     rcx, 17             ; amount of geese
  xor     r10, r10

verify_geese_loop:
  cmp     r10, numGeese
  je      verifyValidPositionBoard

  mov     dl, [rbx]           ; posGeese x
  cmp     dl, [rax]           ; compare with fox x
  jne     next_goose_compare

  mov     dh, [rbx + 1]       ; posGeese y
  cmp     dh, [rax + 1]       ; compare with fox y
  jne     next_goose_compare

  jmp     equals_on_compare   ; matches posGeese and posFox

next_goose_compare:
  add     rbx, 2              ; next goose
  inc     r10
  jmp     verify_geese_loop

equals_on_compare:
  mov     al, [posFoxOriginal]
  mov     [r8], al
  mov     al, [posFoxOriginal + 1]
  mov     [r8 + 1], al
  mov     byte [result], 0


verifyValidPositionBoard:
  mov     rax, r8            ; save the new fox position
  mov     rbx, posBoard      ; load the base address of posBoard
  mov     rcx, 33            ; amount of board elements
  xor     r10, r10

verify_board_loop:
  cmp     r10, numBoard
  je      return_original_position

  mov     dl, [rbx]           ; posBoard x
  cmp     dl, [rax]           ; compare with fox x
  jne     next_board_comparison

  mov     dh, [rbx + 1]       ; posBoard y
  cmp     dh, [rax + 1]       ; compare with fox y
  jne     next_board_comparison

  jmp     eat_goose           ; it matches, its a board position

next_board_comparison:
  add     rbx, 2              ; next board position
  inc     r10
  jmp     verify_board_loop

return_original_position:
  mov     al, [posFoxOriginal]
  mov     [r8], al
  mov     al, [posFoxOriginal + 1]
  mov     [r8 + 1], al
  mov     byte [result], 0

eat_goose:
  cmp     byte [result], 1
  jne     endComparison

  mov     r12, [gooseIndex]

  ; calculate the memory address of the coordinates of the goose
  mov     r13, r12        ; r13 -> goose index
  shl     r13, 1          ; multiply by 2 to get the offset
  lea     rdi, [r9 + r13] ; set it in rdi

  ; reeplace the goose cordinates with 0,0
  mov     byte [rdi], 0 
  mov     byte [rdi + 1], 0

endComparison:
  ret

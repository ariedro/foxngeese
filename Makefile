ASM_SRCS := $(wildcard *.asm)

all: foxngeese

foxngeese: $(ASM_SRCS:.asm=.o)
	gcc -no-pie -o $@ $^

%.o: %.asm
	nasm -f elf64 -g -F dwarf -o $@ $<

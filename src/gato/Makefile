build: 
	nasm -f elf gato.asm
	ld -m elf_i386 gato.o -o ../../bin/gato.exe ../../lib/libpc_io.a
run:
	./../../bin/gato.exe
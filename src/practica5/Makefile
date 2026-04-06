build: 
	nasm -f elf p5.asm
	ld -m elf_i386 p5.o -o ../../bin/practica5.exe ../../lib/libpc_io.a

	nasm -f elf p5a.asm
	ld -m elf_i386 p5a.o -o ../../bin/practica5a.exe ../../lib/libpc_io.a

	nasm -f elf p5b.asm
	ld -m elf_i386 p5b.o -o ../../bin/practica5b.exe ../../lib/libpc_io.a
run: 
	./../../bin/practica5.exe
	./../../bin/practica5a.exe
	./../../bin/practica5b.exe


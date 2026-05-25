build: 
	gcc -m32 -c Main.c
	nasm -f elf p10.asm
	gcc -m32 Main.o p10.o -no-pie -z noexecstack -o ../../bin/practica10.exe
run:
	./../../bin/practica10.exe
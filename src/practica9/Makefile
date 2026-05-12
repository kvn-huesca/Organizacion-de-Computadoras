build: 
	gcc -m32 -c Main.c
	nasm -f elf p9.asm
	gcc -m32 Main.o p9.o -no-pie -z noexecstack -o ../../bin/practica9.exe
run:
	./../../bin/practica9.exe
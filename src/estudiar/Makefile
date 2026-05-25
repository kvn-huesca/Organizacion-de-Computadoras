# build: 
# 	nasm -f elf pruebas2.asm
# 	ld -m elf_i386 pruebas2.o -o ../../bin/pruebas2.exe ../../lib/libpc_io.a
# run:
# 	./../../bin/pruebas2.exe

build: 
	gcc -m32 -c pruebasC.c
	nasm -f elf pruebas.asm
	gcc -m32 pruebasC.o pruebas.o -no-pie -z noexecstack -o ../../bin/pruebas.exe
run:
	./../../bin/pruebas.exe
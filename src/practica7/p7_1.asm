%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ; referencia para inicio de programa
	
_start:
    mov edx,ncad            ; edx contiene direccion de ncad
    call puts               ; se imprime ncad

    mov bl,byte[len]        ; bx contiene el tamaño max de la cadena = 64
    mov edx,cad             ; edx contiene la direccion de cad
    call capturar           ; llamar subrutina capturar

    mov al,[nlin]           ; AL contiene una varaible con salto de linea (0xa) declarado en section .data
    call putchar

    mov edx, cad
    call atoi                ;mov eax, -123
    mov edx, cad
    call itoa

    mov al,[nlin]  
    call puts

    call putchar
    call putchar

    mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    itoa:
        push esi
        push edx
        push ecx

        mov dword[base], 1
        mov esi, edx
        mov ecx, 10
        
        cmp eax, 0
        jl .negativo
        cmp eax, 0
        jge .encontrar_base

        .negativo:
            neg eax
            mov byte[esi], '-'
            add esi, 1
            
        .encontrar_base:
            mov ebx, eax
            mov dword[temp], ebx
            
            .empezar:
                cmp ebx, 10
                jge .multiplicar_dividir
                jmp .llenar_cadena

                .multiplicar_dividir:
                    xor edx, edx
                    mov eax, ebx
                    div ecx
                    mov ebx, eax

                    xor edx, edx
                    mov eax, dword[base]
                    imul eax, ecx
                    mov dword[base], eax
                    jmp .empezar
                 
        .llenar_cadena:
            mov ebx,dword[temp]
                .do_while:
                    xor edx, edx
                    mov ecx, 10
                    mov eax, ebx
                    div dword[base]
                    mov ebx, edx

                    add eax, '0'
                    mov byte[esi], al
                    mov eax, dword[base]
                    xor edx, edx
                    div ecx
                    mov dword[base], eax

                    add esi, 1

                    cmp dword[base], 0
                    jg .do_while

            mov [esi], 0
    .salir:
        pop ecx
        pop edx
        pop esi
        ret




    atoi:
        push esi

        mov dword[signo], 1
        mov dword[numero_entero], 0

        mov eax, 0
        mov esi, edx
        .saltar_espacios:
            cmp byte[esi], ' '
            je .continue
            cmp byte[esi], 0x09
            je .continue

            jmp .verificar_signo
            .continue:
                add esi, 1
                jmp .saltar_espacios

        .verificar_signo:
            cmp byte[esi], '-'
            je .negativo
            cmp byte[esi], '+'
            je .positivo
            jmp .while

            .negativo:
                add esi, 1
                mov dword[signo],-1
                jmp .while
        .positivo: 
            add esi, 1
            mov dword[signo], 1

        .while:
            cmp byte[esi], '0'
            jge .es_mayor
            jmp .salir

            .es_mayor:
            cmp byte[esi], '9'
            jle .multiplicar
            jmp .salir
            
            .multiplicar:
                xor eax,eax
                xor ebx,ebx

                mov al, byte[esi]
                sub al, '0'
                mov bl, al
                
                mov eax, dword[numero_entero]
                imul eax, 10
                add eax, ebx
                mov dword[numero_entero],eax
                add esi, 1
                jmp .while

    .salir:
        xor ebx, ebx
        mov eax, dword[numero_entero]
        cmp dword[signo], -1
        jne .numero_positivo
        neg eax
        jmp .numero_positivo

        .numero_positivo:

        pop esi
        ret



    capturar:
        push edx
        push cx
        mov cx,bx
        dec cx
        .ciclo: 
            call getch
            cmp al,127
            jne .guardar
            cmp edx, cad
            je .ciclo
            call borrar
            jmp .ciclo
       .guardar:
            call putchar
            mov [edx],al
            cmp al,0xa
            je .salir
            inc edx
            loop .ciclo

    .salir:
        mov byte[edx],0
        pop cx
        pop edx
        ret


    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        dec edx
        inc cx
        ret 
    




section	.data
    ;variables atoi
    numero_entero dd 0
    digito db 0
    temp dd 0


   
    ;variables compartidas atoi e itoa
    base dd 10
    signo dd 1

    ;variables generales
    ncad db 0xa,'Cadena: ',0
    nlin db 0xa
    len db 32
    cad	times 32 db 0
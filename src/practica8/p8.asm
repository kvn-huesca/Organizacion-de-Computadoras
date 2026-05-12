%include "../../lib/pc_io.inc"  ;libreria

section	.text
	global _start       ;referencia para inicio de programa
    global _capturarArreglo
    global _imprimirArreglo
    global _ordenarArreglo
    global _atoi
    global _itoa
    global _capturar

    _start:
    
        push texto1
        push [len]
        push arregloE
        call _capturarArreglo
        add esp, 12

        call salto

        push [len]
        push arregloE
        call _imprimirArreglo
        add esp, 8

        call salto

        push [len]
        push arregloE
        call _ordenarArreglo
        add esp, 8

        call salto

        push [len]
        push arregloE
        call _imprimirArreglo
        add esp, 8

        call salto
        
        mov eax, 1
        int 0x80

    _ordenarArreglo:        ;parametros direccion de cadena de enteros y tamaño de la cadena 
        push ebp
        mov ebp, esp
        sub esp, 12

        push edx
        push ebx
        push ecx
        push esi
        push edi

        mov ecx, [ebp + 12]
        sub ecx, 2                  ;i hasta tamaño - 2

        mov esi, [ebp + 8]          ;i = 0
        

        .for:
            mov dword[ebp - 4], ecx

            mov ecx, dword[ebp + 12]

            mov ebx, esi     ;minimo = i
            mov edi, esi     ;j = i
            .for2:
                mov eax, dword[edi]
                cmp eax, dword[ebx]
                jl .cuerpo
                jmp .continuar

                .cuerpo:
                    mov ebx, edi
                .continuar:
                 add edi, 4       ;j = i + 1
            loop .for2

            cmp ebx, esi 
            jne .intercambiar
            jmp .seguir

            .intercambiar:
                mov edx, dword[esi]
                mov eax, dword[ebx]
                mov dword[esi], eax
                mov dword[ebx], edx 
                mov eax, 0
                mov edx, 0

            .seguir:
            add esi, 4
            mov ecx, dword[ebp - 4]
        loop .for

        pop edi
        pop esi
        pop ecx
        pop ebx
        pop edx

        mov esp,ebp
        pop ebp
        ret


    _imprimirArreglo:       ;parametros direccion de cadena de enteros y tamaño de la cadena 
        push ebp
        mov ebp, esp
        sub esp, 32

        mov esi, [ebp + 8]
        mov ecx, [ebp + 12]
        .for:
            mov eax, dword[esi]
            lea edi, [ebp - 32] 

            push eax
            push edi
            call _itoa
            add esp, 8

            lea edx, [ebp - 32]
            call puts

            xor eax, eax
            mov al, 0x9
            call putchar

            add esi, 4
        loop .for

        mov esp, ebp
        pop ebp
        ret
    _capturarArreglo:       ;parametros direccion de cadena de enteros, tamaño de la cadena
        push ebp
        mov ebp, esp
        sub esp, 32      ;ebp-32 = numero entero     

        push esi
        push ecx
        push edi
        push eax
        push edx 

        mov esi, [ebp + 8]      ;direccion del arreglo de enteros
        mov ecx, [ebp + 12]     ;tamaño del arreglo de enteros
        mov edx, [ebp + 16]     ;direccion de texto1

        lea edi, [ebp - 32]
        .for: 
            call puts
            push dword 11
            push edi
            call _capturar
            add esp, 8

            push edi
            call _atoi
            add esp, 4 

            mov dword[esi], eax

            add esi, 4
            loop .for


        .salir:
            pop edx 
            pop eax
            pop edi
            pop ecx
            pop esi
            mov esp, ebp
            pop ebp
            ret
    _itoa:                  ;parametros direccion de cadena y eax
        push ebp
        mov ebp, esp
        sub esp, 8      ;ebp-4 = base   ebp-8 = temp

        push esi
        push ecx
        push edx
        push ebx

        mov dword[ebp - 4], 1
        mov esi, [ebp + 8]
        mov eax, [ebp + 12]
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
            mov dword[ebp - 8], ebx
            
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
                    mov eax, dword[ebp - 4]
                    imul eax, ecx
                    mov dword[ebp - 4], eax
                    jmp .empezar
                 
        .llenar_cadena:
            mov ebx,dword[ebp - 8]
                .do_while:
                    xor edx, edx
                    mov ecx, 10
                    mov eax, ebx
                    div dword[ebp - 4]
                    mov ebx, edx

                    add eax, '0'
                    mov byte[esi], al
                    mov eax, dword[ebp - 4]
                    xor edx, edx
                    div ecx
                    mov dword[ebp - 4], eax

                    add esi, 1

                    cmp dword[ebp - 4], 0
                    jg .do_while

            mov [esi], 0
        .salir:
            xor eax, eax
        
            pop ebx
            pop edx
            pop ecx
            pop esi
            mov esp, ebp
            pop ebp
            ret   
    _atoi:                  ;parametros direccion de cadena
        push ebp
        mov ebp, esp
        sub esp, 8      ;ebp-4 = signo;    ebp-8 = numero 

        push esi
        push ebx

        mov dword[ebp - 4], 1
        mov dword[ebp - 8], 0

        mov eax, 0
        mov esi, [ebp + 8]

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
                mov dword[ebp - 4],-1
                jmp .while
            .positivo: 
                add esi, 1
                mov dword[ebp - 4], 1

        .while:
            cmp byte[esi], '0'
            jge .es_mayor
            jmp .pre_salida

            .es_mayor:
                cmp byte[esi], '9'
                jle .multiplicar
                jmp .pre_salida
            
            .multiplicar:
                xor eax,eax
                xor ebx,ebx

                mov al, byte[esi]
                sub al, '0'
                mov bl, al
                
                mov eax, dword[ebp - 8]
                imul eax, 10
                add eax, ebx
                mov dword[ebp - 8],eax
                add esi, 1
                jmp .while

        .pre_salida:
            xor ebx, ebx
            mov eax, dword[ebp - 8]
            cmp dword[ebp - 4], -1
            jne .salir
            neg eax

            .salir:
                pop ebx
                pop esi
                mov esp, ebp
                pop ebp
                ret



    _capturar:              ;parametros direccion de cadena y tamaño de cadena
        push ebp
        mov ebp, esp
        sub esp, 4

        push eax
        push edx
        push cx 

        mov edx, [ebp + 8]
        mov cx, [ebp + 12]
        dec cx
        .ciclo:
            call getch
            cmp al, 127     
            jne .guardar    
            cmp edx, [ebp + 8]    
            je .ciclo

            call borrar
            jmp .ciclo
        .guardar:
            call putchar
            mov byte[edx], al
            cmp al, 0xa
            je .salir
            inc edx
            loop .ciclo
        .salir:
            mov byte[edx], 0
            pop cx
            pop edx
            pop eax
            mov esp, ebp
            pop ebp
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

    salto:
        push eax
        xor eax, eax
        mov al, byte[sdl]
        call putchar
        pop eax
        ret


section .data
    arregloE times 5 dd 0
    len dd 5
    texto1 db 0xa, 'Captura: ',0
    sdl db 0xa
%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ; referencia para inicio de programa
    global _capturar    ; referencia del procedimiento capturar
    global _atoi        ; referencia del procedimiento atoi
    global _itoa
	
_start:
    mov edx,ncad            ; edx contiene direccion de ncad
    call puts               ; se imprime ncad

    movzx eax, byte[len]
    push eax                ; segundo parametro
    push cad                ; primer parametro
    call _capturar          ; llamar procedimiento capturar
    add esp,8

    mov al,[nlin]           ; AL contiene una varaible con salto de linea (0xa) declarado en section .data
    call putchar

    push cad                ;primer parametro
    call _atoi
    add esp,4

    push eax
    push cad
    call _itoa
    add esp,8

    mov edx, cad
    call puts

    mov al,[nlin]
    call putchar
    

    mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    _itoa:
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

    _atoi:          ;parameetros direccion de cadena
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



    _capturar:      ;parametros direccion de cadena y tamaño de cadena
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
    
section	.data
    ;variables generales
    ncad db 0xa,'Cadena: ',0
    nlin db 0xa
    len db 32
    cad	times 32 db 0
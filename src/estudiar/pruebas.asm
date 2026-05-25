section .text
    global primos
    global sumatoria
    global maximo

    maximo:
    push ebp
    mov ebp, esp

    push edi
    push esi
    push ecx

    mov edi, dword[ebp + 8]
    mov esi, 0

    mov eax, dword[edi + esi*4]
    .for:
        cmp esi, dword[ebp + 12]
        je .fin_for
        mov ecx, esi
        .for2:
            cmp ecx, dword[ebp + 12]
            je .fin_for2
            cmp dword[edi + ecx*4], eax
            jg .nuevo_maximo
            inc ecx
            jmp .for2

            .nuevo_maximo:
                mov eax, dword[edi + ecx*4]
                inc ecx
                jmp .for2
            .fin_for2:
            inc esi
            jmp .for
    .fin_for:

    pop ecx
    pop esi
    pop edi

    mov esp, ebp
    pop ebp
    ret

    sumatoria:
        push ebp
        mov ebp, esp

        push ebx
        push esi
        
        mov ebx, dword[ebp + 8]
        mov esi, 0
        mov eax, 0

        .ciclo:
        cmp esi, dword[ebp + 12]
        je .salir
        cmp dword[ebx + esi*4], 0
        jl .sumar
        inc esi
        jmp .ciclo

        .sumar:
        add eax, dword[ebx + esi*4]
        inc esi
        jmp .ciclo

        .salir:

        pop esi
        pop ebx

        mov esp, ebp
        pop ebp
        ret

    primos:
        push ebp
        mov ebp, esp
        
        push edx
        push ecx
        push ebx

        mov ebx, dword[ebp + 8]

        cmp ebx, 2
        je .es_primo
        cmp ebx, 1
        jle .no_es_primo

        mov edx, 0
        mov eax, ebx
        mov ecx, 2

        div ecx

        cmp edx, 0
        je .no_es_primo

        mov ecx, 3
        .bucle:
        mov edx, 0
        mov eax, ecx
        mul eax

        cmp eax, ebx
        jg .es_primo

        mov edx, 0 
        mov eax, ebx
        div ecx

        cmp edx, 0
        je .no_es_primo

        add ecx, 2
        jmp .bucle

        .no_es_primo:
        mov eax, 0
        jmp .salir

        .es_primo:
        mov eax, 1
        jmp .salir

        .salir:
        pop ebx
        pop ecx
        pop edx
        mov esp, ebp
        pop ebp
        ret






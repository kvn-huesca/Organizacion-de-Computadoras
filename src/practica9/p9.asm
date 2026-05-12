
    %macro FOR 2 
        push ecx 
        mov ecx,%1 
        %%bucle: 
            call %2 
            
        loop %%bucle 
        pop ecx 
    %endmacro 

section .text 

    global sumatoria 
    global maximo
    global minimo

    minimo:
        push ebp
        mov ebp, esp

        push esi

        mov esi, dword[ebp + 8]         ;direccion de arreglo de enteros 
        mov ecx, dword[ebp + 12]        ;longitud del arreglo de enteros 
        sub ecx, 1
        xor eax, eax

        mov eax, dword[esi]
        add esi, 4
        FOR ecx, compararMin

        pop esi

        mov esp, ebp
        pop ebp
        ret

    compararMin:
        cmp eax, dword[esi]
        jle .continuar
        jg .actualizarMinimo

        .actualizarMinimo:
            mov eax, dword[esi]

        .continuar:
            add esi, 4
        ret


    maximo:
        push ebp
        mov ebp, esp

        push esi

        mov esi, dword[ebp + 8]         ;direccion de arreglo de enteros 
        mov ecx, dword[ebp + 12]        ;longitud del arreglo de enteros 
        sub ecx, 1
        xor eax, eax

        mov eax, dword[esi]
        add esi, 4
        FOR ecx, compararMax

        pop esi
        mov esp, ebp
        pop ebp
        ret

    compararMax:
        cmp eax, dword[esi]
        jge .continuar
        jl .actualizarMaximo

        .actualizarMaximo:
            mov eax, dword[esi]

        .continuar:
            add esi, 4
        ret

    sumatoria: 
        push ebp 
        mov ebp, esp 

        push esi 
        
        mov esi, dword[ebp + 8]         ;direccion de arreglo de enteros 
        mov ecx, dword[ebp + 12]        ;longitud del arreglo de enteros 
        xor eax, eax                    ;limpiar registro eax 
        
        FOR ecx, sumar 
        
        pop esi 
        mov esp, ebp 
        pop ebp 
        ret

    sumar: 
        add eax, dword[esi] 
        add esi, 4 
        ret 
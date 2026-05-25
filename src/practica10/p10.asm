section .text
    global set_bit
    global get_bit

    get_bit:
    push ebp
    mov ebp, esp

    push ecx

    xor eax, eax

    mov eax, dword[ebp + 8]
    mov cl, byte[ebp + 12]

    shr eax, cl
    and eax, 1
    
    pop ecx
    mov esp, ebp
    pop ebp
    ret

    set_bit:
        push ebp
        mov ebp, esp    

        push eax
        push edi
        push ecx

        xor eax, eax

        mov al, 0
        mov edi, dword[ebp + 8]
        mov cl, byte[ebp + 12]

        mov al, 1
        shl eax, cl
        or byte[edi], al

        pop ecx
        pop edi
        pop eax

        mov esp, ebp
        pop ebp
        ret

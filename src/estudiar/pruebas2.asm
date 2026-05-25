%include "../../lib/pc_io.inc"  

section .text
    global imprimirBinario

_start:
    
    push dword[cant]
    push dword[numero]
    call imprimirBinario
    add esp, 8

    mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa



    imprimirBinario:
    push ebp
    mov ebp, esp

    mov cl, byte[ebp + 12]
    .ciclo:
        cmp cl, 0
        je .fin

        mov eax, dword[ebp + 8]
        shr eax, cl
        jc .uno

        mov eax, 0
        add eax, '0'
        call putchar
        dec cl
        jmp .ciclo

        .uno:
        mov eax, 1
        add eax, '0'
        call putchar
        dec cl
        jmp .ciclo
        
        ; mov eax, 0
        ; adc al, '0'
        ; call putchar
        ; dec cl
        ; jmp .ciclo

        .fin:

    mov esp, ebp
    pop ebp
    ret

section .data

    numero dd 24
    cant dd 8
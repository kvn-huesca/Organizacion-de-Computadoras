%include "../../lib/pc_io.inc"
global _start
section .data
    tablero: db '0','1','2','3','4','5','6','7','8'
    error: db 27, "[31m", "INGRESE POSICION VALIDA", 27, "[0m", 0
    cada: db "TURNO JUGADOR X",0x0
    cadb: db "TURNO JUGADOR O",0x0
    ganador: db "VICTORIA AL JUGADOR ",0x0
    empate: db "EMPATE",0x0
    pos: db "POSICION OCUPADA",0x0
    rojo:  db 27, "[31m", 0    ; 31m es el código para texto rojo
    azul:  db 27, "[34m", 0    ; 34m es el código para texto azul
    reset: db 27, "[0m", 0     ; 0m es VITAL para regresar al color original

section .bss
    buffer: resb 50
    termino: resb 1

 section .text
 _start:
    mov esi,0
    mov byte[termino],0
    .ciclo:
    cmp esi,9
    je .a
    mov byte[tablero+esi],' '
    inc esi
    jmp .ciclo

    .a:
    call funcion
    call imptablero
    mov eax,1
    mov ebx, 1
    int 80h

    funcion:
    mov edi,0

    .funa:
    call imptablero
    mov edx,cada
    cmp edi,9
    je .fin
    call puts
    inc edi
    mov eax,0
    call salto
    call getche
    sub al,'0'
    call comprobar
    movzx eax,al
    mov byte[tablero+eax],'X'
    mov al,'X'
    call ganarF
    call ganarC
    call ganarD
    cmp byte[termino],1
    je .fina
    jmp .funb

    .funb:
    call imptablero
    mov edx,cadb
    cmp edi,9
    je .fin
    call puts
    inc edi
    mov eax,0
    call salto
    call getche
    sub al,'0'
    call comprobar
    movzx eax,al
    mov byte[tablero+eax],'O'
    mov al,'O'
    call ganarF
    call ganarC
    call ganarD
    cmp byte[termino],1
    je .finb
    jmp .funa

    .fina:
    mov edx,ganador
    call salto
    call puts
    call putchar
    ret

    .finb:
    mov edx,ganador
    call salto
    call puts
    call putchar
    ret

    .fin:
    mov edx,empate
    call salto
    call puts
    ret

    imptablero:
    mov esi,0
    call salto
    call bordes
    .fun:
    cmp esi,3
    je .salto
    cmp esi,6
    je .salto
    cmp esi,9
    je .salto
    mov al,'|'
    call putchar
    mov al,byte[tablero+esi]
    call putchar
    inc esi
    jmp .fun

    .salto:
    cmp esi,9
    je .fin
    call salto
    mov al,'|'
    call putchar
    mov al,byte[tablero+esi]
    call putchar
    inc esi
    jmp .fun

    .fin:
    call salto
    call bordes
    ret


    bordes:
    push esi
    mov esi,0
    .fun:
    cmp esi,8
    je .fin
    mov al,'-'
    call putchar
    inc esi
    jmp .fun

    .fin:
    call salto
    pop esi
    ret

    comprobar:
    push edx
    mov edx,error
    .mayor:
    cmp al,0
    jge .menor
    call puts
    call salto
    call getche
    sub al,'0'
    jmp .mayor

    .menor:
    cmp al,8
    jle .ciclo
    call puts
    call salto
    call getche
    sub al,'0'
    jmp .mayor

     .ciclo:
    movzx eax,al
    cmp byte[tablero+eax],'O'
    je .sig
    cmp byte[tablero+eax],'X'
    je .sig
    pop edx
    ret

    .sig:
    mov edx,pos
    call puts
    call salto
    call getche
    sub al,'0'
    jmp .mayor

    ganarF:
    pushad
    mov esi,0
    mov ecx,3

    .fila:
    cmp byte[tablero+esi],al
    jne .sig_linea

    cmp byte[tablero+esi+1],al
    jne .sig_linea

    cmp byte[tablero+esi+2],al
    jne .sig_linea

    mov byte[termino],1
    popad
    ret

    .sig_linea:
    add esi,3
    loop .fila

    popad
    ret

    ganarC:
    pushad
    mov esi,0
    mov ecx,3

    .ciclo:
     cmp byte[tablero+esi],al
    jne .sig
    cmp byte[tablero+esi+3],al
    jne .sig
    cmp byte[tablero+esi+6],al
    jne .sig
    popad
    mov byte[termino],1
    ret
    .sig:
    inc esi
    loop .ciclo
    popad
    ret

     ganarD:
       pushad
    mov esi,0

    .ciclo:
    cmp byte[tablero+esi],al
    jne .sig
    cmp byte[tablero+4],al
    jne .sig
    cmp byte[tablero+8],al
    jne .sig
    popad
    mov byte[termino],1
    ret

    .sig:
    cmp byte[tablero+2],al
    jne .fin
    cmp byte[tablero+4],al
    jne .fin
    cmp byte[tablero+6],al
    jne .fin
    popad
    mov byte[termino],1
    ret

    .fin:
    popad
    ret

salto:
    pushad
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    popad
    ret
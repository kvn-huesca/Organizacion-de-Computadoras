%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ; referencia para inicio de programa
	
_start:
    mov edx,ncad            ; edx contiene direccion de ncad
    call puts               ; se imprime ncad

    mov bx,word[len]        ; bx contiene el tamaño max de la cadena = 64
    mov edx,cad             ; edx contiene la direccion de cad
    call capturar           ; llamar subrutina capturar

    mov al,[nlin]           ; AL contiene una varaible con salto de linea (0xa) declarado en section .data
    call putchar            ; se imprime el salto de linea
    call puts               ; se imprime la cad modificada

    call putchar
    call putchar

    mov eax,123
    call itoa
    mov al,[nlin]
    call putchar
    call puts

    mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    atoi:
        push edx
        push cx
        mov cx,bx

        .ciclo:

        .saltar:
            inc edx
            loop .ciclo
    .salir:
        pop cx
        pop edx
        ret


    itoa:
        push eax
        push edx
        push ecx

        mov dword[max_div], 1000000000 ;
        mov ecx, edx

        cmp eax, 0
        jl .marcar_negativo_en_cadena
        mov [numero_entero], eax
        jmp .buscar_base
        
        .marcar_negativo_en_cadena:
            mov byte[ecx], '-'
            inc ecx
            call valorAbsoluto      
            mov [numero_entero], eax

        .buscar_base:
            mov eax,dword[numero_entero]
            cmp eax, 0
            je .numero_entero_cero
            .while:
                xor edx, edx ; limpiar registro edx
                mov eax, dword[numero_entero] ;eax = numero_entero
                div dword[max_div] ; eax = cociente , edx = residuo 

                ;si eax != 0 terminara el ciclo while
                cmp eax,0
                jne .fin_while

                xor edx, edx
                mov eax, dword[max_div] ; eax = div = 1,000,000,000
                div dword[base] ; eax / (base = 10)
                mov dword[max_div],eax ;  div = eax = (div / base)
                jmp .while ; volver a dividir

            .fin_while:

            .do_while:
                xor edx, edx
                mov eax, dword[numero_entero]
                div dword[max_div]

                mov dword[cociente], eax
                mov dword[residuo], edx

                call valorAbsoluto ; valorAbsoluto(eax = cociente)
                add eax, '0'
                mov [ecx], al
                inc ecx

                mov eax, dword[residuo]
                call valorAbsoluto ; valorAbsoluto(eax = residuo)
                mov dword[numero_entero], eax

                xor edx,edx
                mov eax,dword[max_div]
                div dword[base]
                mov dword[max_div], eax ; div = eax = div/base

                cmp dword[numero_entero], 0
                jg .do_while ; regresa a do_while si numero_entero < 0 
                ; si no salir
                cmp dword[max_div], 0
                jle .salir

                mov byte[ecx], '0'
                inc ecx
                jmp .salir

            .numero_entero_cero:
                mov byte[ecx], '0'
                inc ecx
    .salir:
        mov byte[ecx], 0
        pop ecx
        pop edx
        pop eax
        ret

    valorAbsoluto:
        cmp eax, 0
        jl .convertir_a_positivo
        jmp .salir
        
        .convertir_a_positivo:
            neg eax

    .salir:
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
    cociente dd 0
    residuo dd 0
    numero_entero dd 0
    max_div dd 1000000000
    base dd 10
    signo db 1
    ncad db 0xa,'Cadena: ',0
    nlin db 0xa
    len db 64
    cad	times 64 db 0
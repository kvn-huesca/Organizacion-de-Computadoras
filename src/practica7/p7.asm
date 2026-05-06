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
    call itoa

    mov al,[nlin]  
    call puts

    call putchar
    call putchar

    mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    atoi:
        push ebx
        push edx
        push cx

        mov cx,bx
        mov ebx, edx

        .saltar_espacios:
            cmp byte[ebx],' '
            je .espacio
            cmp byte[ebx],0x09
            jne .parar

            .espacio:
            add ebx,1
            jmp .saltar_espacios
        .parar:

        cmp byte[ebx], '-'
        je .incrementar_cadena
        jmp .guardar_direccion

        .incrementar_cadena:
            add ebx, 1
            mov byte[signo], -1

        .guardar_direccion:
            mov edx, ebx

        .tamaño_cadena:
            cmp byte[ebx], 0 ; si ebx != 0
            je .fin_tamaño_cadena
            cmp byte[ebx], ' '
            je .saltar
            cmp byte[ebx], '0'
            jl .fin_tamaño_cadena
            cmp byte[ebx], '9'
            jg .fin_tamaño_cadena

            ; si no
            add byte[cant],1
            .saltar:
            inc ebx
            loop .tamaño_cadena

        .fin_tamaño_cadena:
        mov ebx, edx
        cmp byte[ebx], '-'
        je .incrementar
        jmp .no_incrementar

        .incrementar:
            add ebx, 1
        .no_incrementar:

        xor edx, edx
        xor cx, cx ;limpiar registro cx=0
        mov cl, byte[cant] ; cl = cant
        sub cl,1 ; cl = cant -1
        mov dword[numero_entero],0
        mov dword[base], 10
        mov dword[max_mul], 1
        .multiplicacion:
            mov eax, dword[max_mul] ;eax = max_mul = 1
            mul dword[base] ; eax * (base = 10)
            mov dword[max_mul], eax
        loop .multiplicacion

        mov dword[numero_entero],0
        xor eax, eax
        xor cx, cx
        mov cl, byte[len] 
        .for:
            xor edx, edx ;limpiar registro edx en cada vuelta
            cmp byte[ebx], 0
            je .fin_for

            cmp byte[ebx], '0'
            jl .fin_for
            cmp byte[ebx], '9'
            jg .fin_for

            xor eax, eax
            mov al, byte[ebx]
            sub eax, '0'
            mul dword[max_mul]
            add dword[numero_entero], eax

            xor edx, edx
            mov eax, dword[max_mul]
            div dword[base]
            mov dword[max_mul], eax

            inc ebx
            loop .for

        .fin_for:
       mov eax, dword[numero_entero]
       cmp byte[signo], -1
       jne .salir
       neg eax
       mov dword[numero_entero], eax
    .salir:
        mov eax, dword[numero_entero]
        pop cx
        pop edx
        pop ebx
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
    ;variables atoi
    cant db 0
    max_mul dd 1


    ;variables itoa
    cociente dd 0
    residuo dd 0
    numero_entero dd 0
    max_div dd 1000000000
    
    ;variables compartidas atoi e itoa
    base dd 10
    signo db 1

    ;variables generales
    ncad db 0xa,'Cadena: ',0
    nlin db 0xa
    len db 32
    cad	times 32 db 0
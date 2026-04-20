%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   

    mov edx,ncad
    call puts

    mov bx,word[len]
    mov edx,cad
    call capturar
    mov al,[nlin]
    call putchar
    call puts

    mov al,[nlin]
    call putchar
    call putchar

    mov edx,cad
    call mayusculas
    mov al,[nlin]
    call putchar
    call puts

    mov al,[nlin]
    call putchar
    call putchar

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    minusculas:
        push edx
        push cx
        mov cx,bx
    .ciclo2:
        cmp byte[edx],0
        je .fin1

        cmp byte[edx],65
        jl .siguiente1

        cmp byte[edx],90
        jg .siguiente1

        add byte[edx], 32
    .siguiente1:
        inc edx
        loop .ciclo2

    .fin1:
        pop cx
        pop edx
        ret

    mayusculas:
        push edx
        push cx
        mov cx,bx
    .ciclo1:
        cmp byte[edx],0
        je .fin

        cmp byte[edx],97
        jl .siguiente

        cmp byte[edx],122
        jg .siguiente

        sub byte[edx], 32
    .siguiente:
        inc edx
        loop .ciclo1

    .fin:
        pop cx
        pop edx
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

    itoa:
        push bx
        mov bl,100
        mov ah,0
        div bl
        mov bx,ax
        add al,'0'
        call putchar
        mov al,ah
        add al,'0'
        call putchar

        pop bx
        ret

section	.data
    ncad db 0xa,'Cadena: ',0
    nlin db 0xa
    len db 64
    cad	times 64 db 0

%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
									; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

    mov eax, msg
    mov ebx, 9
    mov byte [eax + ebx * 2 + 1], '%'  ;REGISTRO (eax) + INDICE (ebx = 19) * escala. Cambia 't' por '%'

    mov edx, msg        ; volver a apuntar a msg
    call puts

    mov ebx, 0
	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section	.data
    msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',0xa,0 


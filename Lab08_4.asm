.MODEL SMALL
.STACK 100H
.DATA
    MSG DB "Numero em hexadecimal: $"
    HEX_DIGITS DB "0123456789ABCDEF$"

.CODE 

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX

    ; Exibir mensagem inicial
    MOV AH, 9
    LEA DX, MSG
    INT 21H

    MOV BX, 0E47Ah            ; Número hexadecimal a ser impresso
    MOV CX, 4                 ; Contador para 4 dígitos hexadecimais

IMPRIMIR:
    ; Mover 4 bits de BH para DL
    MOV DL, BH
    SHR DL, 4                 ; Desloca DL 4 bits para a direita

    ; Converter DL para caractere
    CMP DL, 10
    JB A_TO_9
    ADD DL, 'A' - 10          ; Converte para 'A'-'F'
    JMP PRINT

A_TO_9:
    ADD DL, '0'               ; Converte para '0'-'9'

PRINT:
    ; Imprimir o caractere
    MOV AH, 2                 ; Função para imprimir caractere
    INT 21H

    ; Rotaciona BX à esquerda
    SHL BX, 4
    LOOP IMPRIMIR             ; Decrementa CX e repete se não for zero

    ; Termina o programa
    MOV AX, 4C00H
    INT 21H

MAIN ENDP 
END MAIN

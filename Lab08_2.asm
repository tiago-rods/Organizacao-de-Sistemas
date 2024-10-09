.MODEL SMALL
.STACK 100H
.DATA
    MSG DB "Numero em binario: $"
    ZERO DB '0', '$'
    ONE DB '1', '$'

.CODE 

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX

    ; Exibir mensagem inicial
    MOV AH, 9
    LEA DX, MSG
    INT 21H
    
    MOV BX, 0EBFAh           

    ; Loop para imprimir 16 bits
    MOV CX, 16           ; Contador para 16 bits

IMPRIMIR:
    ; Rotação de BX à esquerda
    ROL BX, 1           ; Rotaciona BX à esquerda (MSB vai para CF)

    ; Verifica o Carry Flag (CF)
    JNC CARRY_ZERO   ; Se CF é 0, imprime '0'
    ; Se CF é 1, imprime '1'
    MOV DX, OFFSET ONE
    JMP SAIDA

CARRY_ZERO:
    MOV DX, OFFSET ZERO

SAIDA:
    ; Imprimir o caractere
    MOV AH, 9
    INT 21H

    LOOP IMPRIMIR       ; Decrementa CX e repete se não for zero

    ; Termina o programa
    MOV AX, 4CH
    INT 21H

MAIN ENDP 
END MAIN

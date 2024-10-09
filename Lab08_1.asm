.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB "Digite um número em binario: $"

.CODE 

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX          ; Limpa BX
    MOV CX, 16         ; Inicializa contador de bits

    ; Exibir mensagem
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    ; Lê caracteres
    MOV AH, 1
    INT 21H ; Lê um caractere
    
LEITURA:
    CMP AL, 13          ; Verifica se é CR
    JE FIM              ; Se for CR, finaliza

    ; Converte e armazena
    SUB AL, '0'         ; Converte '0'/'1' para 0/1
    SHL BX, 1           ; Desloca BX à esquerda
    ; Insere o bit lido no LSB
    OR BL, AL          ; Adiciona o valor lido (0 ou 1)
    INT 21H
    LOOP LEITURA
FIM:
    MOV AX, 4CH      ; Termina o programa
    INT 21H

MAIN ENDP 
END MAIN

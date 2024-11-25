.MODEL SMALL
.STACK 100H

.DATA
MATRIZ  DW 4, 16, 9, 3
        DW 7, 12, 18, 5
        DW 20, 22, 8, 15
        DW 6, 11, 14, 1

MAIOR DW ?
MENOR DW ?

MSG_MAIOR DB 'Maior elemento da matriz: $'
MSG_MENOR DB 'Menor elemento da matriz: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    ; Inicializa maior e menor com o primeiro elemento da matriz
    MOV SI, OFFSET MATRIZ  ; SI aponta para o início da matriz
    LODSW                  ; Carrega o primeiro elemento em AX
    MOV MAIOR, AX          ; Inicializa MAIOR
    MOV MENOR, AX          ; Inicializa MENOR

    ; Configura para percorrer os elementos da matriz
    MOV CX, 16             ; Número de elementos restantes (16 - 1)

PERCORRE_MATRIZ:
    LODSW                  ; Carrega o próximo elemento da matriz em AX

    ; Atualiza o maior elemento
    CMP AX, MAIOR          ; Compara AX com MAIOR
    JLE CHECA_MENOR        ; Se AX <= MAIOR, pula para checar menor
    MOV MAIOR, AX          ; Atualiza o maior elemento

CHECA_MENOR:
    CMP AX, MENOR          ; Compara AX com MENOR
    JGE PROX_ELEMENTO      ; Se AX >= MENOR, pula para o próximo elemento
    MOV MENOR, AX          ; Atualiza o menor elemento

PROX_ELEMENTO:
    LOOP PERCORRE_MATRIZ   ; Decrementa CX e repete até CX = 0

    ; Exibe o maior elemento
    LEA DX, MSG_MAIOR
    MOV AH, 9
    INT 21H

    MOV AX, MAIOR
    CALL IMPRIME_VALOR

    ; Nova linha
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H

    ; Exibe o menor elemento
    LEA DX, MSG_MENOR
    MOV AH, 9
    INT 21H

    MOV AX, MENOR
    CALL IMPRIME_VALOR

    ; Finaliza o programa
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Rotina para imprimir um valor numérico em decimal
IMPRIME_VALOR PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX             ; Limpa CX (contador de dígitos)
    MOV BX, 10             ; Divisor para obter dígitos

CONVERTE_DEC:
    XOR DX, DX             ; Limpa DX para a divisão
    DIV BX                 ; AX / BX, quociente em AX, resto em DX
    PUSH DX                ; Armazena o dígito na pilha
    INC CX                 ; Incrementa contador de dígitos
    CMP AX, 0              ; Verifica se o quociente é zero
    JNE CONVERTE_DEC       ; Continua se ainda houver quociente

IMPRIME_DIGITOS:
    POP DX                 ; Recupera os dígitos da pilha
    OR  DL, 30H            ; Converte para caractere ASCII
    MOV AH, 2            ; Rotina de saída de caractere
    INT 21H
    LOOP IMPRIME_DIGITOS   ; Repete para todos os dígitos

    POP DX
    POP CX
    POP BX
    POP AX
    RET
IMPRIME_VALOR ENDP

END MAIN

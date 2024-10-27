.MODEL SMALL
.STACK 100H
.DATA
   PROMPT DB "Digite um numero decimal entre 0 e 255: $"
   BIN_MSG DB 10, 13, "O valor em binario e: $"
   BIN_TABELA DB "01"                   ; Tabela de caracteres binários para XLAT
   BINARIO DB 8 DUP(?)                  ; Vetor para armazenar os bits em binário
   NUM DB ?                             ; Armazena o número em decimal

.CODE 

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Exibe a mensagem de prompt
    MOV AH, 9 
    LEA DX, PROMPT
    INT 21H 

    ; Lê o número decimal do usuário (assumimos entrada de um byte de 0 a 255)
    MOV AH, 1
    INT 21H
    SUB AL, 30H                         ; Converte ASCII para valor numérico
    MOV NUM, AL                         ; Armazena o número em NUM

    ; Exibe a mensagem para o valor em binário
    MOV AH, 9
    LEA DX, BIN_MSG
    INT 21H

    ; Chama o procedimento de conversão para binário
    CALL DEC_BIN

    ; Finaliza o programa
    MOV AH, 4CH
    INT 21H
MAIN ENDP

;================================

DEC_BIN PROC
    ; Converte o número em NUM para binário e armazena no vetor BINARIO

    MOV AL, NUM                        ; Carrega o número em AL
    MOV CX, 8                          ; Contador para 8 bits (1 byte)
    LEA DI, BINARIO                    ; DI aponta para o vetor BINARIO

CONVERT_LOOP:
    ; Obtém o bit mais à direita usando AND e armazena no vetor
    MOV BL, AL                         ; Copia AL para BL
    AND BL, 1                          ; Isola o bit menos significativo (LSB)
    ADD BL, 30H                        ; Converte o bit (0 ou 1) para ASCII
    MOV [DI], BL                       ; Armazena o caractere ASCII no vetor

    SHR AL, 1                          ; Desloca AL 1 bit para a direita
    INC DI                             ; Avança para o próximo elemento do vetor
    LOOP CONVERT_LOOP                  ; Repete até processar todos os 8 bits

    ; Exibe o vetor BINARIO em ordem inversa
    MOV CX, 8                          ; Configura CX para 8 bits
    LEA SI, BINARIO + 7                ; Aponta para o último caractere do vetor

DISPLAY_LOOP:
    MOV DL, [SI]                       ; Move o caractere do vetor para DL
    MOV AH, 2
    INT 21H                            ; Exibe o caractere em DL
    DEC SI                             ; Volta um índice no vetor
    LOOP DISPLAY_LOOP                  ; Repete até exibir todos os 8 bits

    RET
DEC_BIN ENDP

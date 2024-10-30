.MODEL SMALL
.STACK 100H
.DATA
    MSG_LER DB "Digite os elementos do vetor (10 elementos):$"
    VETOR DB 10 DUP (?)
    MSG_PAR DB 10, 13,"Quantidade de numeros pares: $"
    MSG_IMPAR DB 10, 13, "Quantidade de numeros impares: $"
    QTDE_PAR DB 0        ; Variável para contar números pares
    QTDE_IMPAR DB 0      ; Variável para contar números ímpares

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 9 
    LEA DX, MSG_LER
    INT 21H


    CALL LER_VETOR
    CALL PARIDADE


    ; Finaliza o programa
    MOV AH, 4CH
    INT 21H
MAIN ENDP


LER_VETOR PROC

    MOV CX, 10          ;Inicia cx com 10 pois vetor possui 10 posições
    XOR BX, BX          ;Zera bx que percorrerá vetor

    MOV AH, 1            ;lê vetor
LEITURA:
    INT 21H 
    MOV VETOR[BX], AL   ;guarda em vetor[bx]
    INC BX               ; vai para proxima casa do vetor

    LOOP LEITURA

LER_VETOR ENDP

PARIDADE PROC

    XOR BX, BX           ; Zera BX para usar como índice do vetor
    XOR AL, AL           ; Zera AL para reutilizar na contagem

PERCORRE_VETOR:
    MOV AL, VETOR[BX]    ; Pega o elemento atual do vetor
    MOV AH, AL           ; Move o valor para AH para preservar AL
    AND AL, 1            ; Faz uma máscara com 1 para verificar se é par/ímpar
    JZ EH_PAR            ; Se AL & 1 == 0, é par, então pula para EH_PAR

    ; Se não for par, é ímpar
    INC QTDE_IMPAR       ; Incrementa a quantidade de ímpares
    JMP PROXIMO_ELEMENTO ; Pula para o próximo elemento

EH_PAR:
    INC QTDE_PAR         ; Incrementa a quantidade de pares

PROXIMO_ELEMENTO:
    INC BX               ; Avança para o próximo índice
    CMP BX, 10           ; Verifica se já percorreu todos os 10 elementos
    JL PERCORRE_VETOR    ; Continua o loop se CX < 10

    ; Exibe a quantidade de pares
    MOV AH, 9
    LEA DX, MSG_PAR
    INT 21H

    ADD QTDE_PAR, 30H          ; Converte para ASCII
    MOV DL, QTDE_PAR
    MOV AH, 2
    INT 21H

    ; Exibe a quantidade de ímpares
    MOV AH, 9
    LEA DX, MSG_IMPAR
    INT 21H

    ADD QTDE_IMPAR, 30H         ; Converte para ASCII
    MOV DL, QTDE_IMPAR
    MOV AH, 2
    INT 21H
    
PARIDADE ENDP
END MAIN

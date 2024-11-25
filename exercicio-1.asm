;Em um vetor de números armazenado na memória, conte quantas
;ocorrências de números maiores que 15 e imprima essa mensagem no
;terminal.
.MODEL SMALL
.STACK 100H
.DATA
    CONTADOR    DB 0
    VETOR       DB 1,4,53,123,6,34,55,1,12,44
    STRLEN      EQU 10
    MSG         DB 'Quantidade de números maiores que 15: $'
.CODE

MAIN PROC

    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    MOV SI, OFFSET VETOR
    MOV CX, STRLEN
    MOV BL, 15

PERCORRE_VETOR:
    LODSB
    CMP AL, BL
    JLE CONTINUA
    INC CONTADOR

CONTINUA:
    LOOP PERCORRE_VETOR

    ADD CONTADOR, 30H
    MOV AH, 9 
    LEA DX, MSG
    INT 21H

    MOV AH, 2
    MOV DL, CONTADOR
    INT 21H

    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN 



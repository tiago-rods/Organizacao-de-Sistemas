;Faça um programa que calcule a soma dos 8 elementos de
;um vetor

.MODEL SMALL
.STACK 100H
.DATA
    MSG DB "DIGITE OS ELEMENTOS DO VETOR: $"
    ENDL DB 10,13,"$"
    VETOR DB 8 DUP(?)
    SUM DB 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 8
    XOR BX, BX

    MOV AH, 9 
    LEA DX, MSG
    INT 21H

    MOV AH, 1

LEITURA:
    INT 21H

    SUB AL, 30H 
    MOV VETOR[BX], AL 
    ADD SUM, AL

    INC BX

LOOP LEITURA

    ADD SUM, '0'
    MOV AH, 2

    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    MOV DL, SUM
    INT 21H

    MOV AH, 4CH
    INT 21H 

MAIN ENDP
END MAIN
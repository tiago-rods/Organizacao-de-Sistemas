.MODEL SMALL
.DATA
VETOR DB 1, 1, 1, 2, 2, 2
.CODE
MAIN PROC
MOV AX, @DATA
MOV DS,AX

XOR DL, DL ;DL INICIA COMO 0
MOV CX,6 ;INICIA CX COMO 6
XOR DI, DI ;INICIA DI COMO 0

VOLTA:
MOV DL, VETOR[DI] ;PEGA A POSIÇÃO DE DI
INC DI ;INCREMENTA DI PARA PERCORRER TODAS POSIÇÕES DO VETOR
ADD DL, 30H ; TRANSFORMA O VALOR EM ASCII


MOV AH, 2 ;IMPRIME OS ELEMENTOS DO VETOR
INT 21H
LOOP VOLTA

MOV AH,4CH
INT 21H ;saida para o DOS
MAIN ENDP
END MAIN
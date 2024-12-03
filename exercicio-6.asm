;Considere dois vetores V1 e V2 na memória, ambos de 7 elementos
;(numéricos), faça um programa que informe quantos E quais elementos
;V1 e V2 tem em comum
PUSH_ALL MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
ENDM

POP_ALL MACRO
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
ENDM

.MODEL SMALL
.STACK 100H
.DATA
    V1 DB 1, 2, 3, 4, 5, 6, 7
    V2 DB 4, 5, 6, 7, 8, 9, 0
    IGUAIS DB 4 DUP(?)
    CONTADOR DW 0
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    CALL COMPARA_VETOR
    MOV AH,2 
    MOV DL, 10
    INT 21H

    MOV AH, 2
    MOV DX, CONTADOR
    INT 21H

    CALL IMPRIME_VETOR

    MOV AH, 4CH
    INT 21H
MAIN ENDP

COMPARA_VETOR PROC
    PUSH_ALL
    ;ESTE PROCEDIMENTO DEVE UTILIZAR SCASB PARA ACHAR ELEMENTOS IGUAIS DE V1 E V2
    ;PARA ISSO, VAI PEGAR O ELEMENTO ANALISADO SALVAR EM UM VETOR IGUAIS
    MOV CX, 7
    MOV DX, 7
    XOR BX, BX
    CLD
    LEA SI, V1

    CMP_1:
    MOV AL, V1[SI]
    LEA DI, V2
    MOV CX, DX
    REPNE SCASB
    JNZ PROXIMO

    MOV IGUAIS[BX], AL
    INC BX
    MOV CONTADOR, BX

    PROXIMO:
    INC SI
    LOOP CMP_1
    POP_ALL
    RET
    
COMPARA_VETOR ENDP

IMPRIME_VETOR PROC
    PUSH_ALL

    MOV CX, 7
    MOV AH, 2
    XOR BX, BX

    IMPRIME_LOOP:
    CMP BX, 4
    JAE FIM

    ADD IGUAIS[BX], 30H
    MOV DL, IGUAIS[BX]
    INT 21H
    INC BX
    LOOP IMPRIME_LOOP

    FIM:
    POP_ALL
    RET

IMPRIME_VETOR ENDP

END MAIN
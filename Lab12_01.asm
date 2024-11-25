.MODEL SMALL
.STACK 100H
.DATA
    V_ORIGEM DB 10 DUP (?)
    V_ARMAZ DB 'abcd'
    V_DESTINO DB 10 DUP (?)
    TAMANHO DB 10
    CAR DB 'a'
    IGUAIS DB 'Vetores iguais$'
    DIFERENTES DB 'Vetores diferentes$'

.CODE
ENDL MACRO
    PUSH AX
    PUSH DX
    
    MOV AH, 2
    MOV DL, 10  ; Line Feed
    INT 21h  

    POP AX
    POP DX   
ENDM
MAIN PROC
    ;=============PROCEDIMENTOS CHAMADOS==============={
    ;
    ; LER_VETOR: Lê um vetor da entrada padrão e armazena na memória.
    ;
    ; IMPRIME_VETOR: Imprime um vetor na tela.
    ;
    ; COPIA_VETOR: Copia um vetor de origem para um vetor de destino.
    ;
    ; CMPS_CHAR: Conta quantas vezes um caractere específico aparece em uma string.
    ;
    ; CMP_VET: Compara dois vetores e imprime se são iguais ou diferentes.
    ;
    ;=============PROCEDIMENTOS CHAMADOS===============}

    MOV     AX, @DATA
    MOV     DS, AX
    MOV     ES, AX

   MOV CX,10
LEA DI,V_ORIGEM
CALL LE_VET

XOR CX,CX
MOV CL,TAMANHO
LEA SI,V_ORIGEM
CALL IMP_VET

LEA SI,V_ORIGEM
LEA DI,V_DESTINO
XOR CX,CX
MOV CL,TAMANHO
CALL CP_VET

XOR CX,CX
MOV CL,TAMANHO
LEA SI,V_DESTINO
CALL IMP_VET

ENDL

XOR CX,CX
MOV CL,TAMANHO
LEA DI,V_ORIGEM
CALL CMP_CAR

ENDL

XOR CX, CX
MOV CL, TAMANHO
LEA SI, V_ORIGEM
LEA DI, V_ARMAZ
CALL CMP_VET

MOV AH,4CH
INT 21H
main ENDP

LE_VET PROC
; LEITURA DE UM VETOR USANDO STOSB
; ENTRADA: CX TEM O TAMANHO MÁXIMO DO VETOR
;          DI APONTA PARA O VETOR
; SAÍDA - VETOR ARMAZENADO NA MEMÓRIA
PUSH AX
CLD
MOV AH,01
LE_V:
    INT 21H
    CMP AL, 0DH
    JE FIM_LE
    STOSB
LOOP LE_V
FIM_LE:
    SUB TAMANHO,CL
    POP AX
RET
LE_VET ENDP

IMP_VET PROC
; IMPRESSAO DE UM VETOR USANDO LODSB
; ENTRADA: VARIÁVEL TAMANHO TEM O TAMANHO O DO VETOR
;          SI APONTA PARA O VETOR
; SAÍDA - VETOR IMPRESSO NA TELA
PUSH AX
PUSH DX
CLD
MOV AH,02
MOV DL,10
INT 21H
XOR CX,CX
MOV CL, TAMANHO
IMP_V:
    LODSB
    MOV DL,AL
    INT 21H
LOOP IMP_V
POP DX
POP AX
RET
IMP_VET ENDP

CP_VET PROC
; COPIA DE UM VETOR USANDO LODSB E STOSB
; ENTRADA: VARIÁVEL TAMANHO TEM O TAMANHO O DO VETOR
;          SI APONTA PARA O VETOR ORIGEM E DI PARA O VETOR DESTINO
; SAÍDA - VETOR COPIADO NA MEMÓRIA
PUSH AX
PUSH DX
CLD
REP MOVSB
POP DX
POP AX
RET
CP_VET ENDP

CMP_CAR PROC
; VERIFICA QUANTAS VEZES APARECE UM CARACTER
; ENTRADA: VARIÁVEL TAMANHO TEM O TAMANHO O DO VETOR
;          DI APONTA PARA O VETOR ORIGEM 
;          CAR TEM O CARACTER A SER COMPARADO
; SAÍDA - NÚMERO DE VEZES IMPRESSO
PUSH AX
PUSH DX
XOR DX,DX
CLD
MOV AL,CAR
CMP_C:
    SCASB 
    JNZ CONTINUA 
    INC DL
CONTINUA:
    LOOP CMP_C
    
    MOV AH,02
    OR DL,30H
    INT 21H
POP DX
POP AX
RET
CMP_CAR ENDP

CMP_VET PROC
; COMPARA DOIS VETORES
PUSH AX
PUSH DX

CLD
COMPARE_LOOP:
    LODSB                ; Carrega o byte de SI para AL
    SCASB                ; Compara o byte de AL com o vetor armazenado (DI)
    JNE NOT_EQUAL         ; Se os bytes forem diferentes, pule para NOT_EQUAL
    LOOP COMPARE_LOOP     ; Continua até que CX = 0 (todos os bytes comparados)

; Se o loop terminar sem diferenças
MOV AH, 9
LEA DX, IGUAIS          ; Vetores são iguais
INT 21H
JMP END_COMPARE          

NOT_EQUAL:
MOV AH, 9
LEA DX, DIFERENTES      ; Vetores são diferentes
INT 21H


END_COMPARE:
POP DX
POP AX
RET
CMP_VET ENDP

END MAIN
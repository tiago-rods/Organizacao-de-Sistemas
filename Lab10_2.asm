.MODEL SMALL
.DATA
    MATRIZ DB 4 DUP(4 DUP(?))

.STACK 100H
ENDL MACRO
    PUSH AX
    PUSH DX

    MOV AH, 2        
    MOV DL, 10  ; Line Feed
    INT 21h  

    POP AX
    POP DX   
ENDM
PULAR_LINHA MACRO
    PUSH DX
    PUSH AX
    MOV AH, 2
    MOV DL, 10
    INT 21H
    POP AX
    POP DX
ENDM

PUSHALL MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
ENDM

POPALL MACRO
    POP SI
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
ENDM

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA BX, MATRIZ
    CALL LER_MATRIZ

    CALL SOMA_MATRIZ

    CALL SAIDADECIMAL

    MOV AH, 4CH
    INT 21H

MAIN ENDP

LER_MATRIZ PROC
    PUSHALL                                     ;guarda conteúdo dos registradores

    MOV AH, 1
    MOV DI, BX                                  ;USA BX COMO MARCADOR DA ÚLTIMA FILEIRA
    ADD DI, 12
    INPUT_FILEIRA:
    XOR SI,SI                                   ;SI APONTA PARA ELEMENTO NA PRIMEIRA COLUNA
    MOV CX, 4                                   ;LOOP RODA 4 VEZES
    INPUT_MATRIZ:
        INT 21H                                 ;RECEBER CARACTERE
        AND AL, 0Fh                             ;CONVERTE CARACTERE PARA NÚMERO
        MOV BYTE PTR [BX][SI], AL               ;COLOCA CARACTERE NA MATRIZ
        INC SI                                  ;PRÓXIMO ELEMENTO
        LOOP INPUT_MATRIZ
    ENDL
    ADD BX, SI                                  ;PROXIMA FILEIRA
    CMP BX, DI
    JLE INPUT_FILEIRA                           ;SE AINDA NÃO PASSOU PELA ÚLTIMA FILEIRA, VOLTAR
    POPALL                                      ;DEVOLVE VALORES PREVIOS AOS REGISTRADORES
    RET
LER_MATRIZ ENDP

;REALIZA A SOMA DOS ELEMENTOS EM UMA MATRIZ 4X4
SOMA_MATRIZ PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH SI
    
    XOR AX, AX
    MOV DI, BX                      ;USA DI COMO MARCADOR DA ÚLTIMA FILEIRA
    ADD DI, 12
    SOMA_FILEIRA:
    XOR SI,SI
    MOV CX, 4
    SOMAR_ELEMENTOS:                ;LOOP QUE IMPRIME OS 4 NÚMEROS EM UMA FILEIRA
        MOV DL, [BX][SI]            ;MOVE ELEMENTO DA MATRIZ PARA O REGISTRADOR
        XOR DH,DH
        ADD AX, DX                  ;SOMA ELEMENTO AO REGISTRADOR AX
        INC SI                      ;PRÓXIMO ELEMENTO
        LOOP SOMAR_ELEMENTOS
        ADD BX, SI                  ;PRÓXIMA FILEIRA
        CMP BX, DI                  ;REALIZA COMPARAÇÃO ENTRE A POSIÇÃO ATUAL DE BX E A POSIÇÃO DA ÚLTIMA FILEIRA
        JLE SOMA_FILEIRA            ;SAI DO LOOP APÓS IMPRIMIR OS NÚMEROS DA ÚLTIMA FILEIRA, QUANDO BX SERÁ 16 A MAIS QUE O VALOR INICIAL
    MOV BX, AX
    
    POP SI
    POP DX
    POP CX
    POP AX
    RET
SOMA_MATRIZ ENDP

;IMPRIME NÚMERO DECIMAL ARMAZENADO EM BX
;PODE IMPRIMIR NÚMEROS DE 1 ATÉ 262143
SAIDADECIMAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV DI, 10
    XOR CX, CX
    MOV AX, BX          ;PASSA O NUMERO A SER DIVIDIDO PARA AX
    XOR DX, DX          ;TIRA O LIXO DE DX
    OUTPUTDECIMAL:
        DIV DI              ;AX / DI    --> QUOCIENTE VAI PARA AX E RESTO VAI PARA DX
        PUSH DX             ;GUARDA RESTO NA PILHA
        XOR DX, DX          ;ZERA DX PARA PROXIMA DIIVISÃO
        INC CX              
        OR AX, AX           ;CONFERE SE O QUOCIENTE É 0
        JNZ OUTPUTDECIMAL
    
    MOV AH, 2
    IMPRIMIRDECIMAL:
        POP DX              ;DESEMPILHA O RESTO E O IMPRIME
        OR DL, 30H          ;CONVERTE PARA CARACTERE
        INT 21H
        LOOP IMPRIMIRDECIMAL

    POP DX
    POP CX
    POP BX
    POP AX
    RET
SAIDADECIMAL ENDP
END MAIN

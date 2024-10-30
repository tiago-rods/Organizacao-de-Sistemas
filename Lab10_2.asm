;Escreva um programa que leia todos os elementos de uma matriz 4 X 4 de números inteiros
;entre 0 e 6, inclusive. O programa deverá ler a matriz, imprimir a matriz lida, fazer a soma dos
;elementos, armazenar e imprimir esta soma. Usar um procedimento para ler, outro para somar
;e outro para imprimir. Usar procedimentos e macros.

ENDL MACRO
    PUSH AX
    PUSH DX

    MOV AH, 2        
    MOV DL, 10  ; Line Feed
    INT 21h  

    POP AX
    POP DX   
ENDM

PRINTC MACRO CHAR
    PUSH DX
    PUSH AX
    MOV AH, 2
    MOV DL, CHAR
    INT 21h
    POP AX
    POP DX
ENDM

.MODEL SMALL
.STACK 100H
.DATA
    MATRIZ DB 4 DUP(4 DUP(?))
    SUM DB ?
    
.CODE 

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL LER_MATRIZ
    CALL SOMA_ELEMENTOS

    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

LER_MATRIZ PROC

    XOR BX, BX ;ZERA BX  
    MOV CH, 4 ;CONTADOR LINHA 4


    MOV AH, 1
    LINHA:
    MOV CL, 4 ; CONTADOR COLUNA = 4
    XOR SI, SI ; ZERA SI AO PASSAR PARA A PROXIMA LINHA A LINHA 

        COLUNA:
        INT 21H 
        MOV MATRIZ[BX][SI], AL; MOVE AL A POSICAO DA MATRIZ
        SUB AL, 30H ; TRANSFORMA PARA ASCII

        INC SI ; PROXIMA POSICAO

        DEC CL  ;DECREMENTA CONTADOR
        JNZ COLUNA ; ENQUANTO NAO FOR 0, CONTINUA NO LOOP

    ENDL
    ADD BX, 4 ;PROXIMA LINHA

    DEC CH ;DECREMENTA CONTADOR DE LINHA 
    JNZ LINHA

    RET


LER_MATRIZ ENDP
;==============================
SOMA_ELEMENTOS PROC
    XOR AX, AX              ; Zera AX para usar como acumulador
    XOR BX, BX              ; Zera BX para índice da matriz
    MOV CX, 4               ; Número de linhas

LINHA_LOOP:
    XOR SI, SI              ; Zera SI para o índice da coluna
    MOV CL, 4               ; Número de colunas

    COLUNA_LOOP:
        ; Acessa cada elemento da matriz e soma
        ADD AL, MATRIZ [BX] [SI] ; Adiciona o valor da matriz a AL

        INC SI                  ; Próxima posição da coluna
        DEC CL                  ; Decrementa contador de colunas
        JNZ COLUNA_LOOP         ; Continua enquanto CL não for zero

        ; Agora AL contém a soma total dos elementos
        ; Se AL for maior que 10, precisamos processar os dígitos
        CMP AL, 10
        JL CONTINUAR           ; Se AL < 10, pula para CONTINUAR

PROCESSAR_DIGITOS:
    MOV BL, 10              ; BL é o divisor (10)
    XOR DX, DX              ; Zera DX para divisão

    ; Divide AL por 10 para extrair o dígito mais à direita
    DIV BL                  ; AX / 10, AL = quociente, AH = resto
    ; Aqui, AL contém o quociente (dígitos restantes), AH contém o dígito extraído

    ; Se o dígito (resto) for maior que 0, faça algo com ele (ex: armazenar)
    ; Para este exemplo, vamos apenas imprimir
    CMP AH, 0
    JE CONTINUAR_PROCESSAMENTO ; Se não houver dígito, pula

    ; Aqui você pode armazenar ou processar o dígito
    ADD AH, '0'            ; Converte para ASCII (se necessário)
    PRINTC AH              ; Imprime o dígito

CONTINUAR_PROCESSAMENTO:
    MOV AL, AH             ; Move o dígito restante para AL
    CMP AL, 0              ; Verifica se ainda há dígitos
    JNZ PROCESSAR_DIGITOS  ; Se ainda há dígitos, continue o processamento

CONTINUAR:
    ADD BX, 4              ; Passa para a próxima linha (4 elementos a mais)
    DEC CX                  ; Decrementa contador de linhas
    JNZ LINHA_LOOP          ; Continua enquanto CX não for zero

    RET
SOMA_ELEMENTOS ENDP

END MAIN

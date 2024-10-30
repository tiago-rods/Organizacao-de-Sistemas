;Faça um programa que imprima a matriz abaixo, como uma matriz (linhas e colunas). Usar
;procedimentos e macros.
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
    MATRIZ    DB 1,2,3,4
              DB 4,3,2,1
              DB 5,6,7,8
              DB 8,7,6,5

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL IMPRIMIR_MATRIZ ; CHAMA PROCEDIMENTO

    MOV AH,4CH 
    INT 21H
    
MAIN ENDP

IMPRIMIR_MATRIZ PROC

    XOR BX, BX ;ZERA BX
    
    MOV CH, 4 ;CONTADOR LINHA 4

    LINHA:
    MOV CL, 4 ; CONTADOR COLUNA = 4
    XOR SI, SI ; ZERA SI AO PASSAR PARA A PROXIMA LINHA A LINHA 

        COLUNA:
        MOV AL, MATRIZ[BX][SI]
        OR AL, 30H

        PRINTC AL

        INC SI

        DEC CL 
        JNZ COLUNA

    ENDL
    ADD BX, 4

    DEC CH 
    JNZ LINHA

    RET


IMPRIMIR_MATRIZ ENDP
END MAIN

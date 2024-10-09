.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB "Digite um número em Hexadecimal(se numero > 9, digitar em maiusculo): $"

.CODE 

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX          ; Inicializa BX com zero
    MOV CL, 4           ; Inicializa contador com 4

    ; Exibir mensagem
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    MOV AH, 1           ; Prepara entrada pelo teclado
;OBS --> PARA A LEITURA DE LETRAS EM HEXADECIMAL, É NECESSARIO DIGITAR A LETRA EM MAIUSCULO
LEITURA:
    INT 21H             ; Lê o primeiro caractere 

    CMP AL, 0Dh         ; É o CR?
    JE FIM              ; Se for CR, finaliza

    CMP AL, '9'         ; Caractere número?
    JG LETRA            ; Se maior que '9', é letra 
    SUB AL, '0'         ; Converte '0'-'9' para 0-9
    JMP DESLOCAR

LETRA: 
    SUB AL, 'A' - 10    ; Converte 'A'-'F' para 10-15

DESLOCAR: 
    SHL BX, 4           ; Desloca BX 4 casas à esquerda
    OR BL, AL           ; Insere valor nos 4 bits inferiores de BX
    LOOP LEITURA        ; Continua até ler 4 dígitos

FIM:
    MOV AH, 4CH         ; Termina o programa
    INT 21H

MAIN ENDP 
END MAIN

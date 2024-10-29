.MODEL SMALL
.STACK 100H
.DATA
    PROMPT DB "Digite seu nome:",10,13,"$"
    VETOR  DB 20 DUP(?)     ; Vetor para armazenar o nome do usuário
    MSG_END DB 10,13, "Seu nome possui esta quantidade de vogais:$", 10, 13
    CONT DB ?

.CODE

MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX

    ; Exibe a mensagem de prompt
    MOV AH, 9 
    LEA DX, PROMPT
    INT 21H

    ; Inicializa registradores
    XOR BX, BX            ; CX será o índice para armazenar no vetor VETOR
    XOR CX, CX

    MOV AH, 1
READ_LOOP:
    ; Lê um caractere do teclado
    INT 21H

    ; Verifica se o caractere é 'Enter' (ASCII 13)
    CMP AL, 13
    JE  DONE

    CMP AL, 41H
    JE INCREMENTA
    CMP AL, 45H
    JE INCREMENTA  ;Compara com vogais maiusculas
    CMP AL, 49H
    JE INCREMENTA
    CMP AL, 4FH
    JE INCREMENTA
    CMP AL, 55H
    JE INCREMENTA


    CMP AL, 61H
    JE  INCREMENTA
    CMP AL, 65H
    JE  INCREMENTA  ;Compara com vogais minisculas
    CMP AL, 69H
    JE  INCREMENTA
    CMP AL, 6FH
    JE  INCREMENTA
    CMP AL, 75H
    JE  INCREMENTA
    
    JMP CONTINUA

    INCREMENTA:
    INC CX 

    CONTINUA:
    ; Armazena o caractere em VETOR
    MOV VETOR[BX], AL

    ; Incrementa o índice
    INC BX

    ; Verifica se alcançou o limite do vetor (20 caracteres)
    CMP BX, 20
    JL  READ_LOOP

DONE:

    MOV CONT, CL 
    ADD CONT, 30H
    ; Mensagem final de sucesso
    MOV AH, 9
    LEA DX, MSG_END
    INT 21H

    MOV DL, CONT
    MOV AH, 2
    INT 21H

    ; Finaliza o programa
    MOV AX, 4CH
    INT 21H
MAIN ENDP
END MAIN
; Fazer um programa que permita a entrada e qualquer uma das bases e a saída em qualquer uma
; das bases. O programa deverá perguntar em que base será a entrada do número e em que base
; será a saída do número. Usar procedimentos e macros.

ENDL MACRO 
PUSH AX
PUSH DX
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
POP DX
POP AX
ENDM

PUSH_ALL MACRO
    PUSH AX 
    PUSH BX
    PUSH CX
    PUSH DX
    ENDM

POP_ALL MACRO
    POP DX
    POP CX
    POP BX
    POP AX
    ENDM

PRINT MACRO STRING
    PUSH_ALL
    MOV AH, 9 ; Exibe a mensagem e as opções
    LEA DX, STRING
    INT 21H 
    POP_ALL
ENDM

CLEAR_SCREEN MACRO
    PUSH_ALL    
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    POP_ALL
ENDM

.MODEL SMALL
.STACK 100H
.DATA
MENU DB '|===============MENU===============|',10,13,'1 --> BINARIO',10,13,'2 --> DECIMAL',10,13,'3 --> HEXADECIMAL',10,13,'|===============MENU===============|$'
MSG_IN DB 'ESCOLHA UMA ENTRADA: $'
MSG_NUM DB 'DIGITE O NUMERO: $'
MSG_OUT DB 'ESCOLHA UMA SAIDA: $'
TABELA DB '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ; DEFINE A TABELA DE TRADUÇÃO

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CLEAR_SCREEN ;LIMPA TELA
    
    PRINT MENU ;EXIBE MENU
    ENDL
    PRINT MSG_IN

    MOV AH, 1 ;PEDE INPUT DO USUARIO
    INT 21H
    ENDL

SWITCH_IN:  ;SWITCH CASE PARA VERIFICAR O QUE FOI DIGITADO
    PRINT MSG_NUM
    CMP AL, '1'
    JE CASE_BIN_IN
    CMP AL, '2'
    JE CASE_DEC_IN
    CMP AL, '3'
    JE CASE_HEX_IN
    JMP FIM
;CASOS
    CASE_BIN_IN:
    CALL BINARIO_IN
    JMP SAIDA

    CASE_DEC_IN:
    CALL DECIMAL_IN
    JMP SAIDA

    CASE_HEX_IN:
    CALL HEXADECIMAL_IN
    JMP SAIDA

    SAIDA: 
    PUSH_ALL
    ENDL  ;EXIBE MENU NOVAMENTE
    PRINT MENU
    ENDL
    PRINT MSG_OUT

    MOV AH, 1
    INT 21H
    ENDL

SWITCH_OUT: ;SWITCH CASE DE SAIDA
    CMP AL, '1'
    JE CASE_BIN_OUT
    CMP AL, '2'
    JE CASE_DEC_OUT
    CMP AL, '3'
    JE CASE_HEX_OUT
    JMP FIM
;CASOS
    CASE_BIN_OUT:
    POP_ALL
    CALL BINARIO_OUT
    JMP FIM

    CASE_DEC_OUT:
    POP_ALL
    CALL DECIMAL_OUT
    JMP FIM

    CASE_HEX_OUT:
    POP_ALL
    CALL HEXADECIMAL_OUT
    JMP FIM

    FIM:
    MOV AH,4CH
    INT 21H
MAIN ENDP

;===============================================================================
; PROCEDIMENTO DE ENTRADA EM DECIMAL
;===============================================================================
DECIMAL_IN PROC
; lê um numero entre -32768 A 32767
; entrada nenhuma
; saída numero em AX

LE_DECIMAL:

;  total = 0
    XOR BX,BX
; negativo = falso
    XOR CX,CX

; le caractere
    MOV AH,1
    INT 21H

; case caractere lido eh?
    CMP AL, 2DH
    JE NEGATIVO
    CMP AL, 2BH
    JE POSITIVO
    JMP REPETE

NEGATIVO:
    MOV CX,1

POSITIVO:
    INT 21H
;end case
REPETE:
; if caractere esta entre 0 e 9
    CMP AL, '0'
    JLE DIG_INVALIDO
    CMP AL, '9'
    JGE DIG_INVALIDO
; converte caractere em digito
    AND AX,000FH
    PUSH AX
; total = total X 10 + digito
    MOV AX,10
    MUL BX   ; AX = total X 10
    POP BX
    ADD BX,AX ; total - total X 10 + digito
; le caractere
    MOV AH,1
    INT 21H
    CMP AL,13  ;CR ?
    JNE REPETE    ; não, continua
; ate CR
    MOV AX,BX   ; guarda numero em AX
; se negativo
    OR CX,CX    ; negativo ?
    JE SAI_DEC      ; sim, sai
; entao
    NEG AX
; end if
    JMP SAI_DEC
DIG_INVALIDO:
; se caractere ilegal
    MOV AH,2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    JMP LE_DECIMAL
SAI_DEC:
    MOV BX, AX ; MOVE PARA O REGISTRADOR QUE ESTA SENDO UTILIZADO COMO PADRAO NAS TRADUÇÕES
    RET   ; retorna

DECIMAL_IN ENDP

;===============================================================================
; PROCEDIMENTO DE SAIDA DECIMAL
;===============================================================================
DECIMAL_OUT PROC
; imprime numero decimal sinalizado em AX
; entrada AX
; saida nenhuma

; if AX < 0
    MOV AX, BX
    OR AX,AX      ; AX < 0 ?
    JGE POSITIVO_OUT
;then
    PUSH AX     ;salva o numero
    MOV DL, 2DH
    MOV AH,2
    INT 21H         ; imprime -
    POP AX          ; restaura numero
    NEG AX

; digitos decimais
POSITIVO_OUT:
    XOR CX,CX      ; contador de d?gitos
    MOV BX,10      ; divisor
CONVERTE_DECIMAL:
    XOR DX,DX      ; prepara parte alta do dividendo
    DIV BX         ; AX = quociente   DX = resto
    PUSH DX        ; salva resto na pilha
    INC CX         ; contador =  +1

;until
    OR AX,AX       ; quociente = 0?
    JNE CONVERTE_DECIMAL      ; nao, continua

; converte digito em caractere
    MOV AH,2

; for contador vezes
IMPRIME_DEC_LOOP:
    POP DX        ; digito em DL
    OR DL,30H
    INT 21H
    LOOP IMPRIME_DEC_LOOP
; fim do for


    RET
DECIMAL_OUT ENDP
;===============================================================================
;PROCEDIMENTO DE ENTRADA EM HEXADECIMAL
;===============================================================================
HEXADECIMAL_IN PROC
    XOR BX, BX ; LIMPA BX
    MOV CL, 4 ; DEFINE O DESLOCAMENTO PARA 4 BITS

    MOV AH, 1
LE_HEX:
    INT 21H ; LÊ UM CARACTERE

    CMP AL, 13   ; VERIFICA SE FOI PRESSIONADA A TECLA ENTER
    JE SAIDA_HEX   ; SE SIM, VAI PARA A IMPRESSAO

    CMP AL, 57   ; SE AL FOR MAIOR QUE 9(57 ASCII), É UMA LETRA
    JA LETRA

    AND AL, 0FH   ; CONVERTE DE ASCII PARA VALOR NUMÉRICO(TIRA 30H)
    JMP DESLOCA

LETRA:
    SUB AL, 37H   ; CONVERTE DE HEXADECIMAL PARA VALORES NUMERICOS

DESLOCA:
    SHL BX, CL    ; DESLOCA BX PARA A ESQUERDA EM 4 BITS
    AND AL, 0FH  ;PREPARA AL(DEIXA APENAS OS PRIMEIROS 4 BITS)
    OR BL, AL     ; ARMAZENA O VALOR NO REGISTRADOR BX
    JMP LE_HEX

SAIDA_HEX:
    RET
HEXADECIMAL_IN ENDP
;===============================================================================
;PROCEDIMENTO DE SAIDA EM HEXADECIMAL
;===============================================================================
HEXADECIMAL_OUT PROC
    MOV AH, 2
    MOV CX, 4

LOOP_IMPRIME:
   
    MOV DL, BH                  
    SHR DL, 4                 ;DESLOCA O DÍGITO HEXADECIMAL PARA A DIREITA 

    PUSH BX                    ;GUARDA VALOR DE BX NA PILHA

    LEA BX, TABELA            ;COLOCA OFFSET DO ENDEREÇO EM BX
    XCHG AL, DL               ;TROCA CONTEÚDO DE AL E DL 
    XLAT                      ;CONVERTE CONTEÚDO DE AL PARA O VALOR CORRESPONDENTE NA TABELA
    XCHG AL, DL               ;TROCA CONTEÚDO DE AL E DL

    POP BX                   ;RETORNA VALOR DE BX DA PILHA

    SHL BX, 4               ;DESLOCA BX 4 BITS PARA A ESQUERDA
    INT 21H                 ;IMPRIME CARACTERE ARMAZENADO EM DL
    LOOP LOOP_IMPRIME       ;CONTINUA ATÉ QUE TODOS OS BITS TENHAM SIDO PROCESSADOS

    RET
HEXADECIMAL_OUT ENDP
;===============================================================================
;PROCEDIMENTO DE ENTRADA EM BINARIO
;===============================================================================
BINARIO_IN PROC

    XOR BX, BX ; LIMPA BX
    MOV AH, 1

LE_BIN:
    INT 21H ; LE O NUMERO INSERIDO
    CMP AL, 13
    JE FIM_BIN_IN; SE O NUMERO INSERIDO FOR O CR(13) ELE PULA
    CMP AL, '0'       
    JE ZERO
    SHL BX, 1     ; DESLOCA BX 1 CASA PARA A ESQUERDA
    OR BX, 1    ; INSERE 1 NO LSB
    JMP LE_BIN  ; VOLTA PARA RECEBER MAIS CARACTERES

ZERO:
    SHL BX, 1    ; DESLOCA BX 1 CASA PARA A ESQUERDA E ADICIONA 0 EM LSB
    JMP LE_BIN    ; VOLTA PARA RECEBER MAIS CARACTERES

FIM_BIN_IN:
    RET
BINARIO_IN ENDP
;===============================================================================
;PROCEDIMENTO DE SAIDA EM BINARIO
;===============================================================================
BINARIO_OUT PROC
    MOV AH, 2        ; FUNÇÃO PARA IMPRIMIR CARACTERE
    MOV CX, 16 ; DEFINE O CONTADOR COMO 16

IMPRIME_LOOP:
    ROL BX, 1          ; DESLOCA BX 1 CASA PARA A ESQUERDA
    JC UM_CARRY        ; VERIFICA SE O CARRY É 1, SE FOR PULA PARA IMPRIMIR UM
    MOV DL, 30H         ;SE NAO IMPRIME ZERO
    JMP IMPRIME1

UM_CARRY:
    MOV DL, 31H

IMPRIME1:
    INT 21H            ; IMPRIME O CARACTERE
    LOOP IMPRIME_LOOP  ; REPETE PARA O PRÓXIMO BIT

RET
BINARIO_OUT ENDP

END MAIN
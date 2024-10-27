.MODEL SMALL
.STACK 100H
.DATA
  MATRIZ DB 4 DUP(4 DUP(?))
  PMT DB "Digite os elementos da diagonal principal da matriz",10,13,"$"
  PCP DB "Os elemtos da matriz principal são:"

.code
main proc
    mov ax, @DATA
    mov ds, ax

    mov cx, 4
    xor bx, bx
    xor si, si

    lea dx, PMT
    mov ah, 9
    int 21h

    mov ah,1
loop_leitura:
    int 21h 
    sub al, 30h

    mov MATRIZ[bx][si], al

    inc bx
    inc si

loop loop_leitura


mov ah, 4CH
int 21h
main ENDP
end main



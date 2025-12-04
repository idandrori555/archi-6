jmp start

; print_ax_number: prints AX as decimal
PROC print_ax_number
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    
    mov ax, [bp+4] ; grab number to print
    xor cx, cx            ; digit count = 0

convert_loop:
    xor dx, dx            ; clear high word for DIV
    mov bx, 10
    div bx                ; AX / 10 ? AX = quotient, DX = remainder

    push dx               ; push remainder (digit)
    inc cx                ; count digits
    test ax, ax
    jnz convert_loop      ; keep dividing until AX == 0

print_loop:
    pop dx                ; get digit
    add dl, '0'           ; convert to ASCII
    mov ah, 02h
    int 21h               ; print char
    loop print_loop       ; repeat until all digits printed

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
ENDP



start:
    push 123
    call print_ax_number
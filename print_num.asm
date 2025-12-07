org 100h

jmp start

PROC print_new_line
    push bp
    push dx
    push ax
    
    mov dl, 0x0D
    mov ah, 0x2
    int 21h
    
    mov dl, 0x0A
    mov ah, 0x2
    int 21h
    
    pop ax
    pop dx
    pop bp
    ret
ENDP print_new_line

PROC print_num_uns
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    
    mov ax, [bp+4]
    
    cmp ax, 0
    jne not_zero
    mov dl, '0'
    mov ah, 0x2
    int 21h
    jmp print_num_uns_done
    
not_zero:
    mov bx, 10
    mov cx, 0
extract:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne extract
    
print_loop:
    pop dx
    add dl, '0'
    mov ah, 0x2
    int 21h
    loop print_loop
    
print_num_uns_done:
    pop dx
    pop cx
    pop bx
    pop bp
    ret 2
ENDP print_num_uns  


start:
in ax, 125
xor ah, ah ; need to xor high part of ax in order to print correctly
push ax
call print_num_uns
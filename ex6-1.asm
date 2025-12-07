org 100h
jmp start

CONTROL_PORT equ 127
DATA_PORT equ 125
ZERO_ASCII equ '0'

target_temp db 60

inc_temp:
    in al, DATA_PORT
    inc [target_temp]
    jmp start

dec_temp:
    in al, DATA_PORT
    dec [target_temp]
    jmp start

check_key_pressed:
    mov ah, 0x6
    mov dl, 0xFF
    int 21h
    jz start
    
    cmp al, '+'
    je inc_temp
    
    jmp dec_temp

PROC print_new_line
    push ax
    push dx
    
    mov ah, 0x2
    mov dl, 0x0D
    int 21h
    
    mov dl, 0x0A
    int 21h
    
    pop dx
    pop ax
    ret
ENDP print_new_line
    
PROC print_space
    push ax
    push dx
    
    mov ah, 0x2
    mov dl, ' '
    int 21h

    pop dx
    pop ax
    ret
ENDP print_space

PROC print_num_uns
    push bp
    mov bp, sp
    
    mov ax, [bp+4]
    
    push bx
    push cx
    push dx
    
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

PROC print_all
    push bp
    mov bp, sp
    
    in ax, DATA_PORT
    xor ah, ah
    push ax
    call print_num_uns
    
    call print_space
    
    mov al, [target_temp]
    xor ah, ah
    push ax 
    call print_num_uns
    
    call print_new_line
    
    pop bp
    ret
ENDP print_all

start:
    call print_all
    jmp sustain_temp

turn_off_fire:
    mov ax, 0x0
    out CONTROL_PORT, ax

sustain_temp:
    in ax, DATA_PORT
    cmp al, [target_temp]
    jae turn_off_fire
    
    mov ax, 0x1
    out CONTROL_PORT, ax
    
    jmp check_key_pressed

end:
    xor ah, ah
    int 16h
    ret
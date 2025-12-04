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

    
print_num_loop:    
    cmp dl, 0
    jbe print_num_end
    
    mov dl, bl
    
    mov ah, 0x2
    int 21h
    
print_num_end:    
    pop bp
    ret 2
ENDP   


check_key_pressed:
    mov ah, 0x6
    mov dl, 0xFF
    int 21h ; syscall to check if key was pressed
    jz start ; check if no key was pressed
    
    cmp al, '+'
    je inc_temp
    
    jmp dec_temp

start:
    jmp sustain_temp

turn_off_fire:
    mov ax, 0x0
    out CONTROL_PORT, ax ; turn off fire

sustain_temp:
    in ax, DATA_PORT
    cmp al, [target_temp]
    jae turn_off_fire
    
    mov ax, 0x1
    out CONTROL_PORT, ax ; turn on fire
    
    jmp check_key_pressed

end:
xor ah, ah
int 16h
ret
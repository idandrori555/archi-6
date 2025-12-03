org 100h

CONTROL_PORT equ 127
DATA_PORT equ 125
CRITICAL_TEMP equ 60

jmp dec_temp

inc_temp:
    in ax, DATA_PORT
    inc ax
    out DATA_PORT, ax
    jmp temp_loop

dec_temp:
    in ax, DATA_PORT
    dec ax
    out DATA_PORT, ax
    jmp temp_loop

check_key_pressed:
    mov ah, 0x6
    mov dl, 0xFF
    int 21h ; syscall to check if key was pressed
    jz temp_loop ; check if no key was pressed
    
    cmp al, '+'
    je inc_temp
    
    jmp dec_temp

print_temp:
    in ax, DATA_PORT
    mov bx, ax
    
    mov dl, 'A' ; char to print
    mov ah, 0x2 ; print char
    int 21h ; syscall

start:
    mov ax, 0x1
    out CONTROL_PORT, ax ; turn on fire
    jmp temp_loop
    
lower_temp:
    in ax, DATA_PORT
    cmp ax, CRITICAL_TEMP
    jb temp_loop
    
    dec ax
    out CONTROL_PORT, ax
    
temp_loop:
    in ax, DATA_PORT
    cmp ax, CRITICAL_TEMP
    jae lower_temp
    jmp check_key_pressed ; check key + jump back

end:
xor ah, ah
int 16h
ret
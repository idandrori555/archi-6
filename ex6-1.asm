org 100h

CONTROL_PORT equ 127
DATA_PORT equ 125
CRITICAL_TEMP equ 60

jmp start

inc_temp:
    in al, DATA_PORT
    inc al
    out DATA_PORT, al
    jmp temp_loop

dec_temp:
    in al, DATA_PORT
    dec al
    out DATA_PORT, al
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
    in al, DATA_PORT
    mov bl, al
    
    mov dl, 'A' ; char to print
    mov ah, 0x2 ; print char
    int 21h ; syscall

start:
    mov al, 0x1
    out CONTROL_PORT, al ; turn on fire
    jmp temp_loop
    
lower_temp:
    mov ax, 0x0
lower_temp_loop:
    out CONTROL_PORT, ax
    in al, DATA_PORT
    cmp al, CRITICAL_TEMP
    jae lower_temp_loop
    
back_on:
    mov ax, 0x1
    out CONTROL_PORT, ax    
temp_loop:
    in al, DATA_PORT
    cmp al, CRITICAL_TEMP
    jae lower_temp
    jmp check_key_pressed ; check key + jump back

end:
xor ah, ah
int 16h
ret
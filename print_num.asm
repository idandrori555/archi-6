org 100h

jmp start

error_msg db "Error: division by zero$"

PROC handle_zero_div
    pusha
    mov dx, offset error_msg ; print error message
    mov ah, 0x9
    int 21h
    popa
    
    iret
    
ENDP handle_zero_div

start:
    mov ax, 0x0
    mov es, ax
    
    mov bx, cs
    mov ax, offset handle_zero_div ; addr of handler
                   
    mov word ptr es:[2h], bx ; code segment
    mov word ptr es:[0h], ax ; offset (handler funcfiton)
    
    xor ax, ax
    div ax ; 0 / 0
    
end:
    xor ah, ah
    int 16h
    ret

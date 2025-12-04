jmp start

error_str db "Error: division by zero", 0x0

handle_zero_div:
iret

start:
mov ax, offset handle_zero_div ; addr of handler
               
mov word ptr 0000:[0000], 0x100 ; code segment

xor ax, ax
div ax
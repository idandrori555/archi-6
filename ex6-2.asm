org 100h

jmp start

error_msg db "Error: division by zero$"

PROC handle_zero_div
    pusha
    mov dx, offset error_msg ; print error message
    mov ah, 0x9
    int 21h
    
    call print_new_line
    
    popa
    iret
ENDP handle_zero_div

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
    jne .not_zero
    mov dl, '0'
    mov ah, 0x2
    int 21h
    jmp .done
    
.not_zero:
    mov bx, 10
    mov cx, 0

.extract:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne .extract
    
; Print digits from stack
.print_loop:
    pop dx
    add dl, '0' ; ASCII
    mov ah, 0x2
    int 21h
    loop .print_loop
    
.done:
    call print_new_line
    
    pop dx
    pop cx
    pop bx
    pop bp
    ret 2
ENDP print_num_uns

PROC print_all_regs
    push ax
    call print_num_uns
    
    push bx
    call print_num_uns
    
    push cx
    call print_num_uns
    
    push dx
    call print_num_uns
    
    push sp
    call print_num_uns
    
    push bp
    call print_num_uns
    
    push si
    call print_num_uns
    
    push di
    call print_num_uns
    ret
ENDP print_all_regs

start:
    cli ; clear ints
    
    mov ax, 0x0
    mov es, ax
    
    mov bx, cs
    mov ax, offset handle_zero_div ; addr of handler
    
    ; little endian
    ; https://he.wikipedia.org/wiki/%D7%A1%D7%93%D7%A8_%D7%91%D7%AA%D7%99%D7%9D               
    mov word ptr es:[2h], bx ; code segment
    mov word ptr es:[0h], ax ; offset (handler funcfiton)
    
    sti ; enable ints
    
    call print_all_regs
    
    xor ax, ax
    div ax ; 0 / 0
    
    call print_all_regs
    
end:
    xor ah, ah
    int 16h
    ret

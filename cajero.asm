sys_exit  equ 1
sys_read  equ 3
sys_write equ 4

section .data
saldo db 50

menu_principal db '1) Inicio', 10
               db '2) Consultar saldo', 10
               db '3) Ingresar dinero', 10
               db '4) Retirar dinero', 10
               db '5) Configurar PIN', 10
               db '6) Salir', 10
menu_len equ $ - menu_principal

opcion db 'Introduce una opcion: '
opcion_len equ $ - opcion

msg_inicio     db 'Has elegido Inicio', 10
msg_inicio_len equ $ - msg_inicio

msg_saldo_txt     db 'Saldo actual: '
msg_saldo_txt_len equ $ - msg_saldo_txt

msg_ingreso     db 'Has elegido Ingresar dinero', 10
msg_ingreso_len equ $ - msg_ingreso

msg_retiro     db 'Has elegido Retirar dinero', 10
msg_retiro_len equ $ - msg_retiro

msg_pin     db 'Has elegido Configurar PIN', 10
msg_pin_len equ $ - msg_pin

msg_invalida     db 'Opcion no valida', 10
msg_invalida_len equ $ - msg_invalida

section .bss
num1        resb 3
num_ingreso resb 3
num_retiro  resb 2
saldo_buf   resb 3

section .text
global _start

_start:

menu_loop:
    ; Imprimir menú
    mov eax, sys_write
    mov ebx, 1
    mov ecx, menu_principal
    mov edx, menu_len
    int 0x80

    ; Imprimir "Introduce una opcion"
    mov eax, sys_write
    mov ebx, 1
    mov ecx, opcion
    mov edx, opcion_len
    int 0x80

    ; Leer opción
    mov eax, sys_read
    mov ebx, 0
    mov ecx, num1
    mov edx, 3
    int 0x80

    cmp byte [num1], '1'
    je opcion_inicio

    cmp byte [num1], '2'
    je opcion_saldo

    cmp byte [num1], '3'
    je opcion_ingreso

    cmp byte [num1], '4'
    je opcion_retiro

    cmp byte [num1], '5'
    je opcion_pin

    cmp byte [num1], '6'
    je salir

    jmp opcion_invalida     ; si no coincide con nada

opcion_inicio:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_inicio
    mov edx, msg_inicio_len
    int 0x80
    jmp menu_loop           ; volver al menú

opcion_saldo:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_saldo_txt
    mov edx, msg_saldo_txt_len
    int 0x80

    mov al, [saldo]
    mov ah, 0
    mov bl, 10
    div bl

    add al, '0'
    add ah, '0'
    mov [saldo_buf],   al
    mov [saldo_buf+1], ah
    mov byte [saldo_buf+2], 10

    mov eax, sys_write
    mov ebx, 1
    mov ecx, saldo_buf
    mov edx, 3
    int 0x80

    jmp menu_loop

opcion_ingreso:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_ingreso
    mov edx, msg_ingreso_len
    int 0x80
    jmp menu_loop

opcion_retiro:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_retiro
    mov edx, msg_retiro_len
    int 0x80
    jmp menu_loop

opcion_pin:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_pin
    mov edx, msg_pin_len
    int 0x80
    jmp menu_loop

opcion_invalida:
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_invalida
    mov edx, msg_invalida_len
    int 0x80
    jmp menu_loop           ; volver al menú también

salir:
    mov eax, sys_exit
    mov ebx, 0
    int 0x80





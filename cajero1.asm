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

msg_ingresar_txt     db 'Cantidad a ingresar: '
msg_ingresar_txt_len equ $ - msg_ingresar_txt

msg_ingreso_ok     db 'Ingreso OK', 10
msg_ingreso_ok_len equ $ - msg_ingreso_ok

msg_retirar_txt     db 'Cantidad a retirar: '
msg_retirar_txt_len equ $ - msg_retirar_txt

msg_retiro_ok     db 'Retiro OK', 10
msg_retiro_ok_len equ $ - msg_retiro_ok

msg_fondos     db 'Fondos insuficientes', 10
msg_fondos_len equ $ - msg_fondos

msg_pin     db 'Has elegido Configurar PIN', 10
msg_pin_len equ $ - msg_pin

msg_invalida     db 'Opcion no valida', 10
msg_invalida_len equ $ - msg_invalida

section .bss
num1        resb 3
num_ingreso resb 3
num_retiro  resb 3
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
    ; Imprimir "Cantidad a ingresar"
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_ingresar_txt
    mov edx, msg_ingresar_txt_len
    int 0x80

    ; Leer cantidad
    mov eax, sys_read
    mov ebx, 0
    mov ecx, num_ingreso
    mov edx, 3
    int 0x80

    ; Convertir ASCII a número (atoi simple, máximo 2 cifras)
    mov al, [num_ingreso]
    sub al, '0'             ; primer dígito
    mov bl, 10
    mul bl                  ; al = primer dígito * 10

    mov bl, [num_ingreso+1]
    cmp bl, 10              ; comprobar si es Enter (solo 1 dígito)
    je un_digito_ingreso

    sub bl, '0'             ; segundo dígito
    add al, bl              ; al = total

un_digito_ingreso:
    ; Sumar al saldo
    add [saldo], al

    ; Imprimir confirmación
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_ingreso_ok
    mov edx, msg_ingreso_ok_len
    int 0x80

    ; Imprimir saldo actualizado
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

opcion_retiro:
    ; Imprimir "Cantidad a retirar"
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_retirar_txt
    mov edx, msg_retirar_txt_len
    int 0x80

    ; Leer cantidad
    mov eax, sys_read
    mov ebx, 0
    mov ecx, num_retiro
    mov edx, 3
    int 0x80

    ; Convertir ASCII a número (atoi simple, máximo 2 cifras)
    mov al, [num_retiro]
    sub al, '0'             ; primer dígito
    mov bl, 10
    mul bl                  ; al = primer dígito * 10

    mov bl, [num_retiro+1]
    cmp bl, 10              ; comprobar si es Enter (solo 1 dígito)
    je un_digito_retiro

    sub bl, '0'             ; segundo dígito
    add al, bl              ; al = total

un_digito_retiro:
    ; Comparar con saldo
    mov bl, [saldo]
    cmp al, bl              ; cantidad > saldo?
    ja fondos_insuficientes

    ; Restar del saldo
    sub [saldo], al

    ; Imprimir "Retiro OK"
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_retiro_ok
    mov edx, msg_retiro_ok_len
    int 0x80

    ; Imprimir saldo actualizado
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

fondos_insuficientes:
    ; Imprimir "Fondos insuficientes"
    mov eax, sys_write
    mov ebx, 1
    mov ecx, msg_fondos
    mov edx, msg_fondos_len
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


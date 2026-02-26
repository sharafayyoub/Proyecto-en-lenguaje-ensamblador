; -----------------------------------------------------------------------------
; Programa: MiniCajero ASM (x86 32-bit NASM para Linux)
; Compilación: nasm -f elf32 minicajero.asm -o minicajero.o
; Enlace:      ld -m elf_i386 minicajero.o -o minicajero
; -----------------------------------------------------------------------------

section .data
    msg_menu    db 0xA, "--- MiniCajero ASM ---", 0xA, \
                   "1) Ver saldo", 0xA, \
                   "2) Ingresar dinero", 0xA, \
                   "3) Retirar dinero", 0xA, \
                   "4) Salir", 0xA, \
                   "Opción: ", 0
    len_menu    equ $ - msg_menu

    msg_saldo   db "Saldo actual: ", 0
    len_saldo   equ $ - msg_saldo

    msg_ingreso db "Cantidad a ingresar: ", 0
    len_ingreso equ $ - msg_ingreso

    msg_retiro  db "Cantidad a retirar: ", 0
    len_retiro  equ $ - msg_retiro

    msg_ok_in   db "Ingreso OK", 0xA, 0
    len_ok_in   equ $ - msg_ok_in

    msg_ok_out  db "Retiro OK", 0xA, 0
    len_ok_out  equ $ - msg_ok_out

    msg_error   db "Fondos insuficientes", 0xA, 0
    len_error   equ $ - msg_error

    msg_inv     db "Opción no válida", 0xA, 0
    len_inv     equ $ - msg_inv

    newline     db 0xA

section .bss
    buffer      resb 10    ; Buffer para entrada de teclado
    saldo       resd 1     ; Variable de 4 bytes para el saldo (entero)
    temp_num    resb 2     ; Para imprimir dígitos de 0-99

section .text
    global _start

_start:
    mov dword [saldo], 0   ; Inicializar saldo en 0

menu_loop:
    ; Mostrar menú
    mov ecx, msg_menu
    mov edx, len_menu
    call print

    ; Leer opción
    mov ecx, buffer
    mov edx, 10
    call readline

    ; Evaluar opción (primer carácter del buffer)
    mov al, [buffer]
    cmp al, '1'
    je op_ver_saldo
    cmp al, '2'
    je op_ingresar
    cmp al, '3'
    je op_retirar
    cmp al, '4'
    je salir

    ; Opción inválida
    mov ecx, msg_inv
    mov edx, len_inv
    call print
    jmp menu_loop

; --- PROCEDIMIENTOS DE OPERACIONES ---

op_ver_saldo:
    mov ecx, msg_saldo
    mov edx, len_saldo
    call print

    mov eax, [saldo]
    call print_num_0_99

    mov ecx, newline
    mov edx, 1
    call print
    jmp menu_loop

op_ingresar:
    mov ecx, msg_ingreso
    mov edx, len_ingreso
    call print

    mov ecx, buffer
    mov edx, 10
    call readline

    call atoi              ; Convertir entrada a entero en EAX
    add [saldo], eax       ; Sumar al saldo

    mov ecx, msg_ok_in
    mov edx, len_ok_in
    call print
    jmp menu_loop

op_retirar:
    mov ecx, msg_retiro
    mov edx, len_retiro
    call print

    mov ecx, buffer
    mov edx, 10
    call readline

    call atoi              ; Cantidad a retirar en EAX
    mov ebx, [saldo]
    
    cmp eax, ebx           ; ¿Cantidad > saldo?
    jg fondos_insuficientes

    sub ebx, eax           ; Restar
    mov [saldo], ebx

    mov ecx, msg_ok_out
    mov edx, len_ok_out
    call print
    jmp menu_loop

fondos_insuficientes:
    mov ecx, msg_error
    mov edx, len_error
    call print
    jmp menu_loop

salir:
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; status 0
    int 0x80

; --- FUNCIONES DE UTILIDAD ---

; Imprime un string (ECX: puntero, EDX: longitud)
print:
    push eax
    push ebx
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    int 0x80
    pop ebx
    pop eax
    ret

; Lee entrada (ECX: buffer, EDX: tamaño)
readline:
    push ebx
    mov eax, 3             ; sys_read
    mov ebx, 0             ; stdin
    int 0x80
    pop ebx
    ret

; Convierte ASCII en buffer a entero en EAX
atoi:
    push ebx
    push ecx
    push edx
    xor eax, eax           ; Limpiar acumulador
    mov esi, buffer        ; Puntero al buffer
.loop:
    movzx ebx, byte [esi]  ; Leer carácter
    cmp bl, 10             ; ¿Es salto de línea?
    je .done
    cmp bl, 13             ; ¿Es retorno de carro?
    je .done
    cmp bl, '0'            ; Validar que sea número
    jl .done
    cmp bl, '9'
    jg .done

    sub bl, '0'            ; ASCII -> Entero
    imul eax, 10           ; eax = eax * 10
    add eax, ebx           ; eax = eax + dígito
    inc esi
    jmp .loop
.done:
    pop edx
    pop ecx
    pop ebx
    ret

; Imprime un número 0-99 (EAX: número)
print_num_0_99:
    push eax
    push ebx
    push ecx
    push edx

    cmp eax, 10
    jl .un_digito

    ; Caso 2 dígitos
    xor edx, edx
    mov ebx, 10
    div ebx                ; EAX = cociente (decenas), EDX = residuo (unidades)
    
    add al, '0'            ; Convertir decenas
    add dl, '0'            ; Convertir unidades
    mov [temp_num], al
    mov [temp_num+1], dl

    mov ecx, temp_num
    mov edx, 2
    call print
    jmp .fin

.un_digito:
    add al, '0'
    mov [temp_num], al
    mov ecx, temp_num
    mov edx, 1
    call print

.fin:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
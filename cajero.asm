sys_exit  equ 1
sys_read  equ 3
sys_write equ 4

section .data
saldo db 50
menu_principal db '1) Inicio', 10
               db '2) Consutar saldo', 10
               db '3) Ingresar dinero', 10
               db '4) Retirar dinero', 10
               db '5) Configurar PIN', 10
               db '6) Salir', 10
menu_len equ $ - menu_principal

opcion db 'Introduce una opcion: '
opcion_len equ $ - opcion

msg_inicio db 'Has elegido Inicio', 10
msg_inicio_len equ $ - msg_inicio

msg_saldo db 'Has elegido Consultar saldo', 10
msg_saldo_len equ $ - msg_saldo

msg_ingreso db 'Has elegido Ingresar dinero', 10
msg_ingreso_len equ $ - msg_ingreso

section .bss
num1 resb 3
num_ingreso resb 3
num_retiro resb 2


section .text
global _start
_start:


mov eax,sys_write
mov ebx,1
mov ecx,menu_principal
mov edx,menu_len
int 0x80                ;para imprimir el menu 

mov eax,sys_write
mov ebx,1
mov ecx,opcion
mov edx,opcion_len      ;para imprimir selecciona opcion
int 0x80 

mov eax,sys_read
mov ebx,0
mov ecx,num1
mov edx,3
int 0x80            ; para que pueda introducir numero

cmp byte [num1], '1'
je opcion_inicio        ; comparar primer caracter introducido con '1'

cmp byte [num1], '2'
je opcion_saldo         ; comparar opcion 2

cmp byte [num1], '3'
je opcion_ingreso       ; comparar opcion 3

; si no es 1, salir directamente
jmp salir


opcion_inicio:
mov eax, sys_write
mov ebx, 1
mov ecx, msg_inicio
mov edx, msg_inicio_len
int 0x80
jmp salir

opcion_saldo:
mov eax, sys_write
mov ebx, 1
mov ecx, msg_saldo
mov edx, msg_saldo_len
int 0x80
jmp salir

opcion_ingreso:
mov eax, sys_write
mov ebx, 1
mov ecx, msg_ingreso
mov edx, msg_ingreso_len
int 0x80
jmp salir


salir:
mov eax, sys_exit
mov ebx, 0
int 0x80






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

mov eax,sys_read
mov ebx,0
mov ecx,num1
mov edx,3
int 0x80            ; para que pueda introducir numero


mov eax, sys_exit
mov ebx, 0
int 0x80                ;el exit 







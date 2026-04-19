; -------------------------------------------------------------------
; Programa: holamundo.asm
; Instrucciones para compilar y ejecutar:
;   nasm -f elf32 holamundo.asm -o holamundo.o
;   ld -m elf_i386 holamundo.o -o holamundo
;   ./holamundo
; -------------------------------------------------------------------

section .data
    ; Definimos el mensaje en la sección de datos
    ; 0xa es el código ASCII para el salto de línea (\n)
    msg db 'Hola Mundo!', 0xa
    
    ; Calculamos la longitud del mensaje ($ significa "posición actual")
    len equ $ - msg

section .text
    global _start       ; Punto de entrada para el enlazador (linker)

_start:
    
    ; Usamos la llamada al sistema 'sys_write' (número 4)
    mov eax, 4          ; ID de la syscall sys_write
    mov ebx, 1          ; File Descriptor: 1 es la salida estándar (STDOUT)
    mov ecx, msg        ; Dirección de memoria de nuestro mensaje
    mov edx, len        ; Cuántos caracteres queremos imprimir
    int 0x80            ; Llamada al kernel (Interrupción 80h)


    ; Usamos la llamada al sistema 'sys_exit' (número 1)
    mov eax, 1          ; ID de la syscall sys_exit
    mov ebx, 0          ; Código de retorno (0 significa "todo bien")
    int 0x80            ; Llamada al kernel hola

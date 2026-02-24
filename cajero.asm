; hola.asm  (NASM, 32-bit, Linux)
; Imprime "Hola mundo" y sale

section .data
    msg db "Hola mundo", 10        ; 10 = '\n'
    len equ $ - msg

section .text
    global _start

_start:
    ; sys_write(1, msg, len)
    mov eax, 4      ; número de syscall: write
    mov ebx, 1      ; fd = 1 (stdout)
    mov ecx, msg    ; buffer
    mov edx, len    ; longitud
    int 0x80

    ; sys_exit(0)
    mov eax, 1      ; syscall: exit
    xor ebx, ebx    ; código 0
    int 0x80
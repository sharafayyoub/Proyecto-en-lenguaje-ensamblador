Para poder ejecutar el código, primero escribe en la terminal "wsl"
Esto significa que ya estás em WSL y en la carpeta del proyecto. Después, copia y pega tal cual
el siguiente comando para que se compile y ejecute el código

nasm -f elf32 cajero10.asm -o cajero10.o && ld -m elf_i386 cajero10.o -o cajero10 && ./cajero10

param(
    [Parameter(Mandatory=$true)]
    [string]$archivo
)

<<<<<<< HEAD

$basePath = "c:\Users\Sharaf Ayyoub\OneDrive\GITHUB\Proyecto-en-lenguaje-ensamblador"
=======
$basePath = "c:\Users\Sharaf Ayyoub\OneDrive\GITHUB\Proyecto_en_lenguaje_ensamblador\Proyecto-en-lenguaje-ensamblador"
>>>>>>> eb35ff617052831c1d9f169fda6e0f4b462f15dc
$nombre = [System.IO.Path]::GetFileNameWithoutExtension($archivo)
$asmFile = "$nombre.asm"

Write-Host "Compilando $asmFile..." -ForegroundColor Cyan
<<<<<<< HEAD
wsl bash -c "cd '/mnt/c/Users/Sharaf Ayyoub/OneDrive/GITHUB/Proyecto-en-lenguaje-ensamblador' && nasm -f elf32 $asmFile -o $nombre.o && ld -m elf_i386 $nombre.o -o $nombre && ./$nombre"
=======
wsl bash -c "cd /mnt/c/Users/Sharaf\ Ayyoub/OneDrive/GITHUB/Proyecto_en_lenguaje_ensamblador/Proyecto-en-lenguaje-ensamblador && nasm -f elf32 $asmFile -o $nombre.o && ld -m elf_i386 $nombre.o -o $nombre && ./$nombre"
>>>>>>> eb35ff617052831c1d9f169fda6e0f4b462f15dc
Write-Host "Completado" -ForegroundColor Green
param(
  [Parameter(Mandatory=$true)]
  [string]$File
)

# Comprueba que existe
if (!(Test-Path $File)) {
  Write-Host "No existe el archivo: $File"
  exit 1
}

# Saca nombre base: cajero.asm -> cajero
$base = [System.IO.Path]::GetFileNameWithoutExtension($File)

# Ruta Windows absoluta de la carpeta actual (donde ejecutas el script)
$winDir = (Get-Location).Path

# Convierte ruta Windows a ruta WSL (/mnt/c/...)
# Ej: C:\Users\...\Assembly  -> /mnt/c/Users/.../Assembly
$drive = $winDir.Substring(0,1).ToLower()
$rest  = $winDir.Substring(2) -replace '\\','/'
$wslDir = "/mnt/$drive$rest"

# Construye comandos para WSL (todo se ejecuta dentro de esa carpeta)
# - set -e: si falla algo, corta
# - chmod +x: por si acaso
$cmd = @"
set -e
cd "$wslDir"
echo "-> NASM: $File"
nasm -f elf32 "$File" -o "$base.o"
echo "-> LD: $base.o"
ld -m elf_i386 "$base.o" -o "$base"
chmod +x "$base"
echo "-> RUN: ./$base"
./"$base"
"@

# Ejecuta en WSL (bash)
wsl bash -lc $cmd

if ($LASTEXITCODE -ne 0) {
  Write-Host "Error: WSL devolvió código $LASTEXITCODE"
  exit $LASTEXITCODE
}
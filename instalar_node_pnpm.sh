#!/bin/bash

# Este script instala Node Version Manager (NVM), Node.js (LTS) y pnpm en Ubuntu.

echo "=> Iniciando la instalación de Node.js y pnpm..."

# --- 1. INSTALAR DEPENDENCIAS NECESARIAS ---
echo "=> 1. Instalando dependencias del sistema (curl, build-essential)..."
sudo apt update
sudo apt install -y curl build-essential

# --- 2. INSTALAR NVM (Node Version Manager) ---
# NVM permite instalar múltiples versiones de Node.js
echo "=> 2. Descargando e instalando NVM..."
# Obtener la versión más reciente de NVM
NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -oP '"tag_name": "v\K[^"]+')
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash

# Configurar el entorno para que la terminal reconozca el comando 'nvm' inmediatamente
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Cargar nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Cargar nvm bash_completion

# Verificar si la carga de NVM fue exitosa
if command -v nvm &> /dev/null; then
    echo "   NVM (v$NVM_VERSION) instalado correctamente."
else
    echo "   Error: NVM no se cargó. Verifica el log de instalación."
    exit 1
fi

# --- 3. INSTALAR NODE.JS (CON NPM INCLUIDO) ---
# Se instala la última versión LTS (Long Term Support)
echo "=> 3. Instalando la última versión LTS de Node.js (esto incluye npm)..."
nvm install --lts

# Establecer la versión LTS como predeterminada
nvm alias default lts/*
nvm use default

# Verificar las versiones instaladas
echo "   Verificación de versiones:"
node -v
npm -v

# --- 4. INSTALAR PNPM ---
# Se utiliza npm para instalar pnpm
echo "=> 4. Instalando pnpm globalmente..."
npm install -g pnpm

# Verificar la instalación de pnpm
echo "   Verificación de pnpm:"
pnpm -v

# --- 5. FINISH & NEXT STEPS ---
echo ""
echo "========================================================"
echo "      INSTALACIÓN DE NODE.JS, NPM y PNPM COMPLETADA.    "
echo "========================================================"
echo "Nota Importante:"
echo "Para usar 'nvm', 'node', 'npm' o 'pnpm' en una nueva sesión de terminal,"
echo "debes ejecutar el comando 'source ~/.bashrc' (o 'source ~/.zshrc' si usas Zsh)"
echo "o simplemente, CIERRA Y VUELVE A ABRIR la terminal/sesión SSH."
echo ""

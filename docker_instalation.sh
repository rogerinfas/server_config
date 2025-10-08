#!/bin/bash

# Este script instala Docker Engine en Ubuntu desde el repositorio oficial.
# Diseñado para Ubuntu 24.04 (Noble) y posteriores.

# --- 1. CONFIGURACIÓN INICIAL ---
echo "=> 1. Actualizando lista de paquetes e instalando dependencias necesarias..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# --- 2. ELIMINAR VERSIONES ANTIGUAS/CONFLICTIVAS ---
echo "=> 2. Eliminando paquetes conflictivos existentes (si los hay)..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg 2>/dev/null
done
# NOTA: apt-get puede reportar que algunos no estaban instalados. Esto es normal.

# --- 3. CONFIGURAR EL REPOSITORIO OFICIAL DE DOCKER ---

# A. Limpiar configuraciones anteriores de Docker si existen
if [ -f /etc/apt/sources.list.d/docker.list ]; then
    echo "   Eliminando archivo de repositorio de Docker anterior..."
    sudo rm /etc/apt/sources.list.d/docker.list
fi

# B. Agregar la clave GPG
echo "   Configurando clave GPG..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# C. Agregar el repositorio de Docker a las fuentes de apt
echo "   Agregando el repositorio de Docker para Ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME")..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# D. Actualizar la lista de paquetes con el nuevo repositorio
echo "   Actualizando la lista de paquetes de APT..."
sudo apt-get update

# --- 4. INSTALACIÓN DE DOCKER ENGINE ---
echo "=> 4. Instalando Docker Engine, CLI, containerd y plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 5. VERIFICACIÓN Y POST-INSTALACIÓN (OPCIONAL) ---
echo "=> 5. Verificando la instalación..."
sudo docker run hello-world

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================================"
    echo " ¡INSTALACIÓN DE DOCKER COMPLETADA CON ÉXITO! "
    echo "========================================================"
    echo ""
    echo "=> Paso Siguiente (Recomendado): Ejecutar Docker sin 'sudo'"
    echo "Para poder usar 'docker' sin el prefijo 'sudo', ejecuta:"
    echo "  sudo usermod -aG docker $USER"
    echo "Luego, CIERRA Y VUELVE A ABRIR la sesión SSH o la terminal."
else
    echo "========================================================"
    echo " ERROR: La verificación de 'hello-world' falló."
    echo " Por favor, revisa el output anterior."
    echo "========================================================"
fi

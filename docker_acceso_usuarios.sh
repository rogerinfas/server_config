#!/bin/bash

# Este script añade al usuario actual al grupo 'docker'
# para permitir la ejecución de comandos de Docker sin usar 'sudo'.

# Asegúrate de que solo se ejecute con un usuario válido
if [ -z "$USER" ] || [ "$USER" == "root" ]; then
    echo "ERROR: Por favor, ejecuta este script como el usuario que deseas añadir al grupo 'docker'."
    echo "No debe ejecutarse como 'root'."
    exit 1
fi

echo "=> 1. Agregando el usuario '$USER' al grupo 'docker'..."
sudo usermod -aG docker $USER

if [ $? -eq 0 ]; then
    echo "   ¡Usuario '$USER' agregado al grupo 'docker' con éxito!"
    echo ""
    echo "========================================================"
    echo "          PASO FINAL REQUERIDO: CERRAR SESIÓN          "
    echo "========================================================"
    echo "Para que los cambios de grupo surtan efecto (y puedas usar Docker sin 'sudo'):"
    echo "1. Cierra la sesión SSH (o terminal) actual."
    echo "2. Vuelve a iniciar sesión."
    echo ""
    echo "Después de iniciar sesión de nuevo, prueba con: docker run hello-world"
else
    echo "ERROR: Algo salió mal al intentar agregar el usuario al grupo 'docker'."
fi

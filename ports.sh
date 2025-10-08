#!/bin/bash
# ================================
# Script para abrir puertos comunes
# en Ubuntu Server 24 (ufw firewall)
# ================================

echo "🔧 Verificando instalación de UFW..."
if ! command -v ufw &> /dev/null
then
    echo "⚠️ UFW no está instalado. Instalando..."
    sudo apt update -y && sudo apt install ufw -y
fi

echo "✅ UFW instalado correctamente."

# Habilitar firewall si no está activo
echo "🔒 Activando firewall (ufw enable)..."
sudo ufw enable

echo "🔓 Abriendo puertos necesarios..."

# SSH
sudo ufw allow 22/tcp comment 'Permitir SSH'

# MongoDB (puerto por defecto)
sudo ufw allow 27017/tcp comment 'Permitir MongoDB'

# React / Next.js
sudo ufw allow 3000/tcp comment 'Permitir frontend React/Next'

# NestJS / backend
sudo ufw allow 5000/tcp comment 'Permitir backend NestJS'

# Mostrar reglas activas
echo "📋 Reglas activas del firewall:"
sudo ufw status numbered

echo "✅ Todos los puertos fueron habilitados correctamente."

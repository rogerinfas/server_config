#!/bin/bash
# ============================================
# Script para abrir puertos comunes en Ubuntu Server 24 (ufw firewall)
# Autor: RogerDev
# ============================================

echo "🔧 Verificando instalación de UFW..."
if ! command -v ufw &> /dev/null; then
    echo "⚠️ UFW no está instalado. Instalando..."
    sudo apt update -y && sudo apt install ufw -y
else
    echo "✅ UFW ya está instalado."
fi

# Verificar estado actual
UFW_STATUS=$(sudo ufw status | grep -o "Status: active")

if [[ "$UFW_STATUS" == "Status: active" ]]; then
    echo "🟢 UFW ya está activo."
else
    echo "🔒 Activando firewall (ufw enable)..."
    sudo ufw --force enable
    echo "✅ Firewall activado."
fi

echo ""
echo "🔍 Verificando reglas existentes antes de agregarlas..."

declare -A PORTS=(
    [22]="Permitir SSH"
    [27017]="Permitir MongoDB"
    [3000]="Permitir frontend React/Next"
    [5000]="Permitir backend NestJS"
)

for PORT in "${!PORTS[@]}"; do
    if sudo ufw status | grep -q "$PORT/tcp"; then
        echo "⚙️  Puerto $PORT ya está permitido (${PORTS[$PORT]})."
    else
        echo "➕ Agregando regla para puerto $PORT (${PORTS[$PORT]})..."
        sudo ufw allow "$PORT/tcp" comment "${PORTS[$PORT]}"
    fi
done

echo ""
echo "📋 Reglas activas del firewall:"
sudo ufw status numbered

echo ""
echo "🧠 Verificando configuración SSH (conexiones simultáneas)..."
SSHD_CONFIG="/etc/ssh/sshd_config"

if grep -q "^MaxSessions" $SSHD_CONFIG && grep -q "^MaxStartups" $SSHD_CONFIG; then
    echo "✅ Configuración de múltiples sesiones SSH ya presente."
else
    echo "⚠️ Configuración SSH no optimizada. Se recomienda editar manualmente con:"
    echo "    sudo nano /etc/ssh/sshd_config"
    echo "Y agregar o verificar:"
    echo "    MaxSessions 10"
    echo "    MaxStartups 10:30:100"
fi

echo ""
echo "✅ Configuración completa. Todos los puertos fueron verificados o habilitados correctamente."

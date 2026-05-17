#!/bin/bash

# Configuración de colores para una terminal clara e informativa
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

echo -e "${GREEN}=== Iniciando Instalador de Translate CLI v1.0.1 ===${NC}"

# 1. DETECCIÓN DEL ENTORNO (Móvil vs Ordenador)
if [ -n "$TERMUX_VERSION" ]; then
    echo -e "${YELLOW}[Entorno detectado: Móvil (Termux)]${NC}"
    echo "Procediendo con la instalación segura del paquete .deb..."
    
    # Actualización e instalación local en Termux
    pkg update -y && pkg install -y python ndk-sysroot clang make libffi
    pip install deep-translator
    
    # Descarga e instala el binario compilado local
    curl -LO https://github.com/Alejandro-coding-pixel/translate-cli/main/translate-pkg.deb
    dpkg -i translate-pkg.deb
    rm translate-pkg.deb
    
    echo -e "${GREEN}¡Instalación completada con éxito en Termux!${NC}"
    echo "Ya puedes usar el comando: translate"

else
    # 2. ENTORNO: ORDENADOR (Windows con Git Bash)
    echo -e "${YELLOW}[Entorno detectado: Ordenador (Windows / Git Bash)]${NC}"
    echo "Iniciando comprobaciones de seguridad..."

    # Comprobación precavida Nivel 1: ¿Existe Python en el sistema?
    if ! command -v python &> /dev/null && ! command -v python3 &> /dev/null; then
        echo -e "${RED}[ERROR DE SEGURIDAD] Python 3 no está instalado en este ordenador.${NC}"
        echo "Para proteger tu sistema, la instalación se ha detenido."
        echo "Por favor, descarga e instala Python desde: https://www.python.org/"
        echo "Asegúrate de marcar la casilla 'Add python.exe to PATH' durante la instalación."
        exit 1
    fi

    # Determinar si el comando correcto es python o python3
    PYTHON_CMD="python"
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    fi

    echo -e "${GREEN}[OK] Python detectado correctamente.${NC}"

    # Comprobación precavida Nivel 2: Instalar la librería requerida de forma segura
    echo "Instalando la dependencia 'deep-translator'..."
    $PYTHON_CMD -m pip install --upgrade pip &> /dev/null
    $PYTHON_CMD -m pip install deep-translator

    # Comprobación precavida Nivel 3: Instalación Global en Git Bash
    # Buscamos la carpeta de binarios local de Git Bash en Windows
    BIN_DIR="/usr/bin"
    if [ -d "$BIN_DIR" ]; then
        echo "Descargando el script fuente de Python de forma global..."
        # Descargamos el script directamente en la carpeta de comandos de Git Bash
        curl -sL https://raw.githubusercontent.com/Alejandro-coding-pixel/translate-cli/main/translate -o "$BIN_DIR/translate"
        # Concedemos permisos de ejecución seguros
        chmod +x "$BIN_DIR/translate"
        
        echo -e "${GREEN}¡Instalación global completada con éxito en Windows!${NC}"
        echo "Tu padre ya puede abrir cualquier terminal de Git Bash y escribir: translate"
    else
        echo -e "${RED}[ERROR] No se pudo encontrar la ruta global /usr/bin en Git Bash.${NC}"
        exit 1
    fi
fi


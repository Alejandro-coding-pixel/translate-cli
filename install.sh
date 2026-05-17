#!/usr/bin/env bash

# ==============================================================================
# Script de Instalación Pública para la App de Traducción v1.0.1
# Repositorio Oficial: github.com/alejandro-coding-pixel/translate-cli
# ==============================================================================

# Configuración de la ruta de descarga apuntando a tu usuario de GitHub
USER_GITHUB="alejandro-coding-pixel"
REPO_GITHUB="translate-cli"
URL_DEL_PAQUETE="https://raw.githubusercontent.com/${USER_GITHUB}/${REPO_GITHUB}/main/translate-pkg.deb"
DIRECTORIO_TEMPORAL="$HOME/tmp_translate_install"

echo "[*] Iniciando instalador público para 'translate'..."

# 1. Actualización e instalación de dependencias nativas de Termux
echo "[*] Configurando entornos de ejecución (python, pip)..."
pkg update -y && pkg install python python-pip curl -y

# 2. Instalación de dependencias de empaquetado de Python
echo "[*] Instalando librería de traducción 'deep-translator'..."
pip install deep-translator

# 3. Creación del entorno aislado de descarga
mkdir -p "$DIRECTORIO_TEMPORAL"
cd "$DIRECTORIO_TEMPORAL" || exit 1

# 4. Simulación/Descarga del paquete binario
echo "[*] Descargando paquete .deb desde el repositorio de @${USER_GITHUB}..."
if [[ "$1" == "--test" ]]; then
    echo "[Modo Test]: Saltando descarga real de red. Creando simulación local..."
    touch translate-pkg.deb
else
    curl -sL "$URL_DEL_PAQUETE" -o translate-pkg.deb
fi

# 5. Despliegue en el sistema operativo (Solo si el archivo no está vacío)
if [ -s translate-pkg.deb ] && [ "$1" != "--test" ]; then
    echo "[*] Instalando paquete en el sistema..."
    pkg install ./translate-pkg.deb -y
else
    echo "[Modo Test]: Simulación de instalación completada con éxito."
fi

# 6. Limpieza profunda del almacenamiento temporal
cd "$HOME" || exit 1
rm -rf "$DIRECTORIO_TEMPORAL"

echo "------------------------------------------------------------"
echo "[¡Felicidades!] El flujo del script ha finalizado con éxito."
echo "------------------------------------------------------------"


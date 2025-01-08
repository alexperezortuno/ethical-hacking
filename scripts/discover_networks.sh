#!/bin/bash

# Verificar que aircrack-ng esté instalado
if ! command -v airodump-ng &>/dev/null; then
    echo "Error: airodump-ng no está instalado. Instálalo antes de ejecutar este script."
    exit 1
fi

echo "Detectando interfaces inalámbricas disponibles..."
airmon-ng | grep "Interface" -A 10

# Pedir al usuario que seleccione la interfaz
read -p "Ingrese la interfaz que desea usar (e.g., wlan0): " INTERFACE

echo "Habilitando modo monitor en la interfaz $INTERFACE..."
airmon-ng start $INTERFACE

# Cambiar el nombre de la interfaz al modo monitor
MON_INTERFACE="${INTERFACE}mon"

echo "Escaneando redes Wi-Fi disponibles..."
airodump-ng $MON_INTERFACE &
SCAN_PID=$!

# Esperar unos segundos para capturar datos
sleep 10
kill $SCAN_PID

# Pedir al usuario seleccionar los valores
echo "Redes disponibles detectadas:"
echo "Por favor, selecciona los valores correctos para los parámetros."

# Escanear y guardar las redes detectadas
OUTPUT_FILE="networks.txt"
airodump-ng --output-format csv -w scan_results $MON_INTERFACE
cat scan_results-01.csv | grep -E "^[0-9A-F]{2}(:[0-9A-F]{2}){5}" > $OUTPUT_FILE

echo "Las siguientes redes están disponibles:"
awk -F',' '{print NR, "- SSID:", $14, "BSSID:", $1, "Channel:", $4}' $OUTPUT_FILE

read -p "Selecciona el número de la red: " NETWORK_INDEX
NETWORK_INFO=$(awk -v idx=$NETWORK_INDEX 'NR==idx {print $0}' $OUTPUT_FILE)

# Extraer valores seleccionados
BSSID=$(echo $NETWORK_INFO | awk -F',' '{print $1}')
CHANNEL=$(echo $NETWORK_INFO | awk -F',' '{print $4}')
SSID=$(echo $NETWORK_INFO | awk -F',' '{print $14}')

echo "Red seleccionada:"
echo "BSSID: $BSSID"
echo "Canal: $CHANNEL"
echo "Nombre de la Red (SSID): $SSID"

# Escanear clientes conectados a la red seleccionada
echo "Escaneando clientes conectados a la red $SSID..."
airodump-ng -c $CHANNEL --bssid $BSSID -w client_scan $MON_INTERFACE &
SCAN_PID=$!

sleep 10
kill $SCAN_PID

# Mostrar clientes detectados
CLIENT_FILE="client_scan-01.csv"
cat $CLIENT_FILE | grep -E "^[0-9A-F]{2}(:[0-9A-F]{2}){5}" | awk -F',' '{print NR, "- CLIENTE:", $1}'

read -p "Selecciona el número del cliente objetivo (o presiona Enter para omitir): " CLIENT_INDEX
if [ -n "$CLIENT_INDEX" ]; then
    CLIENT_MAC=$(awk -v idx=$CLIENT_INDEX 'NR==idx {print $1}' $CLIENT_FILE)
    echo "Cliente seleccionado: $CLIENT_MAC"
else
    CLIENT_MAC="Sin cliente específico"
fi

# Limpiar archivos temporales
rm -f scan_results-* client_scan-*

# Mostrar resumen
echo "Valores seleccionados:"
echo "INTERFACE: $MON_INTERFACE"
echo "NETWORK_NAME: $SSID"
echo "BSSID: $BSSID"
echo "CHANNEL: $CHANNEL"
echo "CLIENTE: $CLIENT_MAC"

# Guardar en archivo para pasarlos fácilmente al script principal
echo "INTERFACE=$MON_INTERFACE" > network_params.env
echo "NETWORK_NAME=\"$SSID\"" >> network_params.env
echo "BSSID=$BSSID" >> network_params.env
echo "CHANNEL=$CHANNEL" >> network_params.env
echo "CLIENTE=$CLIENT_MAC" >> network_params.env

echo "Los valores se han guardado en el archivo 'network_params.env'. Puedes pasarlos al script principal."

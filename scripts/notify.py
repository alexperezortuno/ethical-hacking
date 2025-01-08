import requests
import sys

if len(sys.argv) != 3:
    print("Uso: python3 notify.py <webhook_url> <mensaje>")
    sys.exit(1)

webhook_url = sys.argv[1]
message = sys.argv[2]

payload = {"text": message}

response = requests.post(webhook_url, json=payload)
if response.status_code == 200:
    print("Notificación enviada con éxito.")
else:
    print("Error al enviar notificación:", response.text)

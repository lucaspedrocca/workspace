#!/usr/bin/env python3
import subprocess
import time

# Reemplaza con la IP y puerto que deseas monitorear
ip_address = "172.30.222.60"
port = "3007"

print(f"Monitoreando conexiones en el puerto {port} para la IP {ip_address}...")

while True:
    # Ejecutar netstat y filtrar por IP y puerto
    result = subprocess.run(["netstat", "-an"], capture_output=True, text=True)
    
    # Buscar el patrón de IP y puerto en la salida de netstat
    connection_active = f"{ip_address}:{port}" in result.stdout
    
    if connection_active:
        print(f"Conexión activa detectada en {ip_address}:{port}")
    else:
        print(f"No hay conexión activa en {ip_address}:{port}")
    
    # Esperar 1 segundo antes de volver a comprobar
    time.sleep(0.1)

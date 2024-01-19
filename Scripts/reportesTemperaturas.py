import requests
import datetime
import time

def obtener_informacion():
    # Aquí debes colocar el código para obtener la información de la página web
    # Puedes usar la librería requests para hacer la solicitud HTTP

    # Por ejemplo, puedes hacer una solicitud GET a la URL de la página
    response = requests.get('https://www.example.com')

    # Aquí debes procesar la respuesta y extraer la información que necesitas

    # Por ejemplo, puedes obtener la información actual y la hora actual
    informacion = response.text
    hora_actual = datetime.datetime.now()

    # Aquí debes guardar la información y la hora en un archivo o base de datos
    # Puedes usar la librería datetime para formatear la hora actual como string

    # Por ejemplo, puedes guardar la información en un archivo de texto
    with open('informacion.txt', 'a') as archivo:
        archivo.write(f'{hora_actual}: {informacion}\n')

while True:
    obtener_informacion()
    time.sleep(3600)  # Esperar una hora (3600 segundos) antes de obtener la siguiente información

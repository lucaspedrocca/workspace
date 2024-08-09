import os

# Pedir al usuario que introduzca el nombre de usuario a buscar
usuario = input("Por favor, introduce el nombre de usuario que deseas filtrar: ")

# Ruta al archivo de eventos
ruta_archivo = r"Scripts\Prominente\Scripts bloqueos\logs\09_55-09-08-2024-SecurityEventsPromi.txt"

# Ruta para guardar el archivo filtrado
ruta_archivo_filtrado = r"Scripts\Prominente\Scripts bloqueos\09_55-09-08-2024-SecurityEventsPromi-{}.txt".format(usuario)

# Leer el archivo completo
with open(ruta_archivo, 'r') as archivo:
    lineas = archivo.readlines()

# Inicializar variables
eventos_filtrados = []
evento_actual = []

# Iterar sobre cada línea en el archivo
for linea in lineas:
    # Si la línea comienza con "Event[" es el comienzo de un nuevo evento
    if linea.startswith("Event["):
        # Si el evento actual contiene el nombre del usuario, lo agregamos a la lista de eventos filtrados
        if any(f"Account Name:\t\t{usuario}" in l for l in evento_actual):
            eventos_filtrados.extend(evento_actual)
        # Resetear el evento actual para el siguiente evento
        evento_actual = []
    # Agregar la línea actual al evento en curso
    evento_actual.append(linea)

# Capturar el último evento en caso de que el archivo no termine con un evento nuevo
if any(f"Account Name:\t\t{usuario}" in l for l in evento_actual):
    eventos_filtrados.extend(evento_actual)

# Guardar los eventos filtrados en un nuevo archivo
with open(ruta_archivo_filtrado, 'w') as archivo_filtrado:
    archivo_filtrado.writelines(eventos_filtrados)

# Confirmar si se escribió el archivo filtrado correctamente
if os.path.exists(ruta_archivo_filtrado):
    print(f"Los eventos filtrados se escribieron en {ruta_archivo_filtrado}")
else:
    print("Fallo al escribir los eventos filtrados")

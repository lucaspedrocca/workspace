import requests
import subprocess
import json
import sqlite3

# Crear una base de datos SQLite y una tabla
def create_database():
    conn = sqlite3.connect('servers.db')
    c = conn.cursor()
    
    # Crear tabla
    c.execute('''CREATE TABLE IF NOT EXISTS hostnames (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    empresa TEXT NOT NULL,
                    hostname TEXT NOT NULL)''')
    
    conn.commit()
    conn.close()

create_database()

# URL del archivo JSON
config_url = 'https://raw.githubusercontent.com/lucaspedrocca/workspace/main/CerrarSesiones/hostnames.json'

# Descargar el archivo JSON
response = requests.get(config_url)
if response.status_code == 200:
    hostnames_empresas = response.json()
else:
    print(f"Error al descargar el archivo JSON: {response.status_code}")
    hostnames_empresas = {}

# Opciones generales
consulta_amplia = False
if consulta_amplia:
    consulta_amplia_text = "Activado."
else:
    consulta_amplia_text = "Desactivado."

empresas = list(hostnames_empresas.keys())

opcion_seleccionada = True

while opcion_seleccionada != 8:
    # Menu de opciones
    print("Seleccione una opción: \n")
    
    for empresa in empresas:
        posicion = empresas.index(empresa) + 1
        print(f"{posicion}- {empresa}")
    
    print(f"7- Consulta Amplia - {consulta_amplia_text}\n8- Salir")

    opcion_seleccionada = input("Ingrese una opción: ")

    try:
        opcion_seleccionada = int(opcion_seleccionada)
    except:
        print("\nIngrese una opción valida.\n")
        continue

    if opcion_seleccionada in range(1,7):
        empresa_seleccionada = empresas[opcion_seleccionada - 1]
        
        # Usuario el cual se va a realizar la consulta
        usuario_ingresado = str(input("Ingrese el nombre del usuario: "))

        # Lista de servidores donde se va a realizar la consulta
        servidores_consulta = hostnames_empresas.get(empresa_seleccionada, [])
        # print(servidores_consulta)

        print(f"\nRealizando consultas en los servidores de {empresa_seleccionada} para el usuario {usuario_ingresado}.\n")

        # Ciclo donde se realiza la consulta ejemplo funcional query session /server:brhts06.usuarios.local | findstr /i "jocorrea"
        for servidor in servidores_consulta:
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

            # Declaracion de sesiones
            sesion_encontrada = resultado.stdout
            list_sesion_encontrada = sesion_encontrada.split()

            if len(list_sesion_encontrada) >= 2:
                id_sesion_encontrada = int(list_sesion_encontrada[2])
            else:
                id_sesion_encontrada = 99999
            
            # Verificar salida de errores
            if resultado.returncode != 1:
                print(f"{servidor}: Hubo un error en la ejecución {resultado.stderr}.\n")
            
            elif resultado.stdout == "":
                print(f"{servidor}: El usuario no esta logueado.")
                if consulta_amplia:
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    print(f"{servidor}{resultado_completo.stdout}\n")
            
            else:
                print(f"{servidor}:{sesion_encontrada}")

                cerrar_sesion = int(input("¿Quiere cerrar la sesion encontrada?(1- Cerrar, 2- No cerrar): "))
                
                if cerrar_sesion == 1:
                    while resultado.stdout != "":
                        cierre_sesion_powershell = f"reset session {id_sesion_encontrada} /server:{servidor}"
                        ejecucion_cierre = subprocess.run(['powershell', '-Command', cierre_sesion_powershell], capture_output=True, text=True)
                        resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                        resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

                        print(f"{servidor}: Se cerro la sesion de {usuario_ingresado}.")

                        if consulta_amplia:
                            print(f"{servidor}{resultado_completo.stdout}\n")

                else:
                    print("...")
        
    elif opcion_seleccionada == 7:
        consulta_amplia = not(consulta_amplia)
        if consulta_amplia:
            consulta_amplia_text = "Activado"
        else:
            consulta_amplia_text = "Desactivado"
        print(f"Consulta Amplia - {consulta_amplia_text}")

    elif opcion_seleccionada == 8:
        break
        
    else:
        print("Ingrese una opción valida.")
        continue

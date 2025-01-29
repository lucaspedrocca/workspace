#!/usr/bin/env python3
import json
import os
import subprocess
import re


# Función para limpiar la pantalla

def clear_screen():
    # Limpiar la pantalla en CMD
    if os.name == 'nt':
        os.system('cls')
    # Limpiar la pantalla en PowerShell
    os.system('powershell -Command "Clear-Host"')

# Llamar a la función para limpiar la pantalla
clear_screen()

#Firma creador

print("""
----------------------------------------
        LogOFF by Lucas Pedrocca        
----------------------------------------
""")

# Obtener la ruta del archivo JSON
base_path = os.path.dirname(os.path.abspath(__file__))
json_path = os.path.join(base_path, 'hostnames.json')


# Funciones para leer y escribir el archivo JSON
def load_hostnames():
    try:
        with open(json_path, 'r', encoding='utf-8') as file:
            data = json.load(file)
            # Normalizar nombres de empresas a mayúsculas
            normalized_data = {k.upper(): v for k, v in data.items()}
            return normalized_data
    except FileNotFoundError:
        print(f"El archivo '{json_path}' no se encontró.")
        return {}
    except json.JSONDecodeError:
        print("Error al decodificar el archivo JSON.")
        return {}
    except Exception as e:
        print(f"Se produjo un error al leer el archivo JSON: {e}")
        return {}

def save_hostnames(hostnames_empresas):
    try:
        with open(json_path, 'w', encoding='utf-8') as file:
            # Normalizar nombres de empresas a mayúsculas
            normalized_data = {k.upper(): v for k, v in hostnames_empresas.items()}
            json.dump(normalized_data, file, indent=4)
        print("Archivo guardado exitosamente.")
    except Exception as e:
        print(f"Error al guardar el archivo: {e}")

def show_servers_for_company(company_name):
    """Muestra la lista de servidores para una empresa específica."""
    company_name = company_name.upper()
    if company_name in hostnames_empresas:
        print(f"\nLista de servidores para {company_name}:")
        for server in hostnames_empresas[company_name]:
            print(f"- {server}")
    else:
        print(f"\nNo hay servidores registrados para {company_name}.")
        

def display_hostnames_json():
    """Muestra el contenido completo del archivo JSON."""
    try:
        print("\nContenido del archivo hostnames.json:")
        with open(json_path, 'r', encoding='utf-8') as file:
            content = json.load(file)
            # Normalizar nombres de empresas a mayúsculas para la visualización
            for company, servers in content.items():
                print(f"\n{company.upper()}:")
                for server in servers:
                    print(f" - {server}")
    except FileNotFoundError:
        print(f"El archivo '{json_path}' no se encontró.")
    except json.JSONDecodeError:
        print("Error al decodificar el archivo JSON.")
    except Exception as e:
        print(f"Se produjo un error al leer el archivo JSON: {e}")

def handle_company_query(empresa_consultar):
    """Maneja la consulta de una empresa específica o muestra el contenido completo del archivo JSON."""
    empresa_consultar = empresa_consultar.upper()
    if empresa_consultar in hostnames_empresas:
        show_servers_for_company(empresa_consultar)
    elif empresa_consultar == "ALL":
        display_hostnames_json()  # Mostrar el contenido del archivo JSON
    else:
        print("Ingrese un valor válido.")

# Inicializar hostnames desde el archivo JSON
hostnames_empresas = load_hostnames()

consulta_amplia = True
opcion_seleccionada = True

while opcion_seleccionada != 12:
    empresas = list(hostnames_empresas.keys())
    conteo_empresas = len(empresas)
    
    #Normalizacion de consultas extras a las empresas
    consulta_amplia_text = "Activado" if consulta_amplia else "Desactivado" 
    diccionario_consultas_extras = {'A':'Todos',
                                    'C':f'Consulta amplia - {consulta_amplia_text}',
                                    'E':'Editar servidores',
                                    'Z':'Salir'}
    
    # consultas_extras = ['E':'Todos','C':f'Consulta amplia - {consulta_amplia_text}', 'Editar servidores', 'Salir']

    print("\nSeleccione una opción: \n")
    
    # Listado empresas
    list_empresas_menu = []
    for empresa in empresas:
        posicion = empresas.index(empresa) + 1
        print(f"{posicion}- {empresa}")
        # list_empresas_menu += (f"{posicion}- {empresa}")
    # print(list_empresas_menu)
        
    print("")
    
    # Listado opciones extra
    for key, value in diccionario_consultas_extras.items():
        print(f"{key}- {value}")
        
    opcion_seleccionada = input("Ingrese una opción: ")
    
    
    # # Menu de opciones
    # menu_opciones = f"""
    # Seleccione una opción:
    # {"\n".join(list_empresas_menu)}    
    # """

    # # print(f"menu de opciones{menu_opciones}")


    try:
        opcion_seleccionada = int(opcion_seleccionada)
            
    except:
        opcion_seleccionada = opcion_seleccionada.upper()
        if opcion_seleccionada not in diccionario_consultas_extras.keys():
            print("\nIngrese una opción valida.\n")
            continue

        # else:
        #     print("\nIngrese una opción valida.\n")
        #     continue
    
    if opcion_seleccionada in range(1, conteo_empresas + 1) or opcion_seleccionada == "A":
        usuario_ingresado = str(input("Ingrese el nombre del usuario: "))
        
        # Opcion Extra: Todos
        if opcion_seleccionada == "A":
            empresa_seleccionada = "Todos"
            servidores_consulta = [item for items in hostnames_empresas.values() for item in items]
        
        # Consulta general
        else:
            empresa_seleccionada = empresas[opcion_seleccionada - 1]
            servidores_consulta = hostnames_empresas[empresa_seleccionada]
            

        print(f"\nRealizando consultas en los servidores de {empresa_seleccionada} para el usuario {usuario_ingresado}.\n")

        for servidor in servidores_consulta:
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

            sesion_encontrada = resultado.stdout
            list_sesion_encontrada = sesion_encontrada.split()

            if len(list_sesion_encontrada) > 0:
                if re.match(r"rdp-tcp#\d+",list_sesion_encontrada[0]):
                    try:
                        id_sesion_encontrada = int(list_sesion_encontrada[2])
                    except ValueError:
                        print(f"No se pudo convertir el valor '{list_sesion_encontrada[2]}' a un número entero.")
                        id_sesion_encontrada = None
                else:
                    try:
                        id_sesion_encontrada = int(list_sesion_encontrada[1])
                    except ValueError:
                        print(f"No se pudo convertir el valor '{list_sesion_encontrada[1]}' a un número entero.")
                        id_sesion_encontrada = None

            if resultado.returncode != 1 or resultado.stderr != "":
                print(f"{servidor}: Hubo un error en la ejecución {resultado.stderr}\n")
                
            elif resultado.stdout == "":                
                if consulta_amplia:
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    print(f"{servidor}{resultado_completo.stdout}\n")
                    
                print(f"{servidor}: El usuario {usuario_ingresado} no está logueado.")
            
            else:
                print(f"{servidor}: {sesion_encontrada}")
                if id_sesion_encontrada is not None:
                    while True:
                        cerrar_sesion = input("¿Quiere cerrar la sesión encontrada? (1- Cerrar, 2- No cerrar): ")
                        if cerrar_sesion in ["1", "2"]:
                            cerrar_sesion = int(cerrar_sesion)
                            break
                        else:
                            print("Entrada no válida. Por favor ingrese 1 para cerrar o 2 para no cerrar.")
                
                    if cerrar_sesion == 1:
                        while resultado.stdout != "":
                            cierre_sesion_powershell = f"reset session {id_sesion_encontrada} /server:{servidor}"
                            ejecucion_cierre = subprocess.run(['powershell', '-Command', cierre_sesion_powershell], capture_output=True, text=True)
                            resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

                            print(f"{servidor}: Se cerró la sesión de {usuario_ingresado}.")
                            if consulta_amplia:
                                print(f"{servidor}{resultado_completo.stdout}\n")
                    else:
                        print("...")
                else:
                    print("No se encontró un ID de sesión válido.")
        
    
    #* Validacion si es alguna de las opciones extras definidas en diccionario_consultas_extras
    
    elif opcion_seleccionada in diccionario_consultas_extras.keys():
        # opcion_seleccionada = opcion_seleccionada.Upper()
        # print(f"cuando se seleciona la opcion {opcion_seleccionada}")
        
        #? Opcion Extra: Consulta amplia - Activado
        if opcion_seleccionada == "C":
            consulta_amplia = not consulta_amplia
            consulta_amplia_text = "Activado" if consulta_amplia else "Desactivado"
        
        #? Opcion Extra: Editar servidores
        elif opcion_seleccionada == "E":
            print("\n1- Añadir Servidor\n2- Eliminar Servidor\n3- Consultar hostnames\n4- Volver")
            sub_opcion = input("Seleccione una opción: ")

            try:
                sub_opcion = int(sub_opcion)
            except:
                print("\nIngrese una opción valida.\n")
                continue

            if sub_opcion == 1:
                empresa_nueva = input("Ingrese el nombre de la empresa: ").upper()
                handle_company_query(empresa_nueva)
                hostname_nuevo = input("Ingrese el hostname del servidor: ")

                if empresa_nueva in hostnames_empresas:
                    hostnames_empresas[empresa_nueva].append(hostname_nuevo)
                else:
                    hostnames_empresas[empresa_nueva] = [hostname_nuevo]
                save_hostnames(hostnames_empresas)
                print(f"Servidor {hostname_nuevo} añadido a {empresa_nueva}.")
                show_servers_for_company(empresa_nueva)  # Mostrar la lista actualizada

            elif sub_opcion == 2:
                empresa_eliminar = input("Ingrese el nombre de la empresa: ").upper()
                handle_company_query(empresa_eliminar)
                hostname_eliminar = input("Ingrese el hostname del servidor: ")
                
                if empresa_eliminar in hostnames_empresas and hostname_eliminar in hostnames_empresas[empresa_eliminar]:
                    hostnames_empresas[empresa_eliminar].remove(hostname_eliminar)
                
                    if not hostnames_empresas[empresa_eliminar]:
                        del hostnames_empresas[empresa_eliminar]
                    save_hostnames(hostnames_empresas)
                    print(f"Servidor {hostname_eliminar} eliminado de {empresa_eliminar}.")
                    show_servers_for_company(empresa_eliminar)  # Mostrar la lista actualizada
                    continue
                
                else:
                    print(f"Servidor {hostname_eliminar} no encontrado en {empresa_eliminar}.")
                    continue

            elif sub_opcion == 3:
                empresa_consultar = input("Ingrese el nombre de la empresa(ALL): ").upper()
                handle_company_query(empresa_consultar)
        
        #? Opcion Extra: Salir
        elif opcion_seleccionada == "Z":
            break

    #* Opciones no validas 
    else:
        print("Ingrese una opción valida.")
        continue

import json
import os
import subprocess

# Funciones para leer y escribir el archivo JSON
def load_hostnames():
    with open('hostnames.json', 'r') as file:
        data = json.load(file)
        # Normalizar nombres de empresas a mayúsculas
        normalized_data = {k.upper(): v for k, v in data.items()}
        return normalized_data

def save_hostnames(hostnames_empresas):
    try:
        with open('CerrarSesiones/hostnames.json', 'w') as file:
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
    print("\nContenido del archivo hostnames.json:")
    with open('CerrarSesiones/hostnames.json', 'r') as file:
        content = json.load(file)
        # Normalizar nombres de empresas a mayúsculas para la visualización
        for company, servers in content.items():
            print(f"\n{company.upper()}:")
            for server in servers:
                print(f" - {server}")

def handle_company_query(empresa_consultar):
    #Maneja la consulta de una empresa específica o muestra el contenido completo del archivo JSON.
    if empresa_consultar in hostnames_empresas:
        show_servers_for_company(empresa_consultar)
    elif empresa_consultar == "ALL":
        display_hostnames_json()  # Mostrar el contenido del archivo JSON
    else:
        print("Ingrese un valor valido.")

# Inicializar hostnames desde el archivo JSON
hostnames_empresas = load_hostnames()

consulta_amplia = False
opcion_seleccionada = True

while opcion_seleccionada != 9:
    empresas = list(hostnames_empresas.keys())
    conteo_empresas = len(empresas)
    consulta_amplia_text = "Activado." if consulta_amplia else "Desactivado." 
    consultas_extras = [f'Consulta amplia - {consulta_amplia_text}', 'Editar servidores', 'Salir']

    print("\nSeleccione una opción: \n")
    for empresa in empresas:
        posicion = empresas.index(empresa) + 1
        print(f"{posicion}- {empresa}")
    
    for consulta in consultas_extras:
        posicion_consulta = consultas_extras.index(consulta) + 1
        print(f"{posicion_consulta + conteo_empresas}- {consulta}")
        

    opcion_seleccionada = input("Ingrese una opción: ")

    try:
        opcion_seleccionada = int(opcion_seleccionada)
    except:
        print("\nIngrese una opción valida.\n")
        continue

    if opcion_seleccionada in range(1, conteo_empresas + 1):
        empresa_seleccionada = empresas[opcion_seleccionada - 1]
        usuario_ingresado = str(input("Ingrese el nombre del usuario: "))
        servidores_consulta = hostnames_empresas[empresa_seleccionada]

        print(f"\nRealizando consultas en los servidores de {empresa_seleccionada} para el usuario {usuario_ingresado}.\n")

        for servidor in servidores_consulta:
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

            sesion_encontrada = resultado.stdout
            list_sesion_encontrada = sesion_encontrada.split()

            if len(list_sesion_encontrada) >= 2:
                id_sesion_encontrada = int(list_sesion_encontrada[2])
            else:
                id_sesion_encontrada = 99999

            if resultado.returncode != 1:
                print(f"{servidor}: Hubo un error en la ejecución {resultado.stderr}.\n")
            
            elif resultado.stdout == "":
                print(f"{servidor}: El usuario no está logueado.")
                if consulta_amplia:
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    print(f"{servidor}{resultado_completo.stdout}\n")
            
            else:
                print(f"{servidor}: {sesion_encontrada}")
                cerrar_sesion = int(input("¿Quiere cerrar la sesión encontrada? (1- Cerrar, 2- No cerrar): "))
                
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

    elif opcion_seleccionada == (conteo_empresas + 1):
        consulta_amplia = not consulta_amplia
        consulta_amplia_text = "Activado" if consulta_amplia else "Desactivado"

    elif opcion_seleccionada == (conteo_empresas + 2):
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
            else:
                print(f"Servidor {hostname_eliminar} no encontrado en {empresa_eliminar}.")

        elif sub_opcion == 3:
            empresa_consultar = input("Ingrese el nombre de la empresa(ALL): ").upper()
            handle_company_query(empresa_consultar)

    elif opcion_seleccionada == (conteo_empresas + 3):
        break

    else:
        print("Ingrese una opción valida.")
        continue

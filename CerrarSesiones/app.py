import subprocess
import json
import pkg_resources

# Opciones generales
consulta_amplia = False
if consulta_amplia:
    consulta_amplia_text = "Activado."
else:
    consulta_amplia_text = "Desactivado."

# Cargar hostnames.json desde el paquete
hostnames_path = pkg_resources.resource_filename(__name__, 'hostnames.json')
with open(hostnames_path, 'r') as file:
    hostnames_empresas = json.load(file)

empresas = list(hostnames_empresas.keys())

opcion_seleccionada = True

while opcion_seleccionada != 8:
    # Menú de opciones
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

    if opcion_seleccionada in range(1, 7):
        empresa_seleccionada = empresas[opcion_seleccionada - 1]
        
        # Usuario el cual se va a realizar la consulta
        usuario_ingresado = str(input("Ingrese el nombre del usuario: "))

        # Lista de servidores donde se va a realizar la consulta
        servidores_consulta = hostnames_empresas[empresa_seleccionada]
        # print(servidores_consulta)

        print(f"\nRealizando consultas en los servidores de {empresa_seleccionada} para el usuario {usuario_ingresado}.\n")

        # Ciclo donde se realiza la consulta
        for servidor in servidores_consulta:
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

            # Declaración de sesiones
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
                print(f"{servidor}: El usuario no está logueado.")
                if consulta_amplia:
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    print(f"{servidor}{resultado_completo.stdout}\n")
            
            else:
                # Se imprime todo el resultado de la sesión encontrada
                print(f"{servidor}:{sesion_encontrada}")

                # Se consulta si quiere realizar el reinicio de la sesión
                cerrar_sesion = int(input("¿Quiere cerrar la sesión encontrada?(1- Cerrar, 2- No cerrar): "))
                
                # Se realiza el cierre de sesión en el servidor 
                if cerrar_sesion == 1:
                    # Bucle para cerrar sesión
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
    
    elif opcion_seleccionada == 7:
        consulta_amplia = not consulta_amplia
        consulta_amplia_text = "Activado" if consulta_amplia else "Desactivado"
        print(f"Consulta Amplia - {consulta_amplia_text}")

    elif opcion_seleccionada == 8:
        break
    else:
        print("Ingrese una opción válida.")
        continue

import subprocess

# Opciones generales
consulta_amplia = True
if consulta_amplia:
    consulta_amplia_text = "Activado. Obtienes mas información en cada consulta."
else:
    consulta_amplia_text = "Desactivado. Información mas resumida en cada consulta."
    

# Declaracion de variables para seleccion de empresas

# Definiendo un diccionario para almacenar los hostnames de diferentes empresas
    # ! Agegar modo revision -> Editar base de servidores
hostnames_empresas = {
    'BRH': [
        'brhts100.usuarios.local',
        'brhts101.usuarios.local',
        'brhts05.usuarios.local',
        'brhts06.usuarios.local'
    ],

    'CLIBA': [
        'clibats100.cliba.com.ar',
        'clibats101.cliba.com.ar',
        'clibats102.cliba.com.ar'
    ],

    'EMV': [
        'emvts01.emv.com.ar',
        'emvts02.emv.com.ar',
        'emvts03.emv.com.ar',
        'emvtserp01.emv.com.ar',
        'emvtserp02.emv.com.ar'
    ],

    'HAUG': [
        'haugts100.haug.local',
        'haugts101.haug.local',
        'haugts102.haug.local'
    ],

    'MTV': [
        'mtvts01.metrovias.com.ar',
        'mtvts02.metrovias.com.ar',
        'mtvts03.metrovias.com.ar',
        'mtvts100.metrovias.com.ar',
        'mtvts101.metrovias.com.ar',
        'mtvts102.metrovias.com.ar',
        'mtvts103.metrovias.com.ar'
    ],

    'BRT': [
        'brterp01.brt.com.ar',
        'brterp02.brt.com.ar',
        'brtts101.brt.com.ar',
        'brtts102.brt.com.ar'
    ]
}
empresas = list(hostnames_empresas.keys())

opcion_seleccionada = True

while opcion_seleccionada != 8:
    # Menu de opciones
    print("Seleccione una opción: \n")
    
    for empresa in empresas:
        posicion = empresas.index(empresa) + 1
        print(f"{posicion}- {empresa}")
    
    print("7- Otros\n8- Salir")

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
        servidores_consulta = hostnames_empresas[empresa_seleccionada]
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
                id_sesion_encontrada = int(sesion_encontrada.split()[2])
            else:
                id_sesion_encontrada = 99999
            
            # Imprime el comando que se esta ejecutando
            # print(resultado.args[2])

            # Verificar salida de errores
            if resultado.returncode != 1:
                print(f"{servidor}: Hubo un error en la ejecución {resultado.stderr}.\n")
            
            elif resultado.stdout == "":
                print(f"{servidor}: El usuario no esta logueado.")
                if consulta_amplia:
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    print(f"{servidor}{resultado_completo.stdout}\n")
            
            else:
                # Se imprime todo el resultado de la sesion encontrada
                print(f"{servidor}:{sesion_encontrada}")

                # Se consulta si quiere realizar el reinicio de la sesion
                cerrar_sesion = int(input("¿Quiere cerrar la sesion encontrada?(1- Cerrar, 2- No cerrar): "))
                
                # Se realiza el cierre de sesion en el servidor 
                if cerrar_sesion == 1:

                    # Bucle para cerrar sesion
                    while resultado.stdout != "":
                        cierre_sesion_powershell = f"reset session {id_sesion_encontrada} /server:{servidor}"
                        ejecucion_cierre = subprocess.run(['powershell', '-Command', cierre_sesion_powershell], capture_output=True, text=True)
                        resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                        resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

                        # print(ejecucion_cierre.args[2]) # Cerrando la sesion del usuario...
                        print(f"{servidor}: Se cerro la sesion de {usuario_ingresado}.")

                        if consulta_amplia:
                            print(f"{servidor}{resultado_completo.stdout}\n")

                else:
                    print("...")
        
    elif opcion_seleccionada == 7 :
        
        # Menu opción seleccionada otros
        print(f"\n\nOtras configuraciones:\n1- Modo Edición - Permite editar los servidores a donde se consulta.\n2- Consulta Amplia - {consulta_amplia_text}\n3- Salir \n")    
        opcion_seleccionada_otros = input("Ingrese una opción: ")

        while opcion_seleccionada_otros != 3:
            
            try:
                opcion_seleccionada_otros = int(opcion_seleccionada_otros)
            except:
                print("\nIngrese una opción valida.\n")
                continue
        
            if opcion_seleccionada_otros == 1:
                print("Modo edición")

            elif opcion_seleccionada_otros == 2:
                print("Consulta amplia")            
            
            elif opcion_seleccionada_otros == 3:                
                break

            else:
                print("\nIngrese una opción valida.\n")
                continue




    elif opcion_seleccionada == 8 :
        break
        
    else:
        print("Ingrese una opción valida.")
        continue
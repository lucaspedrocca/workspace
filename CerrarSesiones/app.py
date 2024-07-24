import mysql.connector
import subprocess

# Conectar a la base de datos
db_config = {
    'user': 'cerrarSesiones',
    'password': '10SesionesCerradas.',
    'host': 'PCA1195.prominente.com.ar',
    'database': 'servidores_db',
}

conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Función para obtener los hostnames de los servidores
def get_hostnames(empresa):
    query = "SELECT hostname FROM servidores WHERE empresa = %s"
    cursor.execute(query, (empresa,))
    return [row[0] for row in cursor.fetchall()]

# Opciones generales
consulta_amplia = False
consulta_amplia_text = "Activado." if consulta_amplia else "Desactivado."

empresas = ['BRH', 'CLIBA', 'EMV', 'HAUG', 'MTV', 'BRT']
opcion_seleccionada = True

while opcion_seleccionada != 8:
    print("Seleccione una opción: \n")
    for idx, empresa in enumerate(empresas, 1):
        print(f"{idx}- {empresa}")
    print(f"7- Consulta Amplia - {consulta_amplia_text}\n8- Salir")

    opcion_seleccionada = input("Ingrese una opción: ")

    try:
        opcion_seleccionada = int(opcion_seleccionada)
    except:
        print("\nIngrese una opción valida.\n")
        continue

    if opcion_seleccionada in range(1, 7):
        empresa_seleccionada = empresas[opcion_seleccionada - 1]
        usuario_ingresado = str(input("Ingrese el nombre del usuario: "))
        servidores_consulta = get_hostnames(empresa_seleccionada)
        print(f"\nRealizando consultas en los servidores de {empresa_seleccionada} para el usuario {usuario_ingresado}.\n")

        for servidor in servidores_consulta:
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)

            sesion_encontrada = resultado.stdout
            list_sesion_encontrada = sesion_encontrada.split()

            id_sesion_encontrada = int(list_sesion_encontrada[2]) if len(list_sesion_encontrada) >= 2 else 99999

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
                        subprocess.run(['powershell', '-Command', cierre_sesion_powershell], capture_output=True, text=True)
                        resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                        resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)
                        print(f"{servidor}: Se cerro la sesion de {usuario_ingresado}.")
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
        print("Ingrese una opción valida.")
        continue

cursor.close()
conn.close()

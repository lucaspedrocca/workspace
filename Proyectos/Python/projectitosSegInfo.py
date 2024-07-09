# Find IP and Hostname

import socket

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

print(f"Hostname: {hostname}")
print(f"IP Address: {ip_address}")

# Scan Puertos

objetivo = socket.gethostbyname(input("Ingrese la IP a escanear: "))

print("Escaneando objetivo: " + objetivo)

try:
    for port in range(1, 150):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(1)

        resultado = s.connect_ex((objetivo, port))
        if resultado == 0:
            print("El puerto {} esta abierto".format(port))
        s.close()

except:
    print("\n Saliendo...")
    sys.exit()


# De Decimal a Binario

def binario(decimal):
    binario = ""
    while decimal // 2 != 0:
        binario = str(decimal % 2) + binario
        decimal = decimal // 2
    return str(decimal) + binario

numero = int(input("Ingrese un numero para convertirlo a binario: "))
print(binario(numero))


# Crakear contraseñas

import hashlib

encontrada = 0
input_hash = input("Ingrese la contraseña hasheada: ")
pass_doc = input("Ingrese el archivo de contraseñas: ")

try:
    pass_file = open(pass_doc, 'r')

except:
    print(f"Error pass_doc: {pass_doc} no encontrado")
    quit() 

for palabra in pass_file:
    palabra_cifrada = palabra.encode('utf-8')
    palabra_hasheada = hashlib.md5(palabra_cifrada.strip())
    digest = palabra_hasheada.hexdigest()

    if digest == input_hash:
        print(f"Contraseña encontrada: {palabra}")
        encontrada = 1
        break

if not encontrada:
    print(f"Contraseña no encontrada en el archivo pass_doc: {pass_doc}")
    
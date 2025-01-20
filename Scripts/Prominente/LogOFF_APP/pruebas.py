import re

sesion_encontrada = " rdp-tcp#0       fvazquez                 46  Activo"
list_sesion_encontrada = sesion_encontrada.split()

print(list_sesion_encontrada)
print(list_sesion_encontrada[0])

if re.match(r"rdp-tcp#\d+",list_sesion_encontrada[0]):
    try:
        id_sesion_encontrada = int(list_sesion_encontrada[2])
        print(id_sesion_encontrada)
    except ValueError:
        print(f"No se pudo convertir el valor '{list_sesion_encontrada[2]}' a un número entero.")
        id_sesion_encontrada = None
else:
    try:
        id_sesion_encontrada = int(list_sesion_encontrada[1])
        print(id_sesion_encontrada)
    except ValueError:
        print(f"No se pudo convertir el valor '{list_sesion_encontrada[1]}' a un número entero.")
        id_sesion_encontrada = None
# Define la cuadrícula
cuadricula = [
    ["_", "_", "_"],
    ["_", "_", "_"],
    ["_", "_", "_"]
]

# Dibuja la cuadrícula
def dibujar_cuadricula():
    for fila in cuadricula:
        print("|".join(fila))

# Obtiene la entrada del jugador
def obtener_entrada_jugador():
    fila = int(input("Ingrese la fila (1-3): ")) - 1
    columna = int(input("Ingrese la columna (1-3): ")) - 1
    return (fila, columna)

# Verifica si el movimiento es válido
def movimiento_valido(fila, columna):
    return cuadricula[fila][columna] == "_"

# Marca la celda
def marcar_celda(fila, columna, simbolo):
    cuadricula[fila][columna] = simbolo

# Cambia el turno del jugador
def cambiar_turno(jugador):
    if jugador == "X":
        return "O"
    else:
        return "X"


# Verifica si hay un ganador
def hay_ganador():
    # Comprobar filas
    for fila in cuadricula:
        if fila[0] == fila[1] == fila[2] != "_":
            return True
    # Comprobar columnas
    for columna in range(3):
        if cuadricula[0][columna] == cuadricula[1][columna] == cuadricula[2][columna] != "_":
            return True
    # Comprobar diagonales
    if cuadricula[0][0] == cuadricula[1][1] == cuadricula[2][2] != "_":
        return True
    if cuadricula[0][2] == cuadricula[1][1] == cuadricula[2][0] != "_":
        return True
    return False

# Jugar el juego
def jugar():
    jugador = "X"
    while not hay_ganador() and "_" in [celda for fila in cuadricula for celda in fila]:
        dibujar_cuadricula()
        fila, columna = obtener_entrada_jugador()
        if movimiento_valido(fila, columna):
            marcar_celda(fila, columna, jugador)
            jugador = cambiar_turno(jugador)
        else:
            print("Movimiento no válido. Intente de nuevo.")
    dibujar_cuadricula()
    if hay_ganador():
        print("¡", jugador, "ha ganado!")
    else:
        print("Empate.")

# Ejecutar el juego
jugar()

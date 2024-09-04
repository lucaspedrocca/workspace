import tkinter as tk
from tkinter import messagebox

def suma():
    try:
        a = int(entry_a.get())
        b = int(entry_b.get())
        resultado = a + b
        label_resultado.config(text=f"La suma es: {resultado}")
    except ValueError:
        messagebox.showerror("Error", "Por favor, introduce números válidos.")

# Crear la ventana principal
root = tk.Tk()
root.title("Aplicación de Suma")

# Etiquetas y campos de entrada
label_a = tk.Label(root, text="Introduce el primer número:")
label_a.pack(pady=5)

entry_a = tk.Entry(root)
entry_a.pack(pady=5)

label_b = tk.Label(root, text="Introduce el segundo número:")
label_b.pack(pady=5)

entry_b = tk.Entry(root)
entry_b.pack(pady=5)

# Botón para realizar la suma
button_sumar = tk.Button(root, text="Sumar", command=suma)
button_sumar.pack(pady=10)

# Etiqueta para mostrar el resultado
label_resultado = tk.Label(root, text="La suma es: ")
label_resultado.pack(pady=10)

# Iniciar el bucle principal
root.mainloop()

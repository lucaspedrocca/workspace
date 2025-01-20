import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import json
import os
import subprocess
import re

class LogOFFApp:
    def __init__(self, root):
        self.root = root
        self.root.title("LogOFF GUI")
        self.root.geometry("800x600")
        
        # Ruta al archivo JSON
        self.base_path = os.path.dirname(os.path.abspath(__file__))
        self.json_path = os.path.join(self.base_path, 'hostnames.json')
        
        # Variables
        self.hostnames_empresas = self.load_hostnames()
        self.consulta_amplia = tk.BooleanVar(value=True)
        
        # Crear widgets
        self.create_widgets()
    
    def load_hostnames(self):
        try:
            with open(self.json_path, 'r', encoding='utf-8') as file:
                data = json.load(file)
                normalized_data = {k.upper(): v for k, v in data.items()}
                return normalized_data
        except FileNotFoundError:
            messagebox.showerror("Error", f"El archivo '{self.json_path}' no se encontró.")
            return {}
        except json.JSONDecodeError:
            messagebox.showerror("Error", "Error al decodificar el archivo JSON.")
            return {}
        except Exception as e:
            messagebox.showerror("Error", f"Se produjo un error al leer el archivo JSON: {e}")
            return {}
    
    def save_hostnames(self):
        try:
            with open(self.json_path, 'w', encoding='utf-8') as file:
                normalized_data = {k.upper(): v for k, v in self.hostnames_empresas.items()}
                json.dump(normalized_data, file, indent=4)
            messagebox.showinfo("Éxito", "Archivo guardado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"Error al guardar el archivo: {e}")
    
    def create_widgets(self):
        # Frame de selección de empresa y usuario
        frame_seleccion = ttk.Frame(self.root, padding="10")
        frame_seleccion.pack(fill='x')
        
        # Entrada para el nombre del usuario
        ttk.Label(frame_seleccion, text="Nombre del Usuario:").grid(row=0, column=0, padx=5, pady=5, sticky='w')
        self.entry_usuario = ttk.Entry(frame_seleccion, width=30)
        self.entry_usuario.grid(row=0, column=1, padx=5, pady=5, sticky='w')
        
        # ComboBox para seleccionar la empresa
        ttk.Label(frame_seleccion, text="Seleccionar Empresa:").grid(row=1, column=0, padx=5, pady=5, sticky='w')
        self.empresa_var = tk.StringVar()
        self.combobox_empresas = ttk.Combobox(frame_seleccion, textvariable=self.empresa_var, state='readonly', width=28)
        self.combobox_empresas['values'] = list(self.hostnames_empresas.keys()) + ["ALL"]
        if self.combobox_empresas['values']:
            self.combobox_empresas.current(0)
        self.combobox_empresas.grid(row=1, column=1, padx=5, pady=5, sticky='w')
        
        # Botón para ejecutar la consulta
        self.btn_consultar = ttk.Button(frame_seleccion, text="Consultar", command=self.ejecutar_consulta)
        self.btn_consultar.grid(row=2, column=0, columnspan=2, pady=10)
        
        # Checkbox para consulta amplia
        self.checkbox_consulta = ttk.Checkbutton(frame_seleccion, text="Consulta Amplia", variable=self.consulta_amplia)
        self.checkbox_consulta.grid(row=3, column=0, columnspan=2, pady=5)
        
        # Frame para resultados
        frame_resultados = ttk.LabelFrame(self.root, text="Resultados", padding="10")
        frame_resultados.pack(fill='both', expand=True, padx=10, pady=10)
        
        self.text_resultados = tk.Text(frame_resultados, wrap='word')
        self.text_resultados.pack(fill='both', expand=True)
        
        # Frame de acciones adicionales
        frame_acciones = ttk.Frame(self.root, padding="10")
        frame_acciones.pack(fill='x')
        
        self.btn_editar = ttk.Button(frame_acciones, text="Editar Servidores", command=self.abrir_editor_servidores)
        self.btn_editar.pack(side='left', padx=5)
        
        self.btn_salir = ttk.Button(frame_acciones, text="Salir", command=self.root.quit)
        self.btn_salir.pack(side='right', padx=5)
    
    def ejecutar_consulta(self):
        empresa_seleccionada = self.empresa_var.get().upper()
        usuario_ingresado = self.entry_usuario.get().strip()
        
        if not empresa_seleccionada or not usuario_ingresado:
            messagebox.showwarning("Advertencia", "Por favor, seleccione una empresa e ingrese un usuario.")
            return
        
        servidores_consulta = []
        if empresa_seleccionada == "ALL":
            for servidores in self.hostnames_empresas.values():
                servidores_consulta.extend(servidores)
        else:
            servidores_consulta = self.hostnames_empresas.get(empresa_seleccionada, [])
        
        if not servidores_consulta:
            messagebox.showwarning("Advertencia", f"No hay servidores registrados para {empresa_seleccionada}.")
            return
        
        self.text_resultados.delete(1.0, tk.END)
        self.text_resultados.insert(tk.END, f"Realizando consultas para el usuario '{usuario_ingresado}' en las empresas seleccionadas...\n\n")
        
        for servidor in servidores_consulta:
            self.text_resultados.insert(tk.END, f"Consultando en {servidor}...\n")
            consulta_sesion_powershell = f"query session /server:{servidor} | findstr /i '{usuario_ingresado}'"
            consulta_sesion_powershell_completo = f"query session /server:{servidor}"
            
            resultado = subprocess.run(['powershell', '-Command', consulta_sesion_powershell], capture_output=True, text=True)
            sesion_encontrada = resultado.stdout.strip()
            list_sesion_encontrada = sesion_encontrada.split()
            id_sesion_encontrada = None
            
            if sesion_encontrada:
                if re.match(r"rdp-tcp#\d+", list_sesion_encontrada[0]):
                    try:
                        id_sesion_encontrada = int(list_sesion_encontrada[2])
                    except ValueError:
                        self.text_resultados.insert(tk.END, f"No se pudo convertir el valor '{list_sesion_encontrada[2]}' a un número entero.\n")
                else:
                    try:
                        id_sesion_encontrada = int(list_sesion_encontrada[1])
                    except ValueError:
                        self.text_resultados.insert(tk.END, f"No se pudo convertir el valor '{list_sesion_encontrada[1]}' a un número entero.\n")
            
            if resultado.returncode != 0 or resultado.stderr:
                self.text_resultados.insert(tk.END, f"{servidor}: Hubo un error en la ejecución.\n{resultado.stderr}\n\n")
            elif not sesion_encontrada:
                if self.consulta_amplia.get():
                    resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                    self.text_resultados.insert(tk.END, f"{servidor}:\n{resultado_completo.stdout}\n")
                self.text_resultados.insert(tk.END, f"{servidor}: El usuario {usuario_ingresado} no está logueado.\n\n")
            else:
                self.text_resultados.insert(tk.END, f"{servidor}: {sesion_encontrada}\n")
                if id_sesion_encontrada is not None:
                    cerrar_sesion = messagebox.askyesno("Cerrar Sesión", f"¿Desea cerrar la sesión {id_sesion_encontrada} en {servidor}?")
                    if cerrar_sesion:
                        self.cerrar_sesion(servidor, id_sesion_encontrada, usuario_ingresado)
                self.text_resultados.insert(tk.END, "\n")
    
    def cerrar_sesion(self, servidor, id_sesion, usuario):
        cierre_sesion_powershell = f"reset session {id_sesion} /server:{servidor}"
        ejecucion_cierre = subprocess.run(['powershell', '-Command', cierre_sesion_powershell], capture_output=True, text=True)
        
        if ejecucion_cierre.returncode == 0:
            self.text_resultados.insert(tk.END, f"{servidor}: Se cerró la sesión de {usuario}.\n")
            if self.consulta_amplia.get():
                consulta_sesion_powershell_completo = f"query session /server:{servidor}"
                resultado_completo = subprocess.run(['powershell', '-Command', consulta_sesion_powershell_completo], capture_output=True, text=True)
                self.text_resultados.insert(tk.END, f"{servidor}:\n{resultado_completo.stdout}\n")
        else:
            self.text_resultados.insert(tk.END, f"{servidor}: Error al cerrar la sesión.\n{ejecucion_cierre.stderr}\n")
    
    def abrir_editor_servidores(self):
        EditorServidores(self)

class EditorServidores:
    def __init__(self, app):
        self.app = app
        self.window = tk.Toplevel()
        self.window.title("Editar Servidores")
        self.window.geometry("600x400")
        
        # Variables
        self.selected_empresa = tk.StringVar()
        
        # Crear widgets
        self.create_widgets()
    
    def create_widgets(self):
        # Frame para seleccionar empresa
        frame_seleccion = ttk.Frame(self.window, padding="10")
        frame_seleccion.pack(fill='x')
        
        ttk.Label(frame_seleccion, text="Seleccionar Empresa:").grid(row=0, column=0, padx=5, pady=5, sticky='w')
        self.combobox_empresas = ttk.Combobox(frame_seleccion, textvariable=self.selected_empresa, state='readonly', width=40)
        self.combobox_empresas['values'] = list(self.app.hostnames_empresas.keys())
        if self.combobox_empresas['values']:
            self.combobox_empresas.current(0)
        self.combobox_empresas.grid(row=0, column=1, padx=5, pady=5, sticky='w')
        self.combobox_empresas.bind("<<ComboboxSelected>>", self.actualizar_lista_servidores)
        
        # Lista de servidores
        frame_lista = ttk.LabelFrame(self.window, text="Servidores", padding="10")
        frame_lista.pack(fill='both', expand=True, padx=10, pady=10)
        
        self.listbox_servidores = tk.Listbox(frame_lista, selectmode=tk.SINGLE)
        self.listbox_servidores.pack(fill='both', expand=True, side='left', padx=(0,5))
        
        scrollbar = ttk.Scrollbar(frame_lista, orient='vertical', command=self.listbox_servidores.yview)
        scrollbar.pack(side='right', fill='y')
        self.listbox_servidores.config(yscrollcommand=scrollbar.set)
        
        # Frame de botones
        frame_botones = ttk.Frame(self.window, padding="10")
        frame_botones.pack(fill='x')
        
        self.btn_añadir = ttk.Button(frame_botones, text="Añadir Servidor", command=self.añadir_servidor)
        self.btn_añadir.pack(side='left', padx=5)
        
        self.btn_eliminar = ttk.Button(frame_botones, text="Eliminar Servidor", command=self.eliminar_servidor)
        self.btn_eliminar.pack(side='left', padx=5)
        
        self.btn_consultar = ttk.Button(frame_botones, text="Consultar Hostnames", command=self.consultar_hostnames)
        self.btn_consultar.pack(side='left', padx=5)
        
        self.btn_actualizar = ttk.Button(frame_botones, text="Actualizar Lista", command=self.actualizar_lista_servidores)
        self.btn_actualizar.pack(side='left', padx=5)
        
        # Inicializar lista
        self.actualizar_lista_servidores()
    
    def actualizar_lista_servidores(self, event=None):
        empresa = self.selected_empresa.get()
        self.listbox_servidores.delete(0, tk.END)
        servidores = self.app.hostnames_empresas.get(empresa, [])
        for servidor in servidores:
            self.listbox_servidores.insert(tk.END, servidor)
    
    def añadir_servidor(self):
        empresa = self.selected_empresa.get()
        if not empresa:
            messagebox.showwarning("Advertencia", "Seleccione una empresa primero.")
            return
        hostname_nuevo = simpledialog.askstring("Añadir Servidor", "Ingrese el hostname del servidor:")
        if hostname_nuevo:
            hostname_nuevo = hostname_nuevo.strip()
            if hostname_nuevo in self.app.hostnames_empresas[empresa]:
                messagebox.showwarning("Advertencia", f"El servidor '{hostname_nuevo}' ya existe en {empresa}.")
                return
            self.app.hostnames_empresas[empresa].append(hostname_nuevo)
            self.app.save_hostnames()
            self.actualizar_lista_servidores()
            messagebox.showinfo("Éxito", f"Servidor '{hostname_nuevo}' añadido a {empresa}.")
    
    def eliminar_servidor(self):
        empresa = self.selected_empresa.get()
        seleccion = self.listbox_servidores.curselection()
        if not empresa:
            messagebox.showwarning("Advertencia", "Seleccione una empresa primero.")
            return
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione un servidor para eliminar.")
            return
        servidor = self.listbox_servidores.get(seleccion)
        confirmacion = messagebox.askyesno("Confirmar Eliminación", f"¿Está seguro de eliminar el servidor '{servidor}' de {empresa}?")
        if confirmacion:
            self.app.hostnames_empresas[empresa].remove(servidor)
            if not self.app.hostnames_empresas[empresa]:
                del self.app.hostnames_empresas[empresa]
            self.app.save_hostnames()
            self.actualizar_lista_servidores()
            messagebox.showinfo("Éxito", f"Servidor '{servidor}' eliminado de {empresa}.")
    
    def consultar_hostnames(self):
        empresa_consultar = simpledialog.askstring("Consultar Hostnames", "Ingrese el nombre de la empresa (ALL para todos):").upper()
        if empresa_consultar:
            if empresa_consultar in self.app.hostnames_empresas:
                servidores = "\n".join(self.app.hostnames_empresas[empresa_consultar])
                messagebox.showinfo(f"Servidores de {empresa_consultar}", servidores)
            elif empresa_consultar == "ALL":
                content = ""
                for company, servers in self.app.hostnames_empresas.items():
                    content += f"\n{company}:\n" + "\n".join(f" - {server}" for server in servers) + "\n"
                messagebox.showinfo("Contenido de hostnames.json", content)
            else:
                messagebox.showwarning("Advertencia", "Ingrese un valor válido.")
    
def main():
    root = tk.Tk()
    
    # Mostrar mensaje de bienvenida
    # messagebox.showinfo("Bienvenida", "----------------------------------------\n        LogOFF by Lucas Pedrocca        \n----------------------------------------")
    
    app = LogOFFApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()

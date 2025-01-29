#!/usr/bin/env python3
import socket
import threading

class Monitoreador:
    def __init__(self):
        self.sock = None

    def main(self):
        ip_input = "172.30.222.60"  # IP del servidor
        puerto_input = 3007  # Puerto del servidor

        # Conectar al servidor
        if self.connect_to_server(ip_input, puerto_input):
            command = "SL"
            self.sock_send(command)

        else:
            print("No se pudo conectar al servidor.")            

    def connect_to_server(self, ip, puerto):
        try:
            ip_del_gestor = socket.gethostbyname(ip)
            puerto_monitoreo_del_gestor = int(puerto)
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.connect((ip_del_gestor, puerto_monitoreo_del_gestor))
            # Iniciar la recepción de datos en un hilo separado
            receive_thread = threading.Thread(target=self.receive_data)
            receive_thread.start()
            return True
        except Exception as exc:
            print(f"No se logró conexión: {exc}")
            return False

    def receive_data(self):
        try:
            buffer = self.sock.recv(1024)  # Recibir datos de forma bloqueante
            if buffer:
                datos_recibidos = buffer.decode('utf-8', errors='ignore')
                # Llamar al método para formatear los datos
                self.format_and_display_data(datos_recibidos)
            else:
                print("Conexión caída")
                self.sock.close()
        except Exception as ex:
            print(f"Error en la recepción de datos: {ex}")
            self.sock.close()

    def sock_send(self, cmd):
        if len(cmd) == 2:
            try:
                msg = bytearray(b"UGO\x0B\x00\x00\x00IO")
                msg[7] = ord(cmd[0])
                msg[8] = ord(cmd[1])
                bytes_sent = self.sock.send(msg)
                if bytes_sent == 0:
                    print("Conexión caída")
                    self.sock.close()
            except Exception as ex:
                print(f"Error al enviar el comando: {ex}")

    # Solo para comando MO
    def format_and_display_data(self, data):
        # Separar los datos por la barra invertida
        items = data.split('\\')
        # print("\nDatos Formateados:")
        for item in items:
            # Separar la clave y el valor
            key_value = item.split('=', 1)
            if len(key_value) == 2:
                print(f"{key_value[0].strip()}: {key_value[1].strip()}")
            else:
                print(item.strip())  # Imprimir cualquier dato que no tenga clave-valor
        print()  # Espacio adicional para mejorar la legibilidad
    
    def is_socket_open(self):
        try:
            # Obtener el error del socket
            return self.sock.getsockopt(socket.SOL_SOCKET, socket.SO_ERROR) == 0
        except Exception as ex:
            print(f"Error al verificar el estado del socket: {ex}")
            return False

if __name__ == "__main__":
    monitoreador = Monitoreador()
    monitoreador.main()
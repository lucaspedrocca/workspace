from exchangelib import DELEGATE, Account, Credentials, Message
import time
import threading

# Credenciales para Exchange y Office 365
master = 'Qu9y70wr!'
credenciales_exchange = Credentials('TestLocalPromi@grupoprominente.com', master)
credenciales_365 = Credentials('Tes365Promi@grupoprominente.com', master)

# Listas de direcciones de prueba
correos_exchange = [
    'TestLocalPromi@grupoprominente.com',
    'TestLocalEMV@emova.com.ar',
    'TestLocalBRT@brt.com.ar',
    'TestLocalBRF@brfsa.com.ar',
    'TestLocalMTV@metrovias.com.ar',
    'TestLocalBRH@broggio.com.ar',
    'TestLocalBRA@cliba.com.ar'
]

correos_365 = [
    'Tes365Promi@grupoprominente.com',
    'Test365EMV@emova.com.ar'
]

# Destinatarios
destinatarios = [
    'lucaspedrocca@gmail.com',
    'lpedrocca@grupoprominente.com'
    #'dcmonitoreo7x24@gmail.com',
    #'soporte@grupoprominente.com'
]

# Configurar cuentas de Exchange y Office 365
def obtener_cuenta(correo, credenciales):
    try:
        cuenta = Account(
            primary_smtp_address=correo,
            credentials=credenciales,
            autodiscover=True,
            access_type=DELEGATE
        )
        return cuenta
    except Exception as e:
        print(f"Error al conectar con {correo}: {e}")
        return None

# Enviar correos
def enviar_correos(cuenta, destinatarios, asunto, cuerpo):
    for destinatario in destinatarios:
        try:
            mensaje = Message(
                account=cuenta,
                folder=cuenta.sent,
                subject=asunto,
                body=cuerpo,
                to_recipients=[destinatario]
            )
            mensaje.send()
            print(f"Correo enviado a {destinatario} desde {cuenta.primary_smtp_address}")
        except Exception as e:
            print(f"Error al enviar correo a {destinatario}: {e}")

# Verificar respuestas desde las direcciones de destino
def recibir_respuestas(cuenta, destinatarios, asunto_buscar):
    respuestas_recibidas = False
    for destinatario in destinatarios:
        try:
            inbox = cuenta.inbox.filter(subject__contains=asunto_buscar)
            respuestas = [correo for correo in inbox if correo.sender.email_address.lower() == destinatario.lower()]

            if respuestas:
                print(f"Respuesta recibida de {destinatario}:")
                for respuesta in respuestas:
                    print(f" - Asunto: {respuesta.subject} | Fecha: {respuesta.datetime_received}")
                respuestas_recibidas = True  # Se ha recibido al menos una respuesta
            else:
                print(f"No se encontró respuesta de {destinatario}.")
        except Exception as e:
            print(f"Error al verificar respuestas de {destinatario}: {e}")

    return respuestas_recibidas  # Retorna True si hay respuestas

# Contador regresivo
def temporizador(duracion):
    for i in range(duracion, 0, -1):
        print(f'Tiempo restante: {i} segundos', end='\r')
        time.sleep(1)
    print("\n¡Tiempo expirado!")

# Ejecutar la prueba completa
def prueba_envio_respuesta(correos, credenciales):
    for correo in correos:
        cuenta = obtener_cuenta(correo, credenciales)
        if cuenta:
            # Asunto y cuerpo del correo
            asunto = f'Prueba de envío desde {correo}'
            cuerpo = f'Este es un correo de prueba enviado desde {correo}.'

            # Enviar correos a los destinatarios
            enviar_correos(cuenta, destinatarios, asunto, cuerpo)

            # Iniciar temporizador en un hilo separado
            duracion = 120  # Duración en segundos
            timer_thread = threading.Thread(target=temporizador, args=(duracion,))
            timer_thread.start()

            # Esperar respuestas o permitir forzar chequeo
            respuesta_correcta = False
            while timer_thread.is_alive() and not respuesta_correcta:
                forzar_chequeo = input("\nPresiona 'f' para forzar el chequeo de respuestas: ")
                if forzar_chequeo.lower() == 'f':
                    respuesta_correcta = recibir_respuestas(cuenta, destinatarios, f"Re: {asunto}")
                    if respuesta_correcta:
                        print("¡Respuesta recibida! La prueba fue exitosa.")
                    break

            # Verificar si el temporizador terminó
            if timer_thread.is_alive() == False and not respuesta_correcta:
                print("Fin del chequeo debido a que se agotó el tiempo.")

# Ejecutar pruebas para Exchange y Office 365
if __name__ == "__main__":
    print("Iniciando prueba para cuentas de Exchange...")
    prueba_envio_respuesta(correos_exchange, credenciales_exchange)
    
    print("Iniciando prueba para cuentas de Office 365...")
    prueba_envio_respuesta(correos_365, credenciales_365)

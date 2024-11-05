using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace MonitoreadorGestoresCLI
{
    class Program
    {
        static Socket sock;

        static void Main(string[] args)
        {
            Console.WriteLine("Ingrese la IP del servidor:");
            string ipInput = Console.ReadLine();
            Console.WriteLine("Ingrese el puerto del servidor:");
            string puertoInput = Console.ReadLine();

            // Conectar al servidor
            if (ConnectToServer(ipInput, puertoInput))
            {
                Console.WriteLine("Conectado al servidor. Presione 'Enter' para enviar comandos o 'q' para salir.");

                while (true)
                {
                    string command = Console.ReadLine();
                    if (command.ToLower() == "q") break;
                    if (command == "MO" || command == "ST" || command == "SS" || command == "SL")
                    {
                        sockSend(command);
                    }
                    else
                    {
                        Console.WriteLine("Comando no válido. Use MO, ST, SS, o SL.");
                    }
                }

                sock.Close();
            }
            else
            {
                Console.WriteLine("No se pudo conectar al servidor.");
            }
        }

        static bool ConnectToServer(string ip, string puerto)
        {
            try
            {
                IPAddress ipDelGestor = IPAddress.Parse(ip);
                int puertoMonitoreoDelGestor = int.Parse(puerto);
                IPEndPoint gt = new IPEndPoint(ipDelGestor, puertoMonitoreoDelGestor);
                sock = new Socket(ipDelGestor.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                sock.Connect(gt);
                // Iniciar la recepción de datos en un hilo separado
                Thread receiveThread = new Thread(ReceiveData);
                receiveThread.Start();
                return true;
            }
            catch (Exception exc)
            {
                Console.WriteLine("No se logró conexión: " + exc.Message);
                return false;
            }
        }

        static void ReceiveData()
        {
            byte[] buffer = new byte[1024];
            try
            {
                while (true)
                {
                    int bytesRec = sock.Receive(buffer);
                    if (bytesRec > 0)
                    {
                        // Cambiar a Encoding.UTF8
                        string datosRecibidos = Encoding.UTF8.GetString(buffer, 0, bytesRec);
                        // Llamar al método para formatear los datos
                        FormatAndDisplayData(datosRecibidos);
                    }
                    else
                    {
                        Console.WriteLine("Conexión caída");
                        sock.Close();
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en la recepción de datos: " + ex.Message);
                sock.Close();
            }
        }

        static void sockSend(string cmd)
        {
            if (cmd.Length == 2)
            {
                try
                {
                    byte[] msg = Encoding.UTF8.GetBytes("UGO\u000B\u0000\u0000\u0000IO");
                    msg[7] = (byte)cmd[0];
                    msg[8] = (byte)cmd[1];
                    int bytesSent = sock.Send(msg);
                    if (bytesSent == 0)
                    {
                        Console.WriteLine("Conexión caída");
                        sock.Close();
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error al enviar el comando: " + ex.Message);
                }
            }
        }

        static void FormatAndDisplayData(string data)
        {
            // Separar los datos por la barra invertida
            string[] items = data.Split(new[] { '\\' }, StringSplitOptions.RemoveEmptyEntries);
            Console.WriteLine("\nDatos Formateados:");
            foreach (var item in items)
            {
                // Separar la clave y el valor
                string[] keyValue = item.Split(new[] { '=' }, 2);
                if (keyValue.Length == 2)
                {
                    Console.WriteLine($"{keyValue[0].Trim()}: {keyValue[1].Trim()}");
                }
                else
                {
                    Console.WriteLine(item.Trim()); // Imprimir cualquier dato que no tenga clave-valor
                }
            }
            Console.WriteLine(); // Espacio adicional para mejorar la legibilidad
        }
    }
}

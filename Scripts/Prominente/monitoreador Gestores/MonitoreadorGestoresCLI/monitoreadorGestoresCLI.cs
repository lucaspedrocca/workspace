using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace MonitoreadorCLI
{
    class Program
    {
        static Socket sock;
        static bool detenerTmr = true;

        static void Main(string[] args)
        {
            Console.Write("Ingrese la dirección IP: ");
            string ipAddress = Console.ReadLine();

            Console.Write("Ingrese el puerto: ");
            int puertoMonitoreoDelGestor = int.Parse(Console.ReadLine());

            try
            {
                IPEndPoint gt = new IPEndPoint(IPAddress.Parse(ipAddress), puertoMonitoreoDelGestor);
                sock = new Socket(gt.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                sock.Connect(gt);
                if (sock.Connected)
                {
                    Console.WriteLine("Conectado a Servidor");
                    // Iniciar la recepción de datos de manera asíncrona
                    byte[] buffer = new byte[1024];
                    sock.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(ReceiveCallback), buffer);

                    // Comandos en un bucle
                    while (true)
                    {
                        Console.Write("Ingrese el comando (MO, ST, SS, SL) o 'exit' para salir: ");
                        string command = Console.ReadLine();
                        if (command == "exit")
                        {
                            break;
                        }
                        sockSend(command);
                    }
                }
            }
            catch (Exception exc)
            {
                Console.WriteLine("No se logró conexión: " + exc.Message);
            }
        }

        static void ReceiveCallback(IAsyncResult ar)
        {
            byte[] bytes = (byte[])ar.AsyncState;
            try
            {
                int bytesRec = sock.EndReceive(ar);
                if (bytesRec > 0)
                {
                    string datosRecibidos = Encoding.Default.GetString(bytes, 0, bytesRec);
                    if (datosRecibidos.Length > 9)
                    {
                        // Lógica de procesamiento de datos recibidos
                        Console.WriteLine("Datos recibidos: " + datosRecibidos);
                    }
                    sock.BeginReceive(bytes, 0, bytes.Length, SocketFlags.None, new AsyncCallback(ReceiveCallback), bytes);
                }
                else
                {
                    Console.WriteLine("Conexión caída");
                    sock.Close();
                }
            }
            catch (SocketException ex)
            {
                Console.WriteLine("Error de socket: " + ex.Message);
                sock.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
                sock.Close();
            }
        }

        static void sockSend(string cmd)
        {
            if (cmd.Length == 2)
            {
                try
                {
                    byte[] msg = Encoding.Default.GetBytes("UGO\u000B\u0000\u0000\u0000IO");
                    msg[7] = (byte)cmd[0];
                    msg[8] = (byte)cmd[1];
                    sock.Send(msg);
                    Console.WriteLine($"Comando '{cmd}' enviado.");
                }
                catch
                {
                    Console.WriteLine("Error al enviar comando.");
                }
            }
        }
    }
}


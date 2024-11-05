using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Threading;
using System.Net;
 
namespace Monitoreador2
{
    public partial class Form1 : Form
    {
        Socket sock;
        bool detenerTmr = true;
        public Form1()
        {
            InitializeComponent();
        }
 
        private void Form1_Load(object sender, EventArgs e)
        {
            CheckForIllegalCrossThreadCalls = false;
        }
 
        private void btnConnect_Click(object sender, EventArgs e)
        {
            try
            {
                btnConnect.Enabled = false;
                IPAddress ipDelGestor = IPAddress.Parse(txtIp.Text);
                int puertoMonitoreoDelGestor = int.Parse(txtPort.Text);
                IPEndPoint gt = new IPEndPoint(ipDelGestor, puertoMonitoreoDelGestor);
                sock = new Socket(ipDelGestor.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                sock.Connect(gt);
                if (sock.Connected)
                {
                    byte[] buffer = new byte[1024];
                    // Iniciar la recepción de datos de manera asíncrona
                    sock.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(ReceiveCallback), buffer);
                    txtData.AppendText("Conectado a Servidor" + Environment.NewLine);
                    return;
                }
            }
            catch (Exception exc)
            {
                txtData.AppendText("No se logró conexión " + exc.Message  + Environment.NewLine);
                btnConnect.Enabled = true;
            }
        }
 
        void ReceiveCallback(IAsyncResult ar)
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
                        if ((bytesRec - 9) == (bytes[5] + (bytes[6] * 256)))
                        {
                            if (crc16(datosRecibidos.Substring(9), bytesRec - 9) == (bytes[3] + (bytes[4] * 256)))
                            {
                                if (datosRecibidos.Substring(7, 2) == "MO")
                                {
                                    string[] c = datosRecibidos.Substring(9).Split('\\');
                                    if (c.Length > 0)
                                    {
                                        if (!detenerTmr) txtData.Text = "";
                                        for (int i = 0; i < c.Length; i++)
                                            txtData.AppendText(c[i] + Environment.NewLine);
                                    }
                                }
                                else if (datosRecibidos.Substring(7, 2) == "ST")
                                    txtData.AppendText("Estado=" + datosRecibidos.Substring(9) + Environment.NewLine);
                                else if ((datosRecibidos.Substring(7, 2) == "SS") || (datosRecibidos.Substring(7, 2) == "SL"))
                                    txtData.AppendText(datosRecibidos.Substring(9) + Environment.NewLine);
                            }
                            else
                            {
                                txtData.AppendText("Error de CRC en paquete recibido" + Environment.NewLine);
                            }
                        }
                        else
                        {
                            txtData.AppendText("Error de longitud en paquete recibido" + Environment.NewLine);
                        }
                    }
                    sock.BeginReceive(bytes, 0, bytes.Length, SocketFlags.None, new AsyncCallback(ReceiveCallback), bytes);
                }
                else
                {
                    txtData.AppendText("Conexión caida" + Environment.NewLine);
                    sock.Close();
                    btnConnect.Enabled = true;
                }
            }
            catch (SocketException ex)
            {
                txtData.AppendText("Error de socket: " + ex.Message + Environment.NewLine);
                sock.Close();
                btnConnect.Enabled = true;
            }
            catch (Exception ex)
            {
                txtData.AppendText("Error: " + ex.Message + Environment.NewLine);
                sock.Close();
                btnConnect.Enabled = true;
            }
        }
 
        static ushort crc16(string txt, int datoLength)
        {
            int n, i;
            int old_crc = 11;
            int x, c;
            if (datoLength > 0)
                n = datoLength;
            else
                n = txt.Length;
            for (i = 0; i < n; i++)
            {
                c = (int)txt[i];
                x = ((old_crc >> 8) ^ c) & 255;
                x = ((x >> 4) ^ x);
                old_crc = ((old_crc << 8) ^ (x << 12) ^ (x << 5) ^ x) & 65535;
            }
            return (ushort) old_crc;
        }
 
        private void btnIO_Click(object sender, EventArgs e)
        {
            sockSend("MO");
        }
 
        void sockSend(String cmd, String txt = "")
        {
            if (cmd.Length == 2) {
                int bytesSent = 0;
                try
                {
                    byte[] msg = Encoding.Default.GetBytes("UGO\u000B\u0000\u0000\u0000IO");
                    msg[7] = (byte)cmd.ElementAt(0);
                    msg[8] = (byte)cmd.ElementAt(1);
                    bytesSent = sock.Send(msg);
                }
                catch { };                
                if (bytesSent == 0)
                {
                    txtData.AppendText("Conexión caida" + Environment.NewLine);
                    sock.Close();
                    btnConnect.Enabled = true;
                }
            }
        }
 
        private void btnStart_Click(object sender, EventArgs e)
        {
            if (btnStart.Text == "Start")
            {
                detenerTmr = false;
                tmr.Enabled = true;
                tmr.Interval = int.Parse(txtFrec.Text);
                btnStart.Text = "Stop";                
            }
            else
            {
                btnStart.Text = "Start";
                tmr.Enabled = false;
                detenerTmr = true;
            }
        }
 
        private void tmr_Tick(object sender, EventArgs e)
        {
            tmr.Enabled = false;
            if (sock.Connected || detenerTmr)
                btnIO_Click(null, null);
            else
                return;
            tmr.Enabled = true;
        }
 
        private void btnSt_Click(object sender, EventArgs e)
        {
            detenerTmr = true;
            tmr.Enabled = false;
            sockSend("ST");
        }
 
        private void btnSw_Click(object sender, EventArgs e)
        {
            detenerTmr = true;
            tmr.Enabled = false;
            sockSend("SS");
        }
 
        private void btnLg_Click(object sender, EventArgs e)
        {
            detenerTmr = true;
            tmr.Enabled = false;
            sockSend("SL");
        }
    }
}

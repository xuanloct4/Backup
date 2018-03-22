using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.IO.Ports;
using System.IO;

namespace MVCASPWeb.IO.SerialPort
{
    class SerialPortConstructor
    {
        // Create a new SerialPort object with default settings.
      public  System.IO.Ports.SerialPort _serialPort;
       public Boolean _continue;

        public SerialPortConstructor()
        {
            // Create a new SerialPort object with default settings.
       _serialPort = new System.IO.Ports.SerialPort("COM1",
          9600, Parity.None, 8, StopBits.One);
             _continue = true;
        }

        private void port_DataReceived(object sender,
      SerialDataReceivedEventArgs e)
        {
            // Show all the incoming data in the port's buffer
            Console.WriteLine(_serialPort.ReadExisting());
        }
        public void SerialPortSetup()
        {
            string name;
            string message;
            StringComparer stringComparer = StringComparer.OrdinalIgnoreCase;
            Thread readThread = new Thread(Read);

            // Allow the user to set the appropriate properties.
            //_serialPort.PortName = SetPortName(_serialPort.PortName);
            //_serialPort.BaudRate = SetPortBaudRate(_serialPort.BaudRate);
            //_serialPort.Parity = SetPortParity(_serialPort.Parity);
            //_serialPort.DataBits = SetPortDataBits(_serialPort.DataBits);
            //_serialPort.StopBits = SetPortStopBits(_serialPort.StopBits);
            //_serialPort.Handshake = SetPortHandshake(_serialPort.Handshake);

            // Set the read/write timeouts
            _serialPort.ReadTimeout = 500;
            _serialPort.WriteTimeout = 500;

            // Attach a method to be called when there
            // is data waiting in the port's buffer
            _serialPort.DataReceived += new
              SerialDataReceivedEventHandler(port_DataReceived);
            // Begin communications
            _serialPort.Open();
            _continue = true;
            readThread.Start();

            System.Diagnostics.Debug.Write("Name: ");
            //name = Console.ReadLine();
            name = "ABC";

         System.Diagnostics.Debug.WriteLine("Type QUIT to exit");

            while (_continue)
            {
                //message = Console.ReadLine();
                message = "Helloe";

                if (stringComparer.Equals("quit", message))
                {
                    _continue = false;
                }
                else
                {
                    _serialPort.WriteLine(
                        System.String.Format("<{0}>: {1}", name, message));
                }
            }

            readThread.Join();
            _serialPort.Close();
        }

        public void Write(System.IO.Ports.SerialPort comPort)
        {
             //comPort = new System.IO.Ports.SerialPort("Com2", 115200, System.IO.Ports.Parity.None, 8, StopBits.One);
             comPort.DtrEnable = true;

             comPort.Write("ATZ" + System.Convert.ToChar(13).ToString());

                  //Switch to Voice Mode
             comPort.Write("AT+FCLASS=8" + System.Convert.ToChar(13).ToString());

             comPort.Write("AT+VSM=128,8000" + System.Convert.ToChar(13).ToString());

             //start calling 
             string m_phoneNumber = "";
             comPort.Write("ATDT" + m_phoneNumber + System.Convert.ToChar(13).ToString());
             System.Threading.Thread.Sleep(17000);


             //to enable voice-transmission mode @ send audio file
             comPort.Write("AT+VTX" + System.Convert.ToChar(13).ToString());

               //Call Number
             comPort.Write("ATDT1231234" + System.Convert.ToChar(13).ToString());
                //Enter Voice-Transmission Mode
             comPort.Write("AT+VTX" + System.Convert.ToChar(13).ToString());
               bool MSwitch = false;
                            byte[] buffer = new byte[500000];
                            FileStream strm = new FileStream(@"C:\HelpSound.wav", System.IO.FileMode.Open);
                            MemoryStream ms = new MemoryStream();
                            int count = ms.Read(buffer, 44, buffer.Length - 44);
                            BinaryReader rdr = new BinaryReader(strm);
                            while (!MSwitch)
                            {
                                byte[] bt = new byte[1024];
                                bt = rdr.ReadBytes(1024);
                                if (bt.Length == 0)
                                {
                                    MSwitch = true;
                                    break;
                                }
                                comPort.Write(bt, 0, bt.Length);
                            }
                            strm.Close();
                            strm.Dispose();
                            comPort.Close();


            //we terminate the connection by: sending 0x10 0x03 to the modem to switch off the sending mode
                            byte[] terminator = new byte[2];
                            terminator[0] = 0x10;
                            terminator[1] = 0x03;
                            comPort.Write(terminator, 0, 2);
            //and then hang up the phone by sending “ATH”.
                 comPort.Write("ATH" + System.Convert.ToChar(13).ToString());
        }
   
        public void Read()
        {
            while (_continue)
            {
                try
                {
                    string message = _serialPort.ReadLine();
                    System.Diagnostics.Debug.WriteLine(message);
                }
                catch (TimeoutException) { }
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading;

namespace SkrrmrchohSmartSwitch
{
    public class Client
    {
        private byte addr_;

        private Client()
        {
        }

        public static Client Instance = new Client();
        private Dictionary<uint, Transaction> transactions = new Dictionary<uint, Transaction>();

        public class Transaction
        {
            public Request Request;
            public Response Response;
        }

        public class Request
        {
            public uint Transaction;
            public uint UnitType;
            public uint UnitId;
            public uint Function;
            public byte[] Data;

            public byte[] ToBinary()
            {
                uint voiddata = 0xFFFFFFFF;
                List<byte> frame = new List<byte>();
                frame.AddRange(BitConverter.GetBytes(Transaction));
                frame.AddRange(BitConverter.GetBytes(UnitType));
                frame.AddRange(BitConverter.GetBytes(UnitId));
                frame.AddRange(BitConverter.GetBytes(Function));
                frame.AddRange(BitConverter.GetBytes(voiddata));
                frame.AddRange(BitConverter.GetBytes(voiddata));
                frame.AddRange(BitConverter.GetBytes(voiddata));
                frame.AddRange(Data);
                frame.InsertRange(0, BitConverter.GetBytes(frame.Count + 4));
                return frame.ToArray();
            }
        }

        public class Response
        {
            public uint Transaction;
            public uint UnitType;
            public uint UnitId;
            public uint Function;
            public uint ResultCode;
            public byte[] Data;
        }

        //public event Action<uint, uint, uint, byte[]> OnReceive;
        public Queue<Response> Results = new Queue<Response>();

        public Client(byte addr)
        {
            addr_ = addr;
        }

        private string serialPortName = "";
        private SerialPort serialPort;

        private Thread thReceive = null;
        public void Connect(string portName)
        {
            serialPortName = portName;
            OpenSerialPort();
        }

        public void Disconnect()
        {
            transactions.Clear();
        }

        private List<byte> input = new List<byte>();


        private void CheckFrame()
        {
            while (input.Count >= 32)
            {
                byte[] inputBytes = input.ToArray();

                int size = BitConverter.ToInt32(inputBytes, 0);
                if (size > 10000 || size < 32)
                {
                    break;
                }
                if (inputBytes.Length >= size)
                {
                    Response response = new Response();
                    response.Transaction = BitConverter.ToUInt32(inputBytes, 4);
                    response.UnitType = BitConverter.ToUInt32(inputBytes, 8);
                    response.UnitId = BitConverter.ToUInt32(inputBytes, 12);
                    response.Function = BitConverter.ToUInt32(inputBytes, 16);
                    response.ResultCode = BitConverter.ToUInt32(inputBytes, 20);
                    response.Data = new byte[size - 32];
                    for (int i = 0; i < size - 32; i++)
                        response.Data[i] = inputBytes[i + 32];

                    /*frames.Add(new RS485Test.Client.Fr(inputBytes, size));
                    framesParsed.Add(response);
                    lastValidOffset += size;*/

                    input.RemoveRange(0, size);
                    lock (Results)
                    {
                        Results.Enqueue(response);
                    }
                }
                else
                    break;
            }
        }

        public static string IP = "192.168.254.12";
        public static bool Enabled = false;

        public byte calcCRC(byte[] data)
        {
            byte[] table = {0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65,
        157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220,
        35, 125, 159, 193, 66, 28, 254, 160, 225, 191, 93, 3, 128, 222, 60, 98,
        190, 224, 2, 92, 223, 129, 99, 61, 124, 34, 192, 158, 29, 67, 161, 255,
        70, 24, 250, 164, 39, 121, 155, 197, 132, 218, 56, 102, 229, 187, 89, 7,
        219, 133, 103, 57, 186, 228, 6, 88, 25, 71, 165, 251, 120, 38, 196, 154,
        101, 59, 217, 135, 4, 90, 184, 230, 167, 249, 27, 69, 198, 152, 122, 36,
        248, 166, 68, 26, 153, 199, 37, 123, 58, 100, 134, 216, 91, 5, 231, 185,
        140, 210, 48, 110, 237, 179, 81, 15, 78, 16, 242, 172, 47, 113, 147, 205,
        17, 79, 173, 243, 112, 46, 204, 146, 211, 141, 111, 49, 178, 236, 14, 80,
        175, 241, 19, 77, 206, 144, 114, 44, 109, 51, 209, 143, 12, 82, 176, 238,
        50, 108, 142, 208, 83, 13, 239, 177, 240, 174, 76, 18, 145, 207, 45, 115,
        202, 148, 118, 40, 171, 245, 23, 73, 8, 86, 180, 234, 105, 55, 213, 139,
        87, 9, 235, 181, 54, 104, 138, 212, 149, 203, 41, 119, 244, 170, 72, 22,
        233, 183, 85, 11, 136, 214, 52, 106, 43, 117, 151, 201, 74, 20, 246, 168,
        116, 42, 200, 150, 21, 75, 169, 247, 182, 232, 10, 84, 215, 137, 107, 53 };
            byte crc = 0;
            int index;

            for (index = 0; index < data.Length; index++)
            {
                crc = table[crc ^ data[index]];
            }
            return crc;
        }

        public void Call(uint unitType, uint unitId, uint function, byte[] data)
        {
            if (serialPort != null)
            {
                List<byte> dataFrame = new List<byte>();
                for (int i = 1; i < data.Length; i++)
                    dataFrame.Add(data[i]);

                List<byte> frame = new List<byte>();
                frame.Add(data[0]);
                frame.Add(0x00);
                frame.Add(Convert.ToByte(data.Length - 1));
                frame.AddRange(dataFrame);
                frame.Add(calcCRC(frame.ToArray()));
                var frameToSend = frame.ToArray();
                serialPort.Write(frameToSend, 0, frameToSend.Length);
                serialPort.ReadTimeout = 500;
                List<byte> response = new List<byte>();
                for (int i = 0; i < 7; i++)
                    response.Add(0);
                try
                {
                    while (true)
                    {
                        int b = serialPort.ReadByte();
                        //input.Add(Convert.ToByte(b));

                        response.Add(Convert.ToByte(b));
                    }
                }
                catch (Exception ex)
                {
                }

                Response response1 = new Response();
                response1.Transaction = 0;
                response1.UnitType = 0x01;
                response1.UnitId = 0;
                response1.Function = 0;
                response1.ResultCode = response.Count > 7 ? 0 : Convert.ToUInt32(0x81 << 16);
                response1.Data = response.ToArray();

                lock (Results)
                {
                    Results.Enqueue(response1);
                }

                return;
            }

        }

        public List<byte> receivedBytes = new List<byte>();

        public void Rs485Request(byte addr, byte[] data)
        {
            List<byte> buffer = new List<byte>();
            buffer.Add(addr);
            buffer.AddRange(data);
            Call(0x01, 0, 0x01, buffer.ToArray());
        }

        public bool Connected()
        {
            if (serialPort != null && serialPort.IsOpen)
                return true;
            return false;
        }

        public void OpenSerialPort()
        {
            serialPort = new SerialPort(serialPortName, 115200, Parity.None, 8, StopBits.One);
            serialPort.Open();
        }
    }

}

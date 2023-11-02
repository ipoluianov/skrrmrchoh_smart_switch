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

        public class Frame
        {
            public byte direction = 0;
            public byte destAddr = 0;
            public byte srcAddr = 0;
            public byte function = 0;
            public byte subAddr1 = 0;
            public byte subAddr2 = 0;
            public byte[] data = new byte[0];

            public byte result = 0;
        }

        public Queue<Frame> Results = new Queue<Frame>();

        public Client(byte addr)
        {
            addr_ = addr;
        }

        private string serialPortName = "";
        private SerialPort serialPort;

        public void Connect(string portName)
        {
            serialPortName = portName;
            OpenSerialPort();
        }

        public void Disconnect()
        {
            if (serialPort != null)
            {
                serialPort.Close();
                serialPort = null;
            }
        }

        private List<byte> input = new List<byte>();

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

        public Frame Call(byte destAddr, byte srcAddr, byte function, byte subAddr1, byte subAddr2, byte[] data)
        {
            if (serialPort != null)
            {
                List<byte> dataFrame = new List<byte>();
                dataFrame.Add(destAddr);
                dataFrame.Add(srcAddr);
                dataFrame.Add(function);
                dataFrame.Add(subAddr1);
                dataFrame.Add(subAddr2);
                dataFrame.AddRange(data);

                while (dataFrame.Count < 24)
                    dataFrame.Add(0x00);

                var frameToSend = dataFrame.ToArray();

                Frame request = new Frame();
                request.direction = 0;
                request.destAddr = frameToSend[0];
                request.srcAddr = frameToSend[1];
                request.function = frameToSend[2];
                request.subAddr1 = frameToSend[3];
                request.subAddr2 = frameToSend[4];
                request.result = 0;
                List<byte> req = new List<byte>();
                for (int i = 5; i < 24; i++)
                    req.Add(frameToSend[i]);
                request.data = req.ToArray();
                lock (Results)
                {
                    Results.Enqueue(request);
                }

                serialPort.Write(frameToSend, 0, frameToSend.Length);
                serialPort.ReadTimeout = 100;
                List<byte> response = new List<byte>();
                bool error = false;
                try
                {
                    while (true)
                    {
                        int b = serialPort.ReadByte();
                        response.Add(Convert.ToByte(b));
                    }
                }
                catch (Exception ex)
                {
                    error = true;
                }

                Frame response1 = new Frame();
                response1.direction = 1;
                if (error)
                    response1.result = 1;
                if (response.Count >= 5)
                {
                    response1.destAddr = response[0];
                    response1.srcAddr = response[1];
                    response1.function = response[2];
                    response1.subAddr1 = response[3];
                    response1.subAddr2 = response[4];
                    response1.result = 0;
                    List<byte> d = new List<byte>();
                    for (int i = 5; i < response.Count; i++)
                        d.Add(response[i]);
                    response1.data = d.ToArray();

                }
                lock (Results)
                {
                    Results.Enqueue(response1);
                }

                return response1;
            }

            return new Frame();
        }

        public List<byte> receivedBytes = new List<byte>();

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

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;

namespace SkrrmrchohSmartSwitch
{
    public partial class ControlLink : UserControl
    {
        public ControlLink()
        {
            InitializeComponent();
            initCombos();
        }

        private void initCombos()
        {
            cmbSerialPorts.Items.Clear();
            foreach (var portName in SerialPort.GetPortNames())
            {
                cmbSerialPorts.Items.Add(portName);
            }

            if (cmbSerialPorts.Items.Count == 1)
            {
                cmbSerialPorts.SelectedIndex = 0;
                Client.Instance.Connect(cmbSerialPorts.SelectedItem as string);
                btnConnect.Enabled = false;
            }
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            Client.Instance.Connect(cmbSerialPorts.SelectedItem as string);
            btnConnect.Enabled = false;
        }

        private void btnDisconnect_Click(object sender, EventArgs e)
        {
            Client.Instance.Disconnect();
        }

        private void timerUpdate_Tick(object sender, EventArgs e)
        {
            lock (Client.Instance.Results)
            {
                while (Client.Instance.Results.Count > 0)
                {
                    var line = Client.Instance.Results.Dequeue();
                    var lvItem = lvFrames.Items.Add(DateTime.Now.ToString());

                    string frame = "";
                    if (line.direction == 0)
                        frame += "SND: ";
                    else
                        frame += "RCV: ";

                    if (line.result != 0)
                        frame += " TIMEOUT ";
                    else
                    {
                        frame += line.destAddr.ToString("X2");
                        frame += " ";
                        frame += line.srcAddr.ToString("X2");
                        frame += " ";
                        frame += line.function.ToString("X2");
                        frame += " ";
                        frame += line.subAddr1.ToString("X2");
                        frame += " ";
                        frame += line.subAddr2.ToString("X2");
                        frame += " ";
                        foreach (byte b in line.data)
                        {
                            frame += b.ToString("X2");
                            frame += " ";
                        }
                    }

                    lvItem.SubItems.Add(frame);
                }
            }
        }
    }
}

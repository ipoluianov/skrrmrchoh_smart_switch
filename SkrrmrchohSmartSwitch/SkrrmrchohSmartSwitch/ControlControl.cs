using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SkrrmrchohSmartSwitch
{
    public partial class ControlControl : UserControl
    {
        public ControlControl()
        {
            InitializeComponent();
        }

        private void btnControl_Click(object sender, EventArgs e)
        {
            Client.Instance.Call(6, 1, 3, 0, 0, new byte[0]);
        }

        private void btnSetTime_Click(object sender, EventArgs e)
        {
            int hour = dtToSet.Value.Hour;
            int min = dtToSet.Value.Minute;
            int sec = dtToSet.Value.Second;

            List<byte> data = new List<byte>();
            data.Add(Convert.ToByte(hour));
            data.Add(Convert.ToByte(min));
            data.Add(Convert.ToByte(sec));
            Client.Instance.Call(6, 1, 4, 0, 0, data.ToArray());
        }

        private void btnGetTime_Click(object sender, EventArgs e)
        {
            var result = Client.Instance.Call(6, 1, 5, 0, 0, new byte[0]);
            if (result.data.Length > 3)
            {
                lblGetTime.Text = "";
                lblGetTime.Text += result.data[0].ToString();
                lblGetTime.Text += ":";
                lblGetTime.Text += result.data[1].ToString();
                lblGetTime.Text += ":";
                lblGetTime.Text += result.data[2].ToString();
            }
        }

        private void btnGetSwitches_Click(object sender, EventArgs e)
        {
            var result = Client.Instance.Call(6, 1, 3, 0, 0, new byte[0]);
            if (result.data.Length > 3)
            {
                var value = BitConverter.ToInt32(result.data, 0);
                lvSwitches.Items.Clear();
                for (int bi = 0; bi < 3; bi++)
                {
                    for (int i = 7; i >= 0; i--)
                    {
                        var lvItem = lvSwitches.Items.Add((bi * 8 + (8-i)).ToString());
                        var b = result.data[bi];
                        lvItem.SubItems.Add((b & (1 << i)) == 0 ? "0" : "1");
                    }
                }
            }
        }

        private void btnGetRelays_Click(object sender, EventArgs e)
        {
            var result = Client.Instance.Call(6, 1, 6, 0, 0, new byte[0]);
            if (result.data.Length > 3)
            {
                var value = BitConverter.ToInt32(result.data, 0);
                lvRelays.Items.Clear();
                for (int bi = 0; bi < 2; bi++)
                {
                    for (int i = 0; i < 8; i++)
                    {
                        var lvItem = lvRelays.Items.Add((bi * 8 + i).ToString());
                        var b = result.data[bi];
                        lvItem.SubItems.Add((b & (1 << i)) == 0 ? "0" : "1");
                    }
                }
            }
        }

        private void btnRelayON_Click(object sender, EventArgs e)
        {
            Client.Instance.Call(6, 1, 7, Convert.ToByte(numRelayNum.Value), 0, new byte[1] { 1 });
            btnGetRelays_Click(this, new EventArgs());
        }

        private void btnRelayOFF_Click(object sender, EventArgs e)
        {
            Client.Instance.Call(6, 1, 7, Convert.ToByte(numRelayNum.Value), 0, new byte[1] { 0 });
            btnGetRelays_Click(this, new EventArgs());
        }
    }
}

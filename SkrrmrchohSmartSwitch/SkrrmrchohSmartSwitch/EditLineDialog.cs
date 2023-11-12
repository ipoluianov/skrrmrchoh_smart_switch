using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SkrrmrchohSmartSwitch
{
    public partial class EditLineDialog : Form
    {
        private EEPROM eeprom = new EEPROM();

        private bool loadingTable = false;
        private bool loadingDetails = false;

        public List<byte> row = new List<byte>();

        public EditLineDialog(List<byte> r)
        {
            row = new List<byte>();
            for (int i = 0; i < r.Count; i++)
                row.Add(r[i]);
            InitializeComponent();
            initCombos();
        }

        private void EditLineDialog_Load(object sender, EventArgs e)
        {
            loadingDetails = true;

            if (row[0] >= 0 && row[0] <= 15)
                cmbRelayNumber.SelectedIndex = row[0];
            else
                cmbRelayNumber.SelectedIndex = 16;

            /*if (row[1] >= 0 && row[1] <= 2)
                cmbAction.SelectedIndex = row[1];
            else
                cmbAction.SelectedIndex = 3;
                */
            if (row[2] >= 0 && row[2] <= 23)
                cmbSwitchFallingEdge.SelectedIndex = row[2];
            else
                cmbSwitchFallingEdge.SelectedIndex = 24;

            if (row[3] >= 0 && row[3] <= 23)
                cmbSwitchRisingEdge.SelectedIndex = row[3];
            else
                cmbSwitchRisingEdge.SelectedIndex = 24;

            if (row[4] >= 0 && row[4] <= 15)
                cmbRelayFallingEdge.SelectedIndex = row[4];
            else
                cmbRelayFallingEdge.SelectedIndex = 16;

            if (row[5] >= 0 && row[5] <= 15)
                cmbRelayRisingEdge.SelectedIndex = row[5];
            else
                cmbRelayRisingEdge.SelectedIndex = 16;

            if (row[6] >= 0 && row[6] <= 23)
                cmbSwitchDoubleClick.SelectedIndex = row[6];
            else
                cmbSwitchDoubleClick.SelectedIndex = 24;

            loadingDetails = false;

        }

        private void initCombos()
        {
            // Relays
            for (int i = 0; i < 16; i++)
            {
                cmbRelayNumber.Items.Add(i);
                cmbRelayFallingEdge.Items.Add(i);
                cmbRelayRisingEdge.Items.Add(i);
            }

            cmbRelayNumber.Items.Add("---");
            cmbRelayFallingEdge.Items.Add("---");
            cmbRelayRisingEdge.Items.Add("---");

            /*cmbAction.Items.Add("ON");
            cmbAction.Items.Add("OFF");
            cmbAction.Items.Add("INVERT");
            cmbAction.Items.Add("---");*/

            // Switches
            for (int i = 0; i < 24; i++)
            {
                cmbSwitchFallingEdge.Items.Add(i);
                cmbSwitchRisingEdge.Items.Add(i);
                cmbSwitchDoubleClick.Items.Add(i);
            }

            cmbSwitchFallingEdge.Items.Add("---");
            cmbSwitchRisingEdge.Items.Add("---");
            cmbSwitchDoubleClick.Items.Add("---");
        }

        private void cmbRelayNumber_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbRelayNumber.SelectedIndex >= 0 && cmbRelayNumber.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayNumber.SelectedIndex);
            row[0] = value;
        }

        private void cmbAction_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            /*if (cmbAction.SelectedIndex >= 0 && cmbAction.SelectedIndex <= 2)
                value = Convert.ToByte(cmbAction.SelectedIndex);*/
            row[1] = value;
        }

        private void cmbSwitchFallingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbSwitchFallingEdge.SelectedIndex >= 0 && cmbSwitchFallingEdge.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchFallingEdge.SelectedIndex);
            row[2] = value;
        }

        private void cmbSwitchRisingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbSwitchRisingEdge.SelectedIndex >= 0 && cmbSwitchRisingEdge.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchRisingEdge.SelectedIndex);
            row[3] = value;
        }

        private void cmbRelayFallingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbRelayFallingEdge.SelectedIndex >= 0 && cmbRelayFallingEdge.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayFallingEdge.SelectedIndex);
            row[4] = value;
        }

        private void cmbRelayRisingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbRelayRisingEdge.SelectedIndex >= 0 && cmbRelayRisingEdge.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayRisingEdge.SelectedIndex);
            row[5] = value;
        }

        private void cmbSwitchDoubleClick_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingDetails)
                return;
            byte value = 255;
            if (cmbSwitchDoubleClick.SelectedIndex >= 0 && cmbSwitchDoubleClick.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchDoubleClick.SelectedIndex);
            row[6] = value;
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.OK;
            Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }
    }
}

﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SkrrmrchohSmartSwitch
{
    public partial class ControlEEPROM : UserControl
    {
        private EEPROM eeprom = new EEPROM();

        private bool loadingTable = false;
        private bool loadingDetails = false;

        public ControlEEPROM()
        {
            InitializeComponent();
            initCombos();
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

            cmbAction.Items.Add("ON");
            cmbAction.Items.Add("OFF");
            cmbAction.Items.Add("INVERT");
            cmbAction.Items.Add("---");

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

        private void btnLoad_Click(object sender, EventArgs e)
        {
            eeprom.LoadFromFile();
            loadTable();
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            eeprom.SaveToFile();
        }

        private void btnSaveAs_Click(object sender, EventArgs e)
        {
            eeprom.SaveToFile();
        }

        private void btnLoadFromDevice_Click(object sender, EventArgs e)
        {
            var response = Client.Instance.Call(6, 1, 2, 0, 0, new byte[0]);
            if (response.result == 0 && response.data.Length == 19)
            {
                for (int bIndex = 0; bIndex < 16; bIndex++)
                    eeprom.SetSettings(bIndex, response.data[bIndex]);
            }

            for (int i = 0; i < EEPROM.CountOfRows; i++)
            {
                List<byte> data = new List<byte>();
                response = Client.Instance.Call(6, 1, 2, Convert.ToByte(i + 1), 0, data.ToArray());
                if (response.result == 0 && response.data.Length == 19)
                {
                    for (int bIndex = 0; bIndex < 16; bIndex++)
                        eeprom.Set(i, bIndex, response.data[bIndex]);
                }
            }
            loadTable();
        }

        private void btnSaveToDevice_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < EEPROM.CountOfRows; i++)
            {
                var row = eeprom.Row(i);
                List<byte> data = new List<byte>();
                Client.Instance.Call(6, 1, 1, Convert.ToByte(i + 1), 0, row.ToArray());
            }
        }

        public void loadTable()
        {
            loadingTable = true;
            int lastSelectedItem = -1;
            if (lvEEPROM.SelectedItems.Count == 1)
                lastSelectedItem = lvEEPROM.SelectedItems[0].Index;
            lvEEPROM.Items.Clear();
            for (int i = 0; i < EEPROM.CountOfRows; i++)
            {
                var row = eeprom.Row(i);
                var lvItem = lvEEPROM.Items.Add(i.ToString());

                lvItem.SubItems.Add(row[0].ToString("X2"));
                lvItem.SubItems.Add(row[1].ToString("X2"));
                lvItem.SubItems.Add(row[2].ToString("X2"));
                lvItem.SubItems.Add(row[3].ToString("X2"));
                lvItem.SubItems.Add(row[4].ToString("X2"));
                lvItem.SubItems.Add(row[5].ToString("X2"));
                lvItem.SubItems.Add(row[6].ToString("X2"));
                lvItem.SubItems.Add(row[7].ToString("X2"));
                lvItem.SubItems.Add(row[8].ToString("X2"));
                lvItem.SubItems.Add(row[9].ToString("X2"));
                lvItem.SubItems.Add(row[10].ToString("X2"));
                lvItem.SubItems.Add(row[11].ToString("X2"));
                lvItem.SubItems.Add(row[12].ToString("X2"));
                lvItem.SubItems.Add(row[13].ToString("X2"));
                lvItem.SubItems.Add(row[14].ToString("X2"));
                lvItem.SubItems.Add(row[15].ToString("X2"));
            }
            if (lastSelectedItem > -1)
            {
                lvEEPROM.Items[lastSelectedItem].Selected = true;
            }

            {
                lvSettings.Items.Clear();
                // Loading Settings Line
                List<byte> row = eeprom.SettingsRow();
                var lvItem = lvSettings.Items.Add(row[0].ToString("X2"));

                lvItem.SubItems.Add(row[1].ToString("X2"));
                lvItem.SubItems.Add(row[2].ToString("X2"));
                lvItem.SubItems.Add(row[3].ToString("X2"));
            }

            loadingTable = false;
        }

        private void lvEEPROM_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadDetails();
        }

        void loadDetails()
        {
            if (lvEEPROM.SelectedItems.Count != 1)
            {
                grLine.Enabled = false;
                return;
            }
            loadingDetails = true;
            grLine.Enabled = true;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;

            var row = eeprom.Row(rowIndex);

            txtLineIndex.Text = rowIndex.ToString();


            if (row[0] >= 0 && row[0] <= 15)
                cmbRelayNumber.SelectedIndex = row[0];
            else
                cmbRelayNumber.SelectedIndex = 16;

            if (row[1] >= 0 && row[1] <= 2)
                cmbAction.SelectedIndex = row[1];
            else
                cmbAction.SelectedIndex = 3;

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

        private void cmbRelayNumber_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbRelayNumber.SelectedIndex >= 0 && cmbRelayNumber.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayNumber.SelectedIndex);
            eeprom.Set(rowIndex, 0, value);
            loadTable();
        }

        private void cmbAction_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbAction.SelectedIndex >= 0 && cmbAction.SelectedIndex <= 2)
                value = Convert.ToByte(cmbAction.SelectedIndex);
            eeprom.Set(rowIndex, 1, value);
            loadTable();
        }

        private void cmbSwitchFallingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbSwitchFallingEdge.SelectedIndex >= 0 && cmbSwitchFallingEdge.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchFallingEdge.SelectedIndex);
            eeprom.Set(rowIndex, 2, value);
            loadTable();
        }

        private void cmbSwitchRisingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbSwitchRisingEdge.SelectedIndex >= 0 && cmbSwitchRisingEdge.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchRisingEdge.SelectedIndex);
            eeprom.Set(rowIndex, 3, value);
            loadTable();
        }

        private void cmbRelayFallingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbRelayFallingEdge.SelectedIndex >= 0 && cmbRelayFallingEdge.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayFallingEdge.SelectedIndex);
            eeprom.Set(rowIndex, 4, value);
            loadTable();
        }

        private void cmbRelayRisingEdge_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbRelayRisingEdge.SelectedIndex >= 0 && cmbRelayRisingEdge.SelectedIndex <= 15)
                value = Convert.ToByte(cmbRelayRisingEdge.SelectedIndex);
            eeprom.Set(rowIndex, 5, value);
            loadTable();
        }

        private void cmbSwitchDoubleClick_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (loadingTable)
                return;
            if (loadingDetails)
                return;
            if (lvEEPROM.SelectedItems.Count != 1)
                return;
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            byte value = 255;
            if (cmbSwitchDoubleClick.SelectedIndex >= 0 && cmbSwitchDoubleClick.SelectedIndex <= 23)
                value = Convert.ToByte(cmbSwitchDoubleClick.SelectedIndex);
            eeprom.Set(rowIndex, 6, value);
            loadTable();
        }

        private void lvEEPROM_DoubleClick(object sender, EventArgs e)
        {
            if (lvEEPROM.SelectedItems.Count != 1)
            {
                return;
            }
            int rowIndex = lvEEPROM.SelectedItems[0].Index;
            var row = eeprom.Row(rowIndex);
            var dialog = new EditLineDialog(row);
            dialog.ShowDialog(this);
        }
    }
}

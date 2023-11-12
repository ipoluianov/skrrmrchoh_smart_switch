namespace SkrrmrchohSmartSwitch
{
    partial class EditLineDialog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.grLine = new System.Windows.Forms.GroupBox();
            this.dtTime = new System.Windows.Forms.DateTimePicker();
            this.cmbSwitchDoubleClick = new System.Windows.Forms.ComboBox();
            this.cmbRelayRisingEdge = new System.Windows.Forms.ComboBox();
            this.cmbRelayFallingEdge = new System.Windows.Forms.ComboBox();
            this.cmbSwitchRisingEdge = new System.Windows.Forms.ComboBox();
            this.cmbSwitchFallingEdge = new System.Windows.Forms.ComboBox();
            this.cmbRelayNumber = new System.Windows.Forms.ComboBox();
            this.txtLineIndex = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.btnOK = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.rbON = new System.Windows.Forms.RadioButton();
            this.rbOFF = new System.Windows.Forms.RadioButton();
            this.rbINVERT = new System.Windows.Forms.RadioButton();
            this.grLine.SuspendLayout();
            this.SuspendLayout();
            // 
            // grLine
            // 
            this.grLine.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.grLine.Controls.Add(this.rbINVERT);
            this.grLine.Controls.Add(this.rbOFF);
            this.grLine.Controls.Add(this.rbON);
            this.grLine.Controls.Add(this.dtTime);
            this.grLine.Controls.Add(this.cmbSwitchDoubleClick);
            this.grLine.Controls.Add(this.cmbRelayRisingEdge);
            this.grLine.Controls.Add(this.cmbRelayFallingEdge);
            this.grLine.Controls.Add(this.cmbSwitchRisingEdge);
            this.grLine.Controls.Add(this.cmbSwitchFallingEdge);
            this.grLine.Controls.Add(this.cmbRelayNumber);
            this.grLine.Controls.Add(this.txtLineIndex);
            this.grLine.Controls.Add(this.label9);
            this.grLine.Controls.Add(this.label8);
            this.grLine.Controls.Add(this.label7);
            this.grLine.Controls.Add(this.label6);
            this.grLine.Controls.Add(this.label5);
            this.grLine.Controls.Add(this.label4);
            this.grLine.Controls.Add(this.label3);
            this.grLine.Controls.Add(this.label2);
            this.grLine.Controls.Add(this.label1);
            this.grLine.Location = new System.Drawing.Point(12, 12);
            this.grLine.Name = "grLine";
            this.grLine.Size = new System.Drawing.Size(287, 338);
            this.grLine.TabIndex = 2;
            this.grLine.TabStop = false;
            this.grLine.Text = "Line";
            // 
            // dtTime
            // 
            this.dtTime.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dtTime.CustomFormat = "HH:mm";
            this.dtTime.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.dtTime.Location = new System.Drawing.Point(115, 228);
            this.dtTime.Name = "dtTime";
            this.dtTime.ShowUpDown = true;
            this.dtTime.Size = new System.Drawing.Size(166, 20);
            this.dtTime.TabIndex = 10;
            // 
            // cmbSwitchDoubleClick
            // 
            this.cmbSwitchDoubleClick.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbSwitchDoubleClick.DropDownStyle = System.Windows.Forms.ComboBoxStyle.Simple;
            this.cmbSwitchDoubleClick.FormattingEnabled = true;
            this.cmbSwitchDoubleClick.Location = new System.Drawing.Point(115, 201);
            this.cmbSwitchDoubleClick.Name = "cmbSwitchDoubleClick";
            this.cmbSwitchDoubleClick.Size = new System.Drawing.Size(166, 21);
            this.cmbSwitchDoubleClick.TabIndex = 9;
            this.cmbSwitchDoubleClick.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchDoubleClick_SelectedIndexChanged);
            // 
            // cmbRelayRisingEdge
            // 
            this.cmbRelayRisingEdge.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbRelayRisingEdge.FormattingEnabled = true;
            this.cmbRelayRisingEdge.Location = new System.Drawing.Point(115, 174);
            this.cmbRelayRisingEdge.Name = "cmbRelayRisingEdge";
            this.cmbRelayRisingEdge.Size = new System.Drawing.Size(166, 21);
            this.cmbRelayRisingEdge.TabIndex = 8;
            this.cmbRelayRisingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbRelayRisingEdge_SelectedIndexChanged);
            // 
            // cmbRelayFallingEdge
            // 
            this.cmbRelayFallingEdge.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbRelayFallingEdge.FormattingEnabled = true;
            this.cmbRelayFallingEdge.Location = new System.Drawing.Point(115, 147);
            this.cmbRelayFallingEdge.Name = "cmbRelayFallingEdge";
            this.cmbRelayFallingEdge.Size = new System.Drawing.Size(166, 21);
            this.cmbRelayFallingEdge.TabIndex = 7;
            this.cmbRelayFallingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbRelayFallingEdge_SelectedIndexChanged);
            // 
            // cmbSwitchRisingEdge
            // 
            this.cmbSwitchRisingEdge.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbSwitchRisingEdge.FormattingEnabled = true;
            this.cmbSwitchRisingEdge.Location = new System.Drawing.Point(115, 120);
            this.cmbSwitchRisingEdge.Name = "cmbSwitchRisingEdge";
            this.cmbSwitchRisingEdge.Size = new System.Drawing.Size(166, 21);
            this.cmbSwitchRisingEdge.TabIndex = 6;
            this.cmbSwitchRisingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchRisingEdge_SelectedIndexChanged);
            // 
            // cmbSwitchFallingEdge
            // 
            this.cmbSwitchFallingEdge.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbSwitchFallingEdge.FormattingEnabled = true;
            this.cmbSwitchFallingEdge.Location = new System.Drawing.Point(115, 93);
            this.cmbSwitchFallingEdge.Name = "cmbSwitchFallingEdge";
            this.cmbSwitchFallingEdge.Size = new System.Drawing.Size(166, 21);
            this.cmbSwitchFallingEdge.TabIndex = 5;
            this.cmbSwitchFallingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchFallingEdge_SelectedIndexChanged);
            // 
            // cmbRelayNumber
            // 
            this.cmbRelayNumber.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbRelayNumber.FormattingEnabled = true;
            this.cmbRelayNumber.Location = new System.Drawing.Point(115, 39);
            this.cmbRelayNumber.Name = "cmbRelayNumber";
            this.cmbRelayNumber.Size = new System.Drawing.Size(166, 21);
            this.cmbRelayNumber.TabIndex = 1;
            this.cmbRelayNumber.SelectedIndexChanged += new System.EventHandler(this.cmbRelayNumber_SelectedIndexChanged);
            // 
            // txtLineIndex
            // 
            this.txtLineIndex.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtLineIndex.Location = new System.Drawing.Point(115, 13);
            this.txtLineIndex.Name = "txtLineIndex";
            this.txtLineIndex.ReadOnly = true;
            this.txtLineIndex.Size = new System.Drawing.Size(166, 20);
            this.txtLineIndex.TabIndex = 16;
            this.txtLineIndex.TabStop = false;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(6, 234);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(46, 13);
            this.label9.TabIndex = 8;
            this.label9.Text = "At Time:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(6, 204);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(105, 13);
            this.label8.TabIndex = 7;
            this.label8.Text = "Switch Double Click:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(6, 177);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(97, 13);
            this.label7.TabIndex = 6;
            this.label7.Text = "Relay Rising Edge:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(6, 150);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(98, 13);
            this.label6.TabIndex = 5;
            this.label6.Text = "Relay Falling Edge:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(6, 123);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(102, 13);
            this.label5.TabIndex = 4;
            this.label5.Text = "Switch Rising Edge:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(6, 96);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(103, 13);
            this.label4.TabIndex = 3;
            this.label4.Text = "Switch Falling Edge:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(6, 69);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(40, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Action:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 42);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(77, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Relay Number:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(59, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Line Index:";
            // 
            // btnOK
            // 
            this.btnOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOK.Location = new System.Drawing.Point(143, 356);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(75, 23);
            this.btnOK.TabIndex = 11;
            this.btnOK.Text = "OK";
            this.btnOK.UseVisualStyleBackColor = true;
            this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCancel.Location = new System.Drawing.Point(224, 356);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 12;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // rbON
            // 
            this.rbON.AutoSize = true;
            this.rbON.Location = new System.Drawing.Point(115, 67);
            this.rbON.Name = "rbON";
            this.rbON.Size = new System.Drawing.Size(41, 17);
            this.rbON.TabIndex = 2;
            this.rbON.TabStop = true;
            this.rbON.Text = "ON";
            this.rbON.UseVisualStyleBackColor = true;
            // 
            // rbOFF
            // 
            this.rbOFF.AutoSize = true;
            this.rbOFF.Location = new System.Drawing.Point(159, 67);
            this.rbOFF.Name = "rbOFF";
            this.rbOFF.Size = new System.Drawing.Size(45, 17);
            this.rbOFF.TabIndex = 3;
            this.rbOFF.TabStop = true;
            this.rbOFF.Text = "OFF";
            this.rbOFF.UseVisualStyleBackColor = true;
            // 
            // rbINVERT
            // 
            this.rbINVERT.AutoSize = true;
            this.rbINVERT.Location = new System.Drawing.Point(210, 67);
            this.rbINVERT.Name = "rbINVERT";
            this.rbINVERT.Size = new System.Drawing.Size(65, 17);
            this.rbINVERT.TabIndex = 4;
            this.rbINVERT.TabStop = true;
            this.rbINVERT.Text = "INVERT";
            this.rbINVERT.UseVisualStyleBackColor = true;
            // 
            // EditLineDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(311, 391);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.grLine);
            this.Name = "EditLineDialog";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "EEPROM Line";
            this.Load += new System.EventHandler(this.EditLineDialog_Load);
            this.grLine.ResumeLayout(false);
            this.grLine.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox grLine;
        private System.Windows.Forms.DateTimePicker dtTime;
        private System.Windows.Forms.ComboBox cmbSwitchDoubleClick;
        private System.Windows.Forms.ComboBox cmbRelayRisingEdge;
        private System.Windows.Forms.ComboBox cmbRelayFallingEdge;
        private System.Windows.Forms.ComboBox cmbSwitchRisingEdge;
        private System.Windows.Forms.ComboBox cmbSwitchFallingEdge;
        private System.Windows.Forms.ComboBox cmbRelayNumber;
        private System.Windows.Forms.TextBox txtLineIndex;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnOK;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.RadioButton rbINVERT;
        private System.Windows.Forms.RadioButton rbOFF;
        private System.Windows.Forms.RadioButton rbON;
    }
}
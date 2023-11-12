namespace SkrrmrchohSmartSwitch
{
    partial class ControlEEPROM
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lvEEPROM = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader5 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader6 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader7 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader8 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader9 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader10 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader11 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader12 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader13 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader14 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader15 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader16 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader17 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.grLine = new System.Windows.Forms.GroupBox();
            this.dtTime = new System.Windows.Forms.DateTimePicker();
            this.cmbSwitchDoubleClick = new System.Windows.Forms.ComboBox();
            this.cmbRelayRisingEdge = new System.Windows.Forms.ComboBox();
            this.cmbRelayFallingEdge = new System.Windows.Forms.ComboBox();
            this.cmbSwitchRisingEdge = new System.Windows.Forms.ComboBox();
            this.cmbSwitchFallingEdge = new System.Windows.Forms.ComboBox();
            this.cmbAction = new System.Windows.Forms.ComboBox();
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
            this.panelToolbox = new System.Windows.Forms.Panel();
            this.btnSaveToDevice = new System.Windows.Forms.Button();
            this.btnLoadFromDevice = new System.Windows.Forms.Button();
            this.btnSaveAs = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.btnLoad = new System.Windows.Forms.Button();
            this.lvSettings = new System.Windows.Forms.ListView();
            this.columnHeader18 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader19 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader20 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader21 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.grLine.SuspendLayout();
            this.panelToolbox.SuspendLayout();
            this.SuspendLayout();
            // 
            // lvEEPROM
            // 
            this.lvEEPROM.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lvEEPROM.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader4,
            this.columnHeader5,
            this.columnHeader6,
            this.columnHeader7,
            this.columnHeader8,
            this.columnHeader9,
            this.columnHeader10,
            this.columnHeader11,
            this.columnHeader12,
            this.columnHeader13,
            this.columnHeader14,
            this.columnHeader15,
            this.columnHeader16,
            this.columnHeader17});
            this.lvEEPROM.FullRowSelect = true;
            this.lvEEPROM.HideSelection = false;
            this.lvEEPROM.Location = new System.Drawing.Point(3, 107);
            this.lvEEPROM.Name = "lvEEPROM";
            this.lvEEPROM.Size = new System.Drawing.Size(1134, 334);
            this.lvEEPROM.TabIndex = 0;
            this.lvEEPROM.UseCompatibleStateImageBehavior = false;
            this.lvEEPROM.View = System.Windows.Forms.View.Details;
            this.lvEEPROM.SelectedIndexChanged += new System.EventHandler(this.lvEEPROM_SelectedIndexChanged);
            this.lvEEPROM.DoubleClick += new System.EventHandler(this.lvEEPROM_DoubleClick);
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Index";
            this.columnHeader1.Width = 50;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Relay Number";
            this.columnHeader2.Width = 80;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Action";
            this.columnHeader3.Width = 50;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Switch Falling Edge";
            this.columnHeader4.Width = 110;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "Switch Rising Edge";
            this.columnHeader5.Width = 110;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "Relay Falling Edge";
            this.columnHeader6.Width = 100;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "Relay Rising Edge";
            this.columnHeader7.Width = 100;
            // 
            // columnHeader8
            // 
            this.columnHeader8.Text = "Switch Double Click";
            this.columnHeader8.Width = 120;
            // 
            // columnHeader9
            // 
            this.columnHeader9.Text = "Time Hours";
            this.columnHeader9.Width = 80;
            // 
            // columnHeader10
            // 
            this.columnHeader10.Text = "Time Minutes";
            this.columnHeader10.Width = 80;
            // 
            // columnHeader11
            // 
            this.columnHeader11.Text = "Time Value";
            this.columnHeader11.Width = 80;
            // 
            // columnHeader12
            // 
            this.columnHeader12.Text = "Res";
            this.columnHeader12.Width = 50;
            // 
            // columnHeader13
            // 
            this.columnHeader13.Text = "Res";
            this.columnHeader13.Width = 50;
            // 
            // columnHeader14
            // 
            this.columnHeader14.Text = "Res";
            this.columnHeader14.Width = 50;
            // 
            // columnHeader15
            // 
            this.columnHeader15.Text = "Res";
            this.columnHeader15.Width = 50;
            // 
            // columnHeader16
            // 
            this.columnHeader16.Text = "Res";
            this.columnHeader16.Width = 50;
            // 
            // columnHeader17
            // 
            this.columnHeader17.Text = "Res";
            this.columnHeader17.Width = 50;
            // 
            // grLine
            // 
            this.grLine.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.grLine.Controls.Add(this.dtTime);
            this.grLine.Controls.Add(this.cmbSwitchDoubleClick);
            this.grLine.Controls.Add(this.cmbRelayRisingEdge);
            this.grLine.Controls.Add(this.cmbRelayFallingEdge);
            this.grLine.Controls.Add(this.cmbSwitchRisingEdge);
            this.grLine.Controls.Add(this.cmbSwitchFallingEdge);
            this.grLine.Controls.Add(this.cmbAction);
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
            this.grLine.Location = new System.Drawing.Point(1143, 41);
            this.grLine.Name = "grLine";
            this.grLine.Size = new System.Drawing.Size(258, 400);
            this.grLine.TabIndex = 1;
            this.grLine.TabStop = false;
            this.grLine.Text = "Line";
            // 
            // dtTime
            // 
            this.dtTime.CustomFormat = "HH:mm:ss";
            this.dtTime.Format = System.Windows.Forms.DateTimePickerFormat.Time;
            this.dtTime.Location = new System.Drawing.Point(115, 228);
            this.dtTime.Name = "dtTime";
            this.dtTime.Size = new System.Drawing.Size(121, 20);
            this.dtTime.TabIndex = 24;
            // 
            // cmbSwitchDoubleClick
            // 
            this.cmbSwitchDoubleClick.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSwitchDoubleClick.FormattingEnabled = true;
            this.cmbSwitchDoubleClick.Location = new System.Drawing.Point(115, 201);
            this.cmbSwitchDoubleClick.Name = "cmbSwitchDoubleClick";
            this.cmbSwitchDoubleClick.Size = new System.Drawing.Size(121, 21);
            this.cmbSwitchDoubleClick.TabIndex = 23;
            this.cmbSwitchDoubleClick.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchDoubleClick_SelectedIndexChanged);
            // 
            // cmbRelayRisingEdge
            // 
            this.cmbRelayRisingEdge.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRelayRisingEdge.FormattingEnabled = true;
            this.cmbRelayRisingEdge.Location = new System.Drawing.Point(115, 174);
            this.cmbRelayRisingEdge.Name = "cmbRelayRisingEdge";
            this.cmbRelayRisingEdge.Size = new System.Drawing.Size(121, 21);
            this.cmbRelayRisingEdge.TabIndex = 22;
            this.cmbRelayRisingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbRelayRisingEdge_SelectedIndexChanged);
            // 
            // cmbRelayFallingEdge
            // 
            this.cmbRelayFallingEdge.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRelayFallingEdge.FormattingEnabled = true;
            this.cmbRelayFallingEdge.Location = new System.Drawing.Point(115, 147);
            this.cmbRelayFallingEdge.Name = "cmbRelayFallingEdge";
            this.cmbRelayFallingEdge.Size = new System.Drawing.Size(121, 21);
            this.cmbRelayFallingEdge.TabIndex = 21;
            this.cmbRelayFallingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbRelayFallingEdge_SelectedIndexChanged);
            // 
            // cmbSwitchRisingEdge
            // 
            this.cmbSwitchRisingEdge.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSwitchRisingEdge.FormattingEnabled = true;
            this.cmbSwitchRisingEdge.Location = new System.Drawing.Point(115, 120);
            this.cmbSwitchRisingEdge.Name = "cmbSwitchRisingEdge";
            this.cmbSwitchRisingEdge.Size = new System.Drawing.Size(121, 21);
            this.cmbSwitchRisingEdge.TabIndex = 20;
            this.cmbSwitchRisingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchRisingEdge_SelectedIndexChanged);
            // 
            // cmbSwitchFallingEdge
            // 
            this.cmbSwitchFallingEdge.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbSwitchFallingEdge.FormattingEnabled = true;
            this.cmbSwitchFallingEdge.Location = new System.Drawing.Point(115, 93);
            this.cmbSwitchFallingEdge.Name = "cmbSwitchFallingEdge";
            this.cmbSwitchFallingEdge.Size = new System.Drawing.Size(121, 21);
            this.cmbSwitchFallingEdge.TabIndex = 19;
            this.cmbSwitchFallingEdge.SelectedIndexChanged += new System.EventHandler(this.cmbSwitchFallingEdge_SelectedIndexChanged);
            // 
            // cmbAction
            // 
            this.cmbAction.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbAction.FormattingEnabled = true;
            this.cmbAction.Location = new System.Drawing.Point(115, 66);
            this.cmbAction.Name = "cmbAction";
            this.cmbAction.Size = new System.Drawing.Size(121, 21);
            this.cmbAction.TabIndex = 18;
            this.cmbAction.SelectedIndexChanged += new System.EventHandler(this.cmbAction_SelectedIndexChanged);
            // 
            // cmbRelayNumber
            // 
            this.cmbRelayNumber.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRelayNumber.FormattingEnabled = true;
            this.cmbRelayNumber.Location = new System.Drawing.Point(115, 39);
            this.cmbRelayNumber.Name = "cmbRelayNumber";
            this.cmbRelayNumber.Size = new System.Drawing.Size(121, 21);
            this.cmbRelayNumber.TabIndex = 17;
            this.cmbRelayNumber.SelectedIndexChanged += new System.EventHandler(this.cmbRelayNumber_SelectedIndexChanged);
            // 
            // txtLineIndex
            // 
            this.txtLineIndex.Location = new System.Drawing.Point(115, 13);
            this.txtLineIndex.Name = "txtLineIndex";
            this.txtLineIndex.ReadOnly = true;
            this.txtLineIndex.Size = new System.Drawing.Size(121, 20);
            this.txtLineIndex.TabIndex = 16;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(6, 234);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(33, 13);
            this.label9.TabIndex = 8;
            this.label9.Text = "Time:";
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
            // panelToolbox
            // 
            this.panelToolbox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panelToolbox.Controls.Add(this.btnSaveToDevice);
            this.panelToolbox.Controls.Add(this.btnLoadFromDevice);
            this.panelToolbox.Controls.Add(this.btnSaveAs);
            this.panelToolbox.Controls.Add(this.btnSave);
            this.panelToolbox.Controls.Add(this.btnLoad);
            this.panelToolbox.Location = new System.Drawing.Point(3, 3);
            this.panelToolbox.Name = "panelToolbox";
            this.panelToolbox.Size = new System.Drawing.Size(1398, 32);
            this.panelToolbox.TabIndex = 2;
            // 
            // btnSaveToDevice
            // 
            this.btnSaveToDevice.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSaveToDevice.Location = new System.Drawing.Point(1239, 3);
            this.btnSaveToDevice.Name = "btnSaveToDevice";
            this.btnSaveToDevice.Size = new System.Drawing.Size(156, 23);
            this.btnSaveToDevice.TabIndex = 4;
            this.btnSaveToDevice.Text = "Save To Device";
            this.btnSaveToDevice.UseVisualStyleBackColor = true;
            this.btnSaveToDevice.Click += new System.EventHandler(this.btnSaveToDevice_Click);
            // 
            // btnLoadFromDevice
            // 
            this.btnLoadFromDevice.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnLoadFromDevice.Location = new System.Drawing.Point(1105, 3);
            this.btnLoadFromDevice.Name = "btnLoadFromDevice";
            this.btnLoadFromDevice.Size = new System.Drawing.Size(128, 23);
            this.btnLoadFromDevice.TabIndex = 3;
            this.btnLoadFromDevice.Text = "Load From Device";
            this.btnLoadFromDevice.UseVisualStyleBackColor = true;
            this.btnLoadFromDevice.Click += new System.EventHandler(this.btnLoadFromDevice_Click);
            // 
            // btnSaveAs
            // 
            this.btnSaveAs.Location = new System.Drawing.Point(218, 3);
            this.btnSaveAs.Name = "btnSaveAs";
            this.btnSaveAs.Size = new System.Drawing.Size(75, 23);
            this.btnSaveAs.TabIndex = 2;
            this.btnSaveAs.Text = "Save As ...";
            this.btnSaveAs.UseVisualStyleBackColor = true;
            this.btnSaveAs.Click += new System.EventHandler(this.btnSaveAs_Click);
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(137, 3);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(75, 23);
            this.btnSave.TabIndex = 1;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnLoad
            // 
            this.btnLoad.Location = new System.Drawing.Point(3, 3);
            this.btnLoad.Name = "btnLoad";
            this.btnLoad.Size = new System.Drawing.Size(128, 23);
            this.btnLoad.TabIndex = 0;
            this.btnLoad.Text = "Load From File";
            this.btnLoad.UseVisualStyleBackColor = true;
            this.btnLoad.Click += new System.EventHandler(this.btnLoad_Click);
            // 
            // lvSettings
            // 
            this.lvSettings.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lvSettings.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader18,
            this.columnHeader19,
            this.columnHeader20,
            this.columnHeader21});
            this.lvSettings.FullRowSelect = true;
            this.lvSettings.HideSelection = false;
            this.lvSettings.Location = new System.Drawing.Point(3, 41);
            this.lvSettings.Name = "lvSettings";
            this.lvSettings.Size = new System.Drawing.Size(1134, 60);
            this.lvSettings.TabIndex = 3;
            this.lvSettings.UseCompatibleStateImageBehavior = false;
            this.lvSettings.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader18
            // 
            this.columnHeader18.Text = "Lines Count";
            this.columnHeader18.Width = 150;
            // 
            // columnHeader19
            // 
            this.columnHeader19.Text = "Switches Inversion";
            this.columnHeader19.Width = 150;
            // 
            // columnHeader20
            // 
            this.columnHeader20.Text = "Turning OFF Block Timer";
            this.columnHeader20.Width = 150;
            // 
            // columnHeader21
            // 
            this.columnHeader21.Text = "Auto OFF Timer";
            this.columnHeader21.Width = 150;
            // 
            // ControlEEPROM
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.lvSettings);
            this.Controls.Add(this.panelToolbox);
            this.Controls.Add(this.grLine);
            this.Controls.Add(this.lvEEPROM);
            this.Name = "ControlEEPROM";
            this.Size = new System.Drawing.Size(1404, 444);
            this.grLine.ResumeLayout(false);
            this.grLine.PerformLayout();
            this.panelToolbox.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListView lvEEPROM;
        private System.Windows.Forms.GroupBox grLine;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.ColumnHeader columnHeader7;
        private System.Windows.Forms.ColumnHeader columnHeader8;
        private System.Windows.Forms.ColumnHeader columnHeader9;
        private System.Windows.Forms.ColumnHeader columnHeader10;
        private System.Windows.Forms.ColumnHeader columnHeader11;
        private System.Windows.Forms.ColumnHeader columnHeader12;
        private System.Windows.Forms.ColumnHeader columnHeader13;
        private System.Windows.Forms.ColumnHeader columnHeader14;
        private System.Windows.Forms.ColumnHeader columnHeader15;
        private System.Windows.Forms.ColumnHeader columnHeader16;
        private System.Windows.Forms.ColumnHeader columnHeader17;
        private System.Windows.Forms.Panel panelToolbox;
        private System.Windows.Forms.Button btnSaveAs;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.Button btnLoad;
        private System.Windows.Forms.Button btnSaveToDevice;
        private System.Windows.Forms.Button btnLoadFromDevice;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cmbSwitchFallingEdge;
        private System.Windows.Forms.ComboBox cmbAction;
        private System.Windows.Forms.ComboBox cmbRelayNumber;
        private System.Windows.Forms.TextBox txtLineIndex;
        private System.Windows.Forms.DateTimePicker dtTime;
        private System.Windows.Forms.ComboBox cmbSwitchDoubleClick;
        private System.Windows.Forms.ComboBox cmbRelayRisingEdge;
        private System.Windows.Forms.ComboBox cmbRelayFallingEdge;
        private System.Windows.Forms.ComboBox cmbSwitchRisingEdge;
        private System.Windows.Forms.ListView lvSettings;
        private System.Windows.Forms.ColumnHeader columnHeader18;
        private System.Windows.Forms.ColumnHeader columnHeader19;
        private System.Windows.Forms.ColumnHeader columnHeader20;
        private System.Windows.Forms.ColumnHeader columnHeader21;
    }
}

namespace SkrrmrchohSmartSwitch
{
    partial class ControlControl
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
            this.grControl = new System.Windows.Forms.GroupBox();
            this.btnControl = new System.Windows.Forms.Button();
            this.dtToSet = new System.Windows.Forms.DateTimePicker();
            this.btnSetTime = new System.Windows.Forms.Button();
            this.btnGetTime = new System.Windows.Forms.Button();
            this.lblGetTime = new System.Windows.Forms.Label();
            this.lvSwitches = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lvRelays = new System.Windows.Forms.ListView();
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.btnGetSwitches = new System.Windows.Forms.Button();
            this.btnGetRelays = new System.Windows.Forms.Button();
            this.btnRelayON = new System.Windows.Forms.Button();
            this.btnRelayOFF = new System.Windows.Forms.Button();
            this.numRelayNum = new System.Windows.Forms.NumericUpDown();
            this.grControl.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numRelayNum)).BeginInit();
            this.SuspendLayout();
            // 
            // grControl
            // 
            this.grControl.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.grControl.Controls.Add(this.numRelayNum);
            this.grControl.Controls.Add(this.btnRelayOFF);
            this.grControl.Controls.Add(this.btnRelayON);
            this.grControl.Controls.Add(this.btnGetRelays);
            this.grControl.Controls.Add(this.btnGetSwitches);
            this.grControl.Controls.Add(this.lvRelays);
            this.grControl.Controls.Add(this.lvSwitches);
            this.grControl.Controls.Add(this.lblGetTime);
            this.grControl.Controls.Add(this.btnGetTime);
            this.grControl.Controls.Add(this.btnSetTime);
            this.grControl.Controls.Add(this.dtToSet);
            this.grControl.Controls.Add(this.btnControl);
            this.grControl.Location = new System.Drawing.Point(3, 3);
            this.grControl.Name = "grControl";
            this.grControl.Size = new System.Drawing.Size(998, 798);
            this.grControl.TabIndex = 0;
            this.grControl.TabStop = false;
            this.grControl.Text = "Control";
            // 
            // btnControl
            // 
            this.btnControl.Location = new System.Drawing.Point(17, 28);
            this.btnControl.Name = "btnControl";
            this.btnControl.Size = new System.Drawing.Size(75, 23);
            this.btnControl.TabIndex = 0;
            this.btnControl.Text = "Control";
            this.btnControl.UseVisualStyleBackColor = true;
            this.btnControl.Click += new System.EventHandler(this.btnControl_Click);
            // 
            // dtToSet
            // 
            this.dtToSet.Format = System.Windows.Forms.DateTimePickerFormat.Time;
            this.dtToSet.Location = new System.Drawing.Point(17, 57);
            this.dtToSet.Name = "dtToSet";
            this.dtToSet.Size = new System.Drawing.Size(200, 20);
            this.dtToSet.TabIndex = 1;
            // 
            // btnSetTime
            // 
            this.btnSetTime.Location = new System.Drawing.Point(223, 58);
            this.btnSetTime.Name = "btnSetTime";
            this.btnSetTime.Size = new System.Drawing.Size(75, 23);
            this.btnSetTime.TabIndex = 2;
            this.btnSetTime.Text = "Set Time";
            this.btnSetTime.UseVisualStyleBackColor = true;
            this.btnSetTime.Click += new System.EventHandler(this.btnSetTime_Click);
            // 
            // btnGetTime
            // 
            this.btnGetTime.Location = new System.Drawing.Point(223, 87);
            this.btnGetTime.Name = "btnGetTime";
            this.btnGetTime.Size = new System.Drawing.Size(75, 23);
            this.btnGetTime.TabIndex = 3;
            this.btnGetTime.Text = "Get Time";
            this.btnGetTime.UseVisualStyleBackColor = true;
            this.btnGetTime.Click += new System.EventHandler(this.btnGetTime_Click);
            // 
            // lblGetTime
            // 
            this.lblGetTime.AutoSize = true;
            this.lblGetTime.Location = new System.Drawing.Point(14, 92);
            this.lblGetTime.Name = "lblGetTime";
            this.lblGetTime.Size = new System.Drawing.Size(35, 13);
            this.lblGetTime.TabIndex = 4;
            this.lblGetTime.Text = "label1";
            // 
            // lvSwitches
            // 
            this.lvSwitches.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader2});
            this.lvSwitches.HideSelection = false;
            this.lvSwitches.Location = new System.Drawing.Point(17, 146);
            this.lvSwitches.Name = "lvSwitches";
            this.lvSwitches.Size = new System.Drawing.Size(200, 482);
            this.lvSwitches.TabIndex = 5;
            this.lvSwitches.UseCompatibleStateImageBehavior = false;
            this.lvSwitches.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Index";
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Value";
            // 
            // lvRelays
            // 
            this.lvRelays.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader3,
            this.columnHeader4});
            this.lvRelays.HideSelection = false;
            this.lvRelays.Location = new System.Drawing.Point(237, 146);
            this.lvRelays.Name = "lvRelays";
            this.lvRelays.Size = new System.Drawing.Size(200, 482);
            this.lvRelays.TabIndex = 6;
            this.lvRelays.UseCompatibleStateImageBehavior = false;
            this.lvRelays.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Index";
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Value";
            // 
            // btnGetSwitches
            // 
            this.btnGetSwitches.Location = new System.Drawing.Point(17, 634);
            this.btnGetSwitches.Name = "btnGetSwitches";
            this.btnGetSwitches.Size = new System.Drawing.Size(200, 23);
            this.btnGetSwitches.TabIndex = 7;
            this.btnGetSwitches.Text = "Get Switches";
            this.btnGetSwitches.UseVisualStyleBackColor = true;
            this.btnGetSwitches.Click += new System.EventHandler(this.btnGetSwitches_Click);
            // 
            // btnGetRelays
            // 
            this.btnGetRelays.Location = new System.Drawing.Point(237, 634);
            this.btnGetRelays.Name = "btnGetRelays";
            this.btnGetRelays.Size = new System.Drawing.Size(200, 23);
            this.btnGetRelays.TabIndex = 8;
            this.btnGetRelays.Text = "Get Relays";
            this.btnGetRelays.UseVisualStyleBackColor = true;
            this.btnGetRelays.Click += new System.EventHandler(this.btnGetRelays_Click);
            // 
            // btnRelayON
            // 
            this.btnRelayON.Location = new System.Drawing.Point(653, 19);
            this.btnRelayON.Name = "btnRelayON";
            this.btnRelayON.Size = new System.Drawing.Size(75, 23);
            this.btnRelayON.TabIndex = 9;
            this.btnRelayON.Text = "Relay ON";
            this.btnRelayON.UseVisualStyleBackColor = true;
            this.btnRelayON.Click += new System.EventHandler(this.btnRelayON_Click);
            // 
            // btnRelayOFF
            // 
            this.btnRelayOFF.Location = new System.Drawing.Point(734, 19);
            this.btnRelayOFF.Name = "btnRelayOFF";
            this.btnRelayOFF.Size = new System.Drawing.Size(75, 23);
            this.btnRelayOFF.TabIndex = 10;
            this.btnRelayOFF.Text = "Relay OFF";
            this.btnRelayOFF.UseVisualStyleBackColor = true;
            this.btnRelayOFF.Click += new System.EventHandler(this.btnRelayOFF_Click);
            // 
            // numRelayNum
            // 
            this.numRelayNum.Location = new System.Drawing.Point(527, 19);
            this.numRelayNum.Name = "numRelayNum";
            this.numRelayNum.Size = new System.Drawing.Size(120, 20);
            this.numRelayNum.TabIndex = 11;
            // 
            // ControlControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.grControl);
            this.Name = "ControlControl";
            this.Size = new System.Drawing.Size(1004, 804);
            this.grControl.ResumeLayout(false);
            this.grControl.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numRelayNum)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox grControl;
        private System.Windows.Forms.Button btnControl;
        private System.Windows.Forms.DateTimePicker dtToSet;
        private System.Windows.Forms.Button btnSetTime;
        private System.Windows.Forms.Label lblGetTime;
        private System.Windows.Forms.Button btnGetTime;
        private System.Windows.Forms.Button btnGetRelays;
        private System.Windows.Forms.Button btnGetSwitches;
        private System.Windows.Forms.ListView lvRelays;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ListView lvSwitches;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.NumericUpDown numRelayNum;
        private System.Windows.Forms.Button btnRelayOFF;
        private System.Windows.Forms.Button btnRelayON;
    }
}

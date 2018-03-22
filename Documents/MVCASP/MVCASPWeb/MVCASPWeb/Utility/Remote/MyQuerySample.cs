using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Management;
namespace FileSending.Remote
{
    public class MyQuerySample : System.Windows.Forms.Form
    {
        private System.Windows.Forms.Label userNameLabel;
        private System.Windows.Forms.TextBox userNameBox;
        private System.Windows.Forms.TextBox passwordBox;
        private System.Windows.Forms.Label passwordLabel;
        private System.Windows.Forms.Button OKButton;
        private System.Windows.Forms.Button cancelButton;

        private System.ComponentModel.Container components = null;

        public MyQuerySample()
        {
            InitializeComponent();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.userNameLabel = new System.Windows.Forms.Label();
            this.userNameBox = new System.Windows.Forms.TextBox();
            this.passwordBox = new System.Windows.Forms.TextBox();
            this.passwordLabel = new System.Windows.Forms.Label();
            this.OKButton = new System.Windows.Forms.Button();
            this.cancelButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // userNameLabel
            // 
            this.userNameLabel.Location = new System.Drawing.Point(16, 8);
            this.userNameLabel.Name = "userNameLabel";
            this.userNameLabel.Size = new System.Drawing.Size(160, 32);
            this.userNameLabel.TabIndex = 0;
            this.userNameLabel.Text =
                "Enter the user name for the remote computer:";
            // 
            // userNameBox
            // 
            this.userNameBox.Location = new System.Drawing.Point(160, 16);
            this.userNameBox.Name = "userNameBox";
            this.userNameBox.Size = new System.Drawing.Size(192, 20);
            this.userNameBox.TabIndex = 1;
            this.userNameBox.Text = "";
            // 
            // passwordBox
            // 
            this.passwordBox.Location = new System.Drawing.Point(160, 48);
            this.passwordBox.Name = "passwordBox";
            this.passwordBox.PasswordChar = '*';
            this.passwordBox.Size = new System.Drawing.Size(192, 20);
            this.passwordBox.TabIndex = 3;
            this.passwordBox.Text = "";
            // 
            // passwordLabel
            // 
            this.passwordLabel.Location = new System.Drawing.Point(16, 48);
            this.passwordLabel.Name = "passwordLabel";
            this.passwordLabel.Size = new System.Drawing.Size(160, 32);
            this.passwordLabel.TabIndex = 2;
            this.passwordLabel.Text =
                "Enter the password for the remote computer:";
            // 
            // OKButton
            // 
            this.OKButton.Location = new System.Drawing.Point(40, 88);
            this.OKButton.Name = "OKButton";
            this.OKButton.Size = new System.Drawing.Size(128, 23);
            this.OKButton.TabIndex = 4;
            this.OKButton.Text = "OK";
            this.OKButton.Click +=
                new System.EventHandler(this.OKButton_Click);
            // 
            // cancelButton
            // 
            this.cancelButton.DialogResult =
                System.Windows.Forms.DialogResult.Cancel;
            this.cancelButton.Location = new System.Drawing.Point(200, 88);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(128, 23);
            this.cancelButton.TabIndex = 5;
            this.cancelButton.Text = "Cancel";
            this.cancelButton.Click +=
                new System.EventHandler(this.cancelButton_Click);
            // 
            // MyQuerySample
            // 
            this.AcceptButton = this.OKButton;
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.CancelButton = this.cancelButton;
            this.ClientSize = new System.Drawing.Size(368, 130);
            this.ControlBox = false;
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.OKButton);
            this.Controls.Add(this.passwordBox);
            this.Controls.Add(this.passwordLabel);
            this.Controls.Add(this.userNameBox);
            this.Controls.Add(this.userNameLabel);
            this.Name = "MyQuerySample";
            this.StartPosition =
                System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Remote Connection";
            this.ResumeLayout(false);

        }

   
        private void OKButton_Click(object sender, System.EventArgs e)
        {
            try
            {
                ConnectionOptions connection = new ConnectionOptions();
                connection.Username = userNameBox.Text;
                connection.Password = passwordBox.Text;
                connection.Authority = "ntlmdomain:DOMAIN";

                ManagementScope scope = new ManagementScope(
                    "\\\\haihd-pc.toshiba-tsdv.com\\root\\CIMV2", connection);
                scope.Connect();

                ObjectQuery query = new ObjectQuery(
                    "SELECT * FROM Win32_Service");

                ManagementObjectSearcher searcher =
                    new ManagementObjectSearcher(scope, query);

                foreach (ManagementObject queryObj in searcher.Get())
                {
                    Console.WriteLine("-----------------------------------");
                    Console.WriteLine("Win32_Service instance");
                    Console.WriteLine("-----------------------------------");
                    Console.WriteLine("Caption: {0}", queryObj["Caption"]);
                    Console.WriteLine("Description: {0}", queryObj["Description"]);
                    Console.WriteLine("Name: {0}", queryObj["Name"]);
                    Console.WriteLine("PathName: {0}", queryObj["PathName"]);
                    Console.WriteLine("State: {0}", queryObj["State"]);
                    Console.WriteLine("Status: {0}", queryObj["Status"]);
                }
                Close();
            }
            catch (ManagementException err)
            {
                MessageBox.Show("An error occured while querying for WMI data: "
                    + err.Message);
            }
            catch (System.UnauthorizedAccessException unauthorizedErr)
            {
                MessageBox.Show("Connection error " +
                    "(user name or password might be incorrect): " +
                    unauthorizedErr.Message);
            }
        }

        private void cancelButton_Click(object sender, System.EventArgs e)
        {
            Close();
        }

        public static void connect()
        {
            /*// Build an options object for the remote connection
            //   if you plan to connect to the remote
            //   computer with a different user name
            //   and password than the one you are currently using
          
                 ConnectionOptions options = 
                     new ConnectionOptions();
                 
                 // and then set the options.Username and 
                 // options.Password properties to the correct values
                 // and also set 
                 // options.Authority = "ntdlmdomain:DOMAIN";
                 // and replace DOMAIN with the remote computer's
                 // domain.  You can also use kerberose instead
                 // of ntdlmdomain.
            */

            // Make a connection to a remote computer.
            // Replace the "FullComputerName" section of the
            // string "\\\\FullComputerName\\root\\cimv2" with
            // the full computer name or IP address of the
            // remote computer.
            ManagementScope scope =
                new ManagementScope(
                    "\\\\loctv.toshiba-tsdv.com\\root\\cimv2");
            scope.Connect();

            // Use this code if you are connecting with a 
            // different user name and password:
            //
            // ManagementScope scope = 
            //    new ManagementScope(
            //        "\\\\FullComputerName\\root\\cimv2", options);
            // scope.Connect();

            //Query system for Operating System information
            ObjectQuery query = new ObjectQuery(
                "SELECT * FROM Win32_OperatingSystem");
            ManagementObjectSearcher searcher =
                new ManagementObjectSearcher(scope, query);

            ManagementObjectCollection queryCollection = searcher.Get();
            foreach (ManagementObject m in queryCollection)
            {
                // Display the remote computer information
                Console.WriteLine("Computer Name : {0}",
                    m["csname"]);
                Console.WriteLine("Windows Directory : {0}",
                    m["WindowsDirectory"]);
                Console.WriteLine("Operating System: {0}",
                    m["Caption"]);
                Console.WriteLine("Version: {0}", m["Version"]);
                Console.WriteLine("Manufacturer : {0}",
                    m["Manufacturer"]);
            }
        }
    }
}

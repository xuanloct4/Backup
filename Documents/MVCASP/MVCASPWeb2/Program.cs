using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Windows.Forms;
using System.Threading.Tasks;
using MVC.Utils;
using System.Net.NetworkInformation;

namespace MVC
{
    public class Program
    {
        [STAThread]
        public static void Main()
        {
            ////ConnectDatabase.connectDatabase();
            //ConnectDatabase.createTable();
            var asyncTask = Task.Run(() =>
            {
                var macAddr =
    (
        from nic in NetworkInterface.GetAllNetworkInterfaces()
        where nic.OperationalStatus == OperationalStatus.Up
        select nic.GetPhysicalAddress().ToString()
    ).FirstOrDefault();
                string a = macAddr.ToString();
                //Form1 _form = new Form1();
                //Application.EnableVisualStyles();
                //Application.SetCompatibleTextRenderingDefault(false);
                //Application.Run(_form);
                //_form.Show();
            });

            //MVCASPWeb.Utils.EventHandler.Test.Main();
            //MVCASPWeb.Utils.EventHandler.Test t = new Utils.EventHandler.Test();
            //t.ArrayTest();
            //MVCASPWeb.Utils.Delegate.Test.Main();
        }
    }
}
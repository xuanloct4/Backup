using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVCASPWeb.Models;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Threading;

namespace MVCASPWeb.Controllers
{

   
    public class TableController : Controller
    {
        private TableViewModelDBContext db = new TableViewModelDBContext();
        // GET: Table
        public ActionResult Index()
        {
            List<string> eee = new List<string>{"~/Resource/Images/IMG_0096.PNG","~/Resource/Images/IMG_0096.PNG"};

            List<TableModel> bbb = new List<TableModel>();
            for (int i = 0; i < 10; i++)
            { 
            TableModel a = new TableModel();
            a.imgUrl = "~/Resource/Images/IMG_0096.PNG";
            bbb.Add(a);
            }

            //var views = from m in db.TableView
            //             select m;
          
            ViewBag.rowNumber = 3; 
            //Number of your table's columns
            ViewBag.colNumber = 1; 
            return View(bbb);
        }


        public ActionResult Edit()
        {
            //try
            //{
            //    // Create An instance of the Process class responsible for starting the newly process.
            //    System.Diagnostics.Process process1 = new System.Diagnostics.Process();
            //    // Set the filename name of the file you want to execute/open
            //    process1.StartInfo.FileName = @"C:\Windows\system32\cmd.exe";
            //    process1.StartInfo.Arguments = "args";

            //    // Start the process without blocking the current thread
            //    process1.Start();
            //    // you may wait until finish that executable
            //    process1.WaitForExit();
            //    //or you can wait for a certain time interval 
            //    Thread.Sleep(20000);//Assume within 20 seconds it will finish processing. 
            //    process1.Close();
            //}
            //catch (Exception ex)
            //{
            //    Console.Write(ex);
            //} 
           
            var pirates = new List<Person>
    {
        new Person("Jack", "Sparrow"),
        new Person("Will", "Turner"),
        new Person("Elizabeth", "Swann")
    };
            
            return View(new BlackPearlViewModel(pirates));
        }

      
    }
}
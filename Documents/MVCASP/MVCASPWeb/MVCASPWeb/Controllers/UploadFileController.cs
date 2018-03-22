using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVC.Controllers
{
    public class UploadFileController : Controller
    {
        public string currentDir = AppDomain.CurrentDomain.BaseDirectory + "/App_Data/uploads/";

        [HttpPost]
        public ActionResult Index(IEnumerable<HttpPostedFileBase> files)
        {
            foreach (var file in files)
            {
                if (file != null)
                {
                    if (file.ContentLength > 0)
                    {
                        var fileName = Path.GetFileName(file.FileName);

                        //var path = Path.Combine(Server.MapPath("~/App_Data/uploads"), fileName);
                        var path = Path.Combine(currentDir, fileName);

                        file.SaveAs(path);
                    }
                }
            }
            return RedirectToAction("Index");
        }

        public ActionResult DownloadFile(string filepath)
        {
            //string filename = "chấm công hc t5.xlsx";
            //string filepath = AppDomain.CurrentDomain.BaseDirectory + "/App_Data/uploads/" + filename;

            bool isDir = (System.IO.File.GetAttributes(filepath) & FileAttributes.Directory)
                 == FileAttributes.Directory;
            if (isDir)
            {
                currentDir = filepath;
                return RedirectToAction("Index", new { path = filepath });
            }



            //byte[] filedata;
            //using (var fs = new FileStream(filepath, FileMode.Open, FileAccess.Read))
            //{
            //    filedata = new byte[fs.Length];
            //    int bytesRead = fs.Read(filedata, 0, filedata.Length);
            //    // buffer now contains the entire contents of the file
            //}

            byte[] filedata = System.IO.File.ReadAllBytes(filepath);

            string contentType = MimeMapping.GetMimeMapping(filepath);

            var cd = new System.Net.Mime.ContentDisposition
            {
                //FileName = filename,
                FileName = Path.GetFileName(filepath),
                Inline = true,
            };

            Response.AppendHeader("Content-Disposition", cd.ToString());

            return File(filedata, contentType);
        }

        public ActionResult Delete(string filepath)
        {

            //bool isDir = (System.IO.File.GetAttributes(filepath) & FileAttributes.Directory)
            //== FileAttributes.Directory;

            if (System.IO.File.Exists(filepath))
            {
                System.IO.File.Delete(filepath);
            }

            return RedirectToAction("Index", new { path = currentDir });
        }

        public static List<string> getFilesFromDir(string path)
        {
            List<string> fileList = new List<string>();
            fileList.Add(Directory.GetParent(path).ToString());
            try
            {
                // Only get files that begin with the letter "c."
                string[] files = Directory.GetFiles(path);
                string[] dirs = Directory.GetDirectories(path);
                //Console.WriteLine("The number of files starting with c is {0}.", dirs.Length);
                foreach (string file in files)
                {
                    fileList.Add(file);
                    //Console.WriteLine(file);
                }

                foreach (string dir in dirs)
                {
                    fileList.Add(dir);
                    //Console.WriteLine(dir);
                }
            }
            catch (Exception e)
            {
                //Console.WriteLine("The process failed: {0}", e.ToString());
            }


            return fileList;
        }

        // GET: UploadFile
        //public ActionResult Index()
        //{
        //    //string dir = AppDomain.CurrentDomain.BaseDirectory + "/App_Data/uploads/";
        //    List<string> fileList = getFilesFromDir(currentDir);

        //    return View(fileList);
        //}

        public ActionResult Index(string path)
        {
            List<string> fileList;
            //string dir = AppDomain.CurrentDomain.BaseDirectory + "/App_Data/uploads/";
            if (path == null)
            {
                fileList = getFilesFromDir(currentDir);
            }
            else
            {
                fileList = getFilesFromDir(path);
            }
            return View(fileList);
        }



        // GET: UploadFile/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: UploadFile/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: UploadFile/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: UploadFile/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: UploadFile/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

    }
}

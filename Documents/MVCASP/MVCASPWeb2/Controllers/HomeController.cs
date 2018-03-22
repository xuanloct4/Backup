using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVCASPWeb.Models;

namespace MVCASPWeb.Controllers
{
    public class HomeController : Controller
    {
        // 
        // GET: /Video/
        public ActionResult Video()
        {
           string[] _selected = {"x_4CNvG1Q_M" , "raRaxt_KM9Q" , "8qSeYLhe09s"};
          String _st = YouTubeScript.Get(_selected[0], true, 600, 600, false, "", "", 60);

            return new VideoResult();
        }

        //public ActionResult Index()
        //{
 
        //    return View();
        //}

        //[HttpGet]
        //public JsonResult About(string id)
        //{
        //    string newId = id;
        //    return Json(newId, JsonRequestBehavior.AllowGet);

        //}

        [HttpPost]
        public ActionResult Index(FormCollection form)
        {
            ViewBag.id = "Geeeet";
            return View();
   
        }

        public ActionResult Index(string index)
        {
          
            //if (index == null)
            //{ ViewBag.id = "xxx"; }
            //else { ViewBag.id = index; }

            ViewBag.id = Request.Params["id"];

            List<string> eee = new List<string> { "~/Resource/Videos/movie.mp4", "~/Resource/Videos/movie.mp4"};

            List<TableModel> bbb = new List<TableModel>();
            for (int i = 0; i < 10; i++)
            {
                TableModel a = new TableModel();
                a.imgUrl = "~/Resource/Videos/movie.mp4";
                bbb.Add(a);
            }

            TableModel a1 = new TableModel();
                a1.imgUrl = "~/Resource/Videos/590x90.swf";
                bbb.Add(a1);

            ViewBag.videoUrl = "~/Resource/Videos/movie.mp4";

            return View(bbb);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";


            //return RedirectToAction("_ViewPage1","Shared");
            //return JavaScript("document.writeln(\"executing static JS\");");
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}
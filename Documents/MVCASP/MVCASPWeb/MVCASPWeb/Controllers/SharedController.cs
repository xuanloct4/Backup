using MVCASPWeb.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVCASPWeb.Controllers
{
    public class SharedController : Controller
    {
        public ActionResult ViewPage1()
        {
            ViewBag.abc = "xxxxxx";
            return View("~/Views/Shared/_ViewPage1.cshtml");
        }

        public ActionResult Layout()
        {
            ViewBag.abc = "xxxxxx";
            return View("~/Views/Shared/_Layout.cshtml");
        }

        public ActionResult PartialPage1(int? col , int? row)
        {
            List<string> eee = new List<string> { "~/Resource/Images/IMG_0096.PNG", "~/Resource/Images/IMG_0096.PNG" };

            List<TableModel> bbb = new List<TableModel>();
            for (int i = 0; i < 10; i++)
            {
                TableModel a = new TableModel();
                a.imgUrl = "~/Resource/Images/IMG_0096.PNG";
                bbb.Add(a);
            }
            if (row != null)
            {
                ViewBag.rowNumber = row;
            }
            else { ViewBag.rowNumber = 2; }
            //Number of your table's columns
            if (col != null)
            {
                ViewBag.colNumber = col;
            }
            else {
                ViewBag.colNumber = 2;
            }
            ViewBag.abc = "xxxxxx";
            return View("~/Views/Shared/_PartialPage1.cshtml",bbb);
        }

        // GET: Shared
        public ActionResult Index()
        {
            return View();
        }

        // GET: Shared/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Shared/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Shared/Create
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

        // GET: Shared/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Shared/Edit/5
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

        // GET: Shared/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Shared/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}

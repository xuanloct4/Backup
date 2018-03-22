using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace MVCASPWeb.Controllers
{
    public class DrawController : Controller
    {
        public static string styleFromFile(string cssPathRelative, System.Web.Mvc.Controller controller)
        {
            string cssPath = controller.Server.MapPath(cssPathRelative);
            string text = System.IO.File.ReadAllText(cssPath);
            text = Regex.Replace(text, "[\n\r]", "");
            string value = "<style>" + text + "</style>";
            return value;
        }

        public static string scriptFromFile(string jsPathRelative, System.Web.Mvc.Controller controller)
        {
            string jsPath = controller.Server.MapPath("./Scripts/static.js");
            string text = System.IO.File.ReadAllText(jsPath);
            //text = Regex.Replace(text, "[\n\r]", "");
            string value = "<script>" + text + "</script>";
            return value;
        }
        public ActionResult Index()
        {
            //MonitorSample _monitrSpl = new MonitorSample();
            //MonitorSample.Main(null);

            // return JavaScript("StaticJsFunction()");

            System.Diagnostics.Debug.WriteLine("Debug:....");
            return View();
        }

        public ActionResult DrawFromModel(Model _model)
        {
            return View(_model);
        }
        public ActionResult Canvas()
        {
            //MonitorSample _monitrSpl = new MonitorSample();
            //MonitorSample.Main(null);

            // return JavaScript("StaticJsFunction()");

            System.Diagnostics.Debug.WriteLine("Debug:....");
            return View();
        }

        public ActionResult About()
        {
            //ViewBag.Message = "Your application description page.";
            //var htmlHelper = new HtmlHelper(new ViewContext(
            //                          ControllerContext,
            //                          new WebFormView(ControllerContext, "HACK"),
            //                          new ViewDataDictionary(),
            //                          new TempDataDictionary(),
            //                          new StringWriter()),
            //                    new ViewPage());

            //var otherViewHtml = htmlHelper.Action("ActionName", "ControllerName");

            //AccountController c = new AccountController();
            //ActionResult result = c.Register();
            //return result;

            //var otherController = DependencyResolver.Current.GetService<AccountController>();
            //return otherController.Register();

            return RedirectToAction("Register", "Account");
            //return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }

}

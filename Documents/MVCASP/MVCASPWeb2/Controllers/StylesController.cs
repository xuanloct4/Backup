using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApplication1.Controllers
{
    public class StylesController : Controller
    {
        public ActionResult Index()
        {
            return Content("Styles folder");
        }

        protected override void HandleUnknownAction(string actionName)
        {
            var res = this.CssFromView(actionName);
            res.ExecuteResult(ControllerContext);
        }
    }
}
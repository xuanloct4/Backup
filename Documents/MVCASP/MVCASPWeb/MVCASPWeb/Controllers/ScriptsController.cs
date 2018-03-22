using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApplication1.Controllers
{
    public class ScriptsController : Controller
    {
        [ActionName("DynamicWithModel.js")]
        public ActionResult Dynamic(string message)
        {
            return this.JavaScriptFromView(model: message);
        }

        public ActionResult Index()
        {
            return Content("Scripts folder");
        }

        protected override void HandleUnknownAction(string actionName)
        {
            var res = this.JavaScriptFromView();
            res.ExecuteResult(ControllerContext);
        }

    }

}
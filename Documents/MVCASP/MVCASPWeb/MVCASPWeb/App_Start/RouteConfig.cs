using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace MVCASPWeb
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Draw", action = "Canvas", id = UrlParameter.Optional }
            );

            routes.MapRoute(
         name: "Hello",
         url: "{controller}/{action}/{name}/{id}"
     );

//            Routes.MapHttpRoute(
//    name: "DefaultVideo",
//    routeTemplate: "api/{controller}/{ext}/{filename}"
//);

        }
    }
}

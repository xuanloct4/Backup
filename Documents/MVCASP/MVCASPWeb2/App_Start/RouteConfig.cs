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
                defaults: new { controller = "Movies", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
         name: "Hello",
         url: "{controller}/{action}/{name}/{id}"
     );

            routes.MapPageRoute("WebFormThing", "Calculator", "~/Default.aspx");

            //            Routes.MapHttpRoute(
            //    name: "DefaultVideo",
            //    routeTemplate: "api/{controller}/{ext}/{filename}"
            //);

        }
    }
}

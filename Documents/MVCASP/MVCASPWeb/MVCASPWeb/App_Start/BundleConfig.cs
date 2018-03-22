using System.Web;
using System.Web.Optimization;

namespace MVCASPWeb
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/Basic/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/Basic/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/Basic/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/Basic/bootstrap.js",
                      "~/Scripts/Basic/respond.js"));

            bundles.Add(new StyleBundle("~/bundles/css").Include(
                      "~/Content/Basic/bootstrap.css",
                      "~/Content/Basic/site.css",
                      "~/Content/Basic/StyleSheet1.css"));
        }
    }
}

using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MVCASPWeb.Startup))]
namespace MVCASPWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            //Program.Main();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVCASPWeb.Controllers
{
    public class AudioController : Controller
    {
        // GET: Audio
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult MyAudio()
        {
            var file = Server.MapPath("~/Resource/Audios/audio.mp3");
            return File(file, "audio/mp3");
        }
    }
}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;

namespace MVCASPWeb.Controllers
{
    public class VideoController : Controller
    {
        [HttpPost]
        public ActionResult Index(Guid id)
        {
            //FileTableInfo fi = new FileTableInfo(); 
            //ViewBag.ID = id; 
            //List<FileTableInfo> Lfi = fi.GetListofFileInfo(); 
            //return PartialView(Lfi); 
            return View();
        }

        //public ActionResult GetVideo(Guid id)
        public ActionResult GetVideo()
        {
            // FileTableInfo fi = new FileTableInfo(); 
            //// DataTable file = fi.GetAFile(id);    //using old way of access database 
            // DataTable file = fi.GetAFileFromFileTable(id); 
            // DataRow row = file.Rows[0]; 

            // string name = (string)row["video_name"]; 
            // string contentType = (string)row["content_Type"]; 
            // Byte[] video = (Byte[])row["data"]; 

            string name = "movie1.mp4";
            string contentType = "MP4";

            Byte[] video = null;

            //The File Path 
            var videoFilePath = HostingEnvironment.MapPath("~/Resource/Videos/movie1.mp4");

            var file = new FileInfo(videoFilePath);
            //Check the file exist,  it will be written into the response 
            if (file.Exists)
            {
                var stream = file.OpenRead();
                video = new byte[stream.Length];
                stream.Read(video, 0, (int)file.Length);

            }

            string mimeType;
            switch (contentType.ToUpper())
            {
                case "MOV":
                    mimeType = "video/quicktime";
                    break;
                case "MP4":
                    mimeType = "video/mp4";
                    break;
                case "FLV":
                    mimeType = "video/x-flv";
                    break;
                case "AVI":
                    mimeType = "video/x-msvideo";
                    break;
                case "WMV":
                    mimeType = "video/x-ms-wmv";
                    break;
                case "MJPG":
                    mimeType = "video/x-motion-jpeg";
                    break;
                case "TS":
                    mimeType = "video/MP2T";
                    break;
                default:
                    mimeType = "video/mp4";
                    break;
            }
            return File(video, mimeType);
        }
    }
}

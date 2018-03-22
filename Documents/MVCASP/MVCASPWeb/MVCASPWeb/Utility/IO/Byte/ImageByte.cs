using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.IO.Byte
{
    class ImageByte
    {

        public static byte[] imageToByteArray(System.Drawing.Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
            return ms.ToArray();
        }

        public static Image byteArrayToImage(byte[] byteArrayIn)
        {
            MemoryStream ms = new MemoryStream(byteArrayIn);
            Image returnImage = Image.FromStream(ms);
            return returnImage;
        }

        public static byte[] converterDemo(Image x)
        {
            ImageConverter _imageConverter = new ImageConverter();
            byte[] xByte = (byte[])_imageConverter.ConvertTo(x, typeof(byte[]));
            return xByte;
        }

        //public static byte[] imageToByteArray(System.Drawing.Image imageIn)
        //{
        //    using (var ms = new MemoryStream())
        //    {
        //        imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
        //        return ms.ToArray();
        //    }
        //}
    }
}

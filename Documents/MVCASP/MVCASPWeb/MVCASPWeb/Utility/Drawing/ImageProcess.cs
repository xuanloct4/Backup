using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Imaging;
namespace MVCASPWeb.Utility.Drawing
{
    class ImageProcess
    {
        public static void drawImage(PaintEventArgs e)
        {
            using (Bitmap src = new Bitmap("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\Circle.png"))
            using (var bmp = new Bitmap(100, 100, PixelFormat.Format32bppPArgb))
            using (var gr = Graphics.FromImage(bmp))
            {
                gr.Clear(Color.Blue);
                gr.DrawImage(src, new Rectangle(0, 0, bmp.Width, bmp.Height));
                bmp.Save("D:/result.png", ImageFormat.Png);
            }


            //// Create a Bitmap object from a file.
            //Bitmap myBitmap = new Bitmap("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\custom shape.bmp");

            //// Draw myBitmap to the screen.
            //e.Graphics.DrawImage(myBitmap, 0, 0, myBitmap.Width,
            //    myBitmap.Height);

            //// Set each pixel in myBitmap to black.
            //for (int Xcount = 0; Xcount < myBitmap.Width; Xcount++)
            //{
            //    for (int Ycount = 0; Ycount < myBitmap.Height; Ycount++)
            //    {
            //        myBitmap.SetPixel(Xcount, Ycount, Color.Black);
            //    }
            //}

            //// Draw myBitmap to the screen again.
            //e.Graphics.DrawImage(myBitmap, myBitmap.Width, 0,
            //    myBitmap.Width, myBitmap.Height);

            //// Construct a bitmap from the button image resource.
            //Bitmap bmp1 = new Bitmap("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\custom shape.bmp");

            //// Save the image as a GIF.
            //bmp1.Save("D:\\button.gif", System.Drawing.Imaging.ImageFormat.Gif);

            //// Construct a new image from the GIF file.
            //Bitmap bmp2 = new Bitmap("D:\\button.gif");

            //// Draw the two images.
            //e.Graphics.DrawImage(bmp1, new Point(10, 10));
            //e.Graphics.DrawImage(bmp2, new Point(10, 40));

            //// Dispose of the image files.
            //bmp1.Dispose();
            //bmp2.Dispose();

            //Image bitmap = Image.FromFile("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\custom shape.bmp");
            //bitmap.Save("D:\\MyFile2.bmp");  


            e.Graphics.DrawImage(Diff(new Bitmap("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\custom shape.bmp"), new Bitmap("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\Circle.png"), 0, 0, 0, 0, 200, 200), new Point(100, 100));
        }


        public static Bitmap Diff(Bitmap src1, Bitmap src2, int x1, int y1, int x2, int y2, int width, int height)
        {
            Bitmap diffBM = new Bitmap(width, height, PixelFormat.Format24bppRgb);

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    //Get Both Colours at the pixel point
                    Color col1 = src1.GetPixel(x1 + x, y1 + y);
                    Color col2 = src2.GetPixel(x2 + x, y2 + y);

                    //Get the difference RGB
                    int r = 0, g = 0, b = 0;
                    r = Math.Abs(col1.R - col2.R);
                    g = Math.Abs(col1.G - col2.G);
                    b = Math.Abs(col1.B - col2.B);

                    //Invert the difference average
                    int dif = 255 - ((r + g + b) / 3);

                    //Create new grayscale rgb colour
                    Color newcol = Color.FromArgb(dif, dif, dif);

                    diffBM.SetPixel(x, y, newcol);

                }
            }

            return diffBM;

        }

        private static Image CropImage(Image img, Rectangle cropArea)
        {
            try
            {
                Bitmap bmpImage = new Bitmap(img);
                Bitmap bmpCrop = bmpImage.Clone(cropArea, bmpImage.PixelFormat);
                return (Image)(bmpCrop);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "CropImage()");
            }
            return null;
        }

        private void saveJpeg(string path, Bitmap img, long quality)
        {
            // Encoder parameter for image quality
            EncoderParameter qualityParam = new EncoderParameter(
            System.Drawing.Imaging.Encoder.Quality, (long)quality);

            // Jpeg image codec
            ImageCodecInfo jpegCodec = getEncoderInfo("image/jpeg");

            if (jpegCodec == null)
            {
                MessageBox.Show("Can't find JPEG encoder?", "saveJpeg()");
                return;
            }
            EncoderParameters encoderParams = new EncoderParameters(1);
            encoderParams.Param[0] = qualityParam;

            img.Save(path, jpegCodec, encoderParams);
        }

        private ImageCodecInfo getEncoderInfo(string mimeType)
        {
            // Get image codecs for all image formats
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();

            // Find the correct image codec
            for (int i = 0; i < codecs.Length; i++)
                if (codecs[i].MimeType == mimeType)
                    return codecs[i];

            return null;
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            // output image size is based upon the visible crop rectangle and scaled to 
            // the ratio of actual image size to displayed image size
            Bitmap bmp = null;

            Rectangle ScaledCropRect = new Rectangle();
            //ScaledCropRect.X = (int)(CropRect.X / ZoomedRatio);
            //ScaledCropRect.Y = (int)(CropRect.Y / ZoomedRatio);
            //ScaledCropRect.Width = (int)((double)(CropRect.Width) / ZoomedRatio);
            //ScaledCropRect.Height = (int)((double)(CropRect.Height) / ZoomedRatio);

            //if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            //{
            //    try
            //    {
            //        bmp = (Bitmap)CropImage(pictureBox1.Image, ScaledCropRect);
            //        // 85% quality
            //        saveJpeg(saveFileDialog1.FileName, bmp, 85);
            //    }
            //    catch (Exception ex)
            //    {
            //        MessageBox.Show(ex.Message, "btnOK_Click()");
            //    }
            //}

            //if (bmp != null)
            //    bmp.Dispose();
        }
    }
}

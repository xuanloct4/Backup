using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.Utility.Drawing
{
    class DrawPixel
    {

        public static void drawPixel(PictureBox pictureBox, int bitmapWidth, int bitmapHeight, int drawPointX, int drawPointY, Color color)
        {
            if (pictureBox.Image != null) pictureBox.Image.Dispose();
            pictureBox.Image = new Bitmap(bitmapWidth, bitmapHeight);
            //double partWidth = (bitmapWidth / (double)16);
            //int r = (int)(255 * drawPointX / partWidth) % 256;
            //int g = (int)(255 * (drawPointY % partWidth) / partWidth) % 256;
            //int b = (int)(Math.Floor(drawPointX / partWidth) + Math.Floor(drawPointY / partWidth) * 16);
            //int r = 0;
            //int g = 0;
            //int b = 200;
            //    ((Bitmap)pictureBox.Image).SetPixel(drawPointX, drawPointY, Color.FromArgb(r, g, b));

            //Make sure draw point is valid
            if ((drawPointX <= bitmapWidth) && (drawPointY <= bitmapHeight))
            {
                ((Bitmap)pictureBox.Image).SetPixel(drawPointX, drawPointY, color);
            }
            pictureBox.Refresh();
        }

        public static void drawArrayPixelSameColor(PictureBox pictureBox, int bitmapWidth, int bitmapHeight, Color color, Point[] points)
        {
            if (pictureBox.Image != null) pictureBox.Image.Dispose();
            pictureBox.Image = new Bitmap(bitmapWidth, bitmapHeight);
            foreach (Point point in points)
            {
                 //Make sure draw point is valid
                if ((point.X <= bitmapWidth) && (point.Y <= bitmapHeight))
                {
                    ((Bitmap)pictureBox.Image).SetPixel(point.X, point.Y, color);
                }
            }
            pictureBox.Refresh();
        }

        public static void drawArrayPixelDiffColor(PictureBox pictureBox, int bitmapWidth, int bitmapHeight, Color[] color, Point[] points)
        {
            if (pictureBox.Image != null) pictureBox.Image.Dispose();
            pictureBox.Image = new Bitmap(bitmapWidth, bitmapHeight);
            for (int i = 0; i < points.Length; i++ )
            {
                 //Make sure draw point is valid
                if ((points[i].X <= bitmapWidth) && (points[i].Y <= bitmapHeight))
                {
                    ((Bitmap)pictureBox.Image).SetPixel(points[i].X, points[i].Y, color[i]);
                }
            }
            pictureBox.Refresh();
        }

        public static void drawPixelInRange(PictureBox pictureBox, int bitmapWidth, int bitmapHeight, Point startPoint, Point endPoint, Color color)
        {
            if (pictureBox.Image != null) pictureBox.Image.Dispose();
            pictureBox.Image = new Bitmap(bitmapWidth, bitmapHeight);
            double partWidth = (bitmapWidth / (double)16);
            //for (int i = startPoint.X; i < points.Length; i++)
            //{
            //    //Make sure draw point is valid
            //    if ((points[i].X <= bitmapWidth) && (points[i].Y <= bitmapHeight))
            //    {
            //        ((Bitmap)pictureBox.Image).SetPixel(points[i].X, points[i].Y, color[i]);
            //    }
            //}
            pictureBox.Refresh();
        }
        
    }
}

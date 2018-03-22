using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.Utility.Drawing
{
    class DrawCommonShape
    {
        public static void DrawPoint(System.Drawing.Graphics graphics,Color color, int x, int y)
        {
            DrawRectangle(graphics, new Pen(color,1), color, x, y, 1, 1);
        }

          public static void DrawRectangle(System.Drawing.Graphics graphics,Pen outline,Color fill,int x,int y,int width,int height)
          {
              System.Drawing.SolidBrush myBrush = new System.Drawing.SolidBrush(fill);
              System.Drawing.Rectangle rectangle = new System.Drawing.Rectangle(x, y, width, height);
              graphics.DrawRectangle(outline, rectangle);
              graphics.FillRectangle(myBrush, rectangle);
              myBrush.Dispose();
              graphics.Dispose();
          }
          public static void DrawEllipse(System.Drawing.Graphics graphics, Pen outline, Color fill, int x, int y, int width, int height)
        {
            System.Drawing.SolidBrush myBrush = new System.Drawing.SolidBrush(fill);
            //System.Drawing.Graphics graphics = (new Form()).CreateGraphics();
            System.Drawing.Rectangle rectangle = new System.Drawing.Rectangle(x,y,width,height);
            graphics.DrawEllipse(outline, rectangle);
            graphics.FillEllipse(myBrush, rectangle);
            myBrush.Dispose();
            graphics.Dispose();
        }

          public static void DrawLine(System.Drawing.Graphics graphics, Pen outline,Point startPoint, Point endPoint)
          {
              graphics.DrawLine(outline, startPoint.X, startPoint.Y, endPoint.X, endPoint.Y);
              outline.Dispose();
              graphics.Dispose();
          }

    }
}

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.Utility.Drawing
{
    class DrawBezierCurve
    {
        public static void drawBeziersPoint(PaintEventArgs e, Point[] bezierPoints, Color color)
        {
            //// Create points for curve.
            //Point start = new Point(100, 100);
            //Point control1 = new Point(200, 10);
            //Point control2 = new Point(350, 50);
            //Point end1 = new Point(500, 100);
            //Point control3 = new Point(600, 150);
            //Point control4 = new Point(650, 250);
            //Point end2 = new Point(500, 300);
            //Point[] bezierPoints =
            // {
            //     start, control1, control2, end1,
            //     control3, control4, end2
            // };
            // Create pen.
            Pen blackPen = new Pen(color, 3);
            // Draw arc to screen.
            e.Graphics.DrawBeziers(blackPen, bezierPoints);
        }
    }
}

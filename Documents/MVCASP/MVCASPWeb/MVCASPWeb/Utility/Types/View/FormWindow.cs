using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MVCASPWeb.Utility.Drawing;
using MVCASPWeb.IO.Byte;
using MVCASPWeb.Database;
using MVCASPWeb.Types;
using MVCASPWeb.AV.Audio;
namespace MVCASPWeb
{
   public  class FormWindow : Form
    {
 
        public FormWindow()
        {
            InitializeComponent();
    //Add Handler
            this.addEventListener();
          }

       public void addEventListener()
       {
           
     this.MouseDown += new MouseEventHandler(FormWindow_MouseDown);
     this.Paint += new PaintEventHandler(FormWindow_Paint);

        }
   
       
        public void btn_Clicked(object sender, EventArgs e)
        {
     

            //image to byteArray
            Image img = Image.FromFile("C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\Visualize\\MVCASPWeb\\Resource\\custom shape.bmp");
            //byte[] bArr = ImageByte.imageToByteArray(img);
            byte[] bArr = ImageByte.converterDemo(img);
            //byte[] bArr = imgToByteConverter(img);
            //Again convert byteArray to image and displayed in a picturebox
            Image img1 =  ImageByte.byteArrayToImage(bArr);

            ConnectDatabase.connectDatabase();
     


            DrawCommonShape.DrawPoint(this.CreateGraphics(),Color.Blue,100,100);
            //this.Paint += new PaintEventHandler(FormWindow_Paint);
            DrawCommonShape.DrawLine(this.CreateGraphics(),new Pen(Color.Black,5),new Point(100,100),new Point(500,200));
        }


        public void FormWindow_MouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
        {

            }

        public void FormWindow_MouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
        {

           
        }

        public void FormWindow_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
        {
            //e.Graphics.DrawRectangle(new Pen(Color.Blue, PenWidth), RcDraw);
            // Create points for curve.
            Point start = new Point(100, 100);
            Point control1 = new Point(200, 10);
            Point control2 = new Point(350, 50);
            Point end1 = new Point(500, 100);
            Point control3 = new Point(600, 150);
            Point control4 = new Point(650, 250);
            Point end2 = new Point(500, 300);
            Point[] bezierPoints =
             {
                 start, control1, control2, end1,
                 control3, control4, end2
             };
            //DrawBezierCurve.drawBeziersPoint(e,bezierPoints,Color.Black);
            ImageProcess.drawImage(e);

        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            // 
            // FormWindow
            // 
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Name = "FormWindow";
            this.Load += new System.EventHandler(this.FormWindow_Load);
            this.ResumeLayout(false);
       
            //MainWaveGenerator.btnGenerateWave_Click();
          
        }

   private void FormWindow_Load(object sender, EventArgs e)
        {

        }


    }
}

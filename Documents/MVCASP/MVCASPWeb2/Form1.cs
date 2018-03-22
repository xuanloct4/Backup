using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Sockets;
using System.IO;
using System.Runtime.InteropServices;
public class Win32
{
    [DllImport("User32.Dll")]
    public static extern long SetCursorPos(int x, int y);

    [DllImport("User32.Dll")]
    public static extern bool ClientToScreen(IntPtr hWnd, ref POINT point);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT
    {
        public int x;
        public int y;
    }
}

public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
    
        private void button1_Click(object sender, EventArgs e)
        {
        Win32.POINT p = new Win32.POINT();
        //p.x = Convert.ToInt16(txtMouseX.Text);
        //p.y = Convert.ToInt16(txtMouseY.Text);
        p.x = 100;
        p.y = 100;
        Win32.ClientToScreen(this.Handle, ref p);
        Win32.SetCursorPos(p.x, p.y);



        //// Set the Current cursor, move the cursor's Position,
        //// and set its clipping rectangle to the form. 
        //this.Cursor = new Cursor(Cursor.Current.Handle);
        //Cursor.Position = new Point(Cursor.Position.X - 50, Cursor.Position.Y - 50);
        //Cursor.Clip = new Rectangle(this.Location, this.Size);
    }
        private void button2_Click(object sender, EventArgs e)
        {
         
        }
    }

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.Types
{
    class ScrollView
    {

        public static void addScrollViewPanel(FormWindow form)
        {
            Panel panel = new Panel();
            panel.Location = new System.Drawing.Point(50, 10);
            panel.Name = "panel1";
            panel.Size = new System.Drawing.Size(800, 600);
            panel.HorizontalScroll.Visible = true;
            panel.VerticalScroll.Visible = true;
            panel.TabIndex = 3;
            panel.BackColor = Color.Green;
            panel.Paint += new System.Windows.Forms.PaintEventHandler(scroll_Paint);
            form.Controls.Add(panel);

           //// addControlsToScrollViewPanel
           // Label lab = new Label();
           // lab.Text = "dgg";
           // panel.Controls.Add(lab);
        }

      
     
     
        // Create the ValueChanged event handler.
        public static void scroll_Paint(Object sender,PaintEventArgs e)
        {
          
        }

    }
}

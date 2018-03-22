using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.Types
{
    class Picturebox
    {

        public static PictureBox createPictureBox(Form windowForm, Image img, Point location, Size size)
        {
            PictureBox pb = new PictureBox();
            pb.Size = size;  //I use this picturebox simply to debug and see if I can create a single picturebox, and that way I can tell if something goes wrong with my array of pictureboxes. Thus far however, neither are working.
            pb.BackgroundImage = img;
            pb.BackgroundImageLayout = ImageLayout.Stretch;
            pb.Location = location;
            pb.Anchor = AnchorStyles.Left;
            pb.Visible = true;
            windowForm.Controls.Add(pb);
            return pb;
        }
    }
}

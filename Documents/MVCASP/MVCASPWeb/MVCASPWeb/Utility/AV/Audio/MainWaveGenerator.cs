using System;
using System.Collections.Generic;
using System.Linq;
using System.Media;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MVCASPWeb.AV.Audio
{
 
      public partial class MainWaveGenerator :Form
      {
          private Button button1;
      
           public MainWaveGenerator()
        {

             InitializeComponent();
         }


          public void InitializeComponent()
          { 
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(76, 13);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // MainWaveGenerator
            // 
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.button1);
            this.Name = "MainWaveGenerator";
            this.ResumeLayout(false);

          }


          private void button1_Click_1(object sender, EventArgs e)
          {
              string filePath = @"D:\test2.wav";
              WaveGenerator wave = new WaveGenerator(WaveExampleType.ExampleSineWave);
              wave.Save(filePath);

              SoundPlayer player = new SoundPlayer(filePath);
              player.Play();
          }
    }
}

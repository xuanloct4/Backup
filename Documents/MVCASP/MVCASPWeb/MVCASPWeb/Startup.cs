using Microsoft.Owin;
using Owin;
using System;

using System.Dynamic;
using MVCASPWeb.Database;
using MVCASPWeb.AV.Audio;
using MVCASPWeb.IO.SerialPort;
using MVCASPWeb.Utility.PacketCapture;
[assembly: OwinStartupAttribute(typeof(MVCASPWeb.Startup))]
namespace MVCASPWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);

            //MVCASPWeb.Database.ConnectDatabase.select();
            //ExpandoObjectExample.ExpandoObjectTest();
            //System.CompileCSCAtRuntime.HelloWorld();

            //string filePath = @"D:\test2.wav";
            //WaveGenerator wave = new WaveGenerator(WaveExampleType.ExampleSineWave);
            //wave.Save(filePath);

            //SerialPortConstructor serial = new SerialPortConstructor();
            //serial.SerialPortSetup();
            System.CompileCSCAtRuntime.TestMeothds();
            //Sniffer.Test();
        }
    }
}

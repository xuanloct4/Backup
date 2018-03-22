using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.IO
{
    class IOPath
    {
        public static string getAbsPathOfResource(string resource)
        {
            string outPutDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase);
            string debugPath = Path.Combine(outPutDirectory, @"..\..\" + resource);
            string localPath = new Uri(debugPath).LocalPath;
            string currentDir = Environment.CurrentDirectory;
            DirectoryInfo directory = new DirectoryInfo(
                Path.GetFullPath(Path.Combine(currentDir, @"..\..\" + resource)));
            Directory.GetCurrentDirectory();
            string absolutePath = @"C:\\Users\\loctv.TOSHIBA-TSDV\\documents\\visual studio 2013\\Projects\\MVCASPWeb\\MVCASPWeb\\custom shape.bmp";
            int relativePathStartIndex = absolutePath.IndexOf("MVCASPWeb");
            string relativePath = absolutePath.Substring(relativePathStartIndex);
            return localPath;
        }

        private static string Combine(string outPutDirectory, string p)
        {
            throw new NotImplementedException();
        }
    }
}

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.IO.String
{
    class File_ToHex
    {
        public static byte[] readByteArrayFromFIle(string fileName)
        {
            //byte[] array = File.ReadAllBytes("C:\\a.txt");
            byte[] array = File.ReadAllBytes(fileName);
            return array;
        }

        public static byte[] ReadAllBytes(string fileName)
        {
            byte[] buffer = null;
            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
            {
                buffer = new byte[fs.Length];
                fs.Read(buffer, 0, (int)fs.Length);
            }
            return buffer;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


    public class ObjectToBuffer
    {
        public ObjectToBuffer()
        { 
        
        }

        public StringType createBuffer(StringType obj, StringType attribute)
        {
            StringType buffer = StringType.createBuffer(obj, attribute);
            return buffer;
        }

        public Object readBuffer(StringType buffer, StringType attribute)
        {
            StringType obj = StringType.createBuffer(buffer, attribute);
            return obj;
        }
    }

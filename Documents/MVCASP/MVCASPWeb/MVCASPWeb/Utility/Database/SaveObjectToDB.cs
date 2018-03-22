using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility.Database
{
    public class SaveObjectToDB
    {
       public StringType registeredKey;
        public SaveObjectToDB()
        {

        }
        public void saveClass()
        {
            saveProperties();
            saveMethod();
        }

        public void saveResource()
        {

        }

        public void saveObject()
        {
            saveProperties();
            saveMethod();
        }

        public void saveModel(Model model)
        {
            // StringType st = Deflate(Model model);
            // Save to DB
        }

        public void saveProperties()
        {
            //...
            if(true)
            {
            savePointer(null);
            }else{
            saveValue(null);
            }
            //...
        }

        public void saveMethod()
        {
            //...
            if(true)
            {
            savePointer(null);
            }else{
            saveValue(null);
            }
            //...

        }

        public void savePointer(object obj)
        {
            StringType pointer = registeredKeyForObject(obj);
            // Save key to DB
        }

        public object objectForRegisteredKey(StringType key)
        {
            return null;
        }

        public StringType registeredKeyForObject(object obj)
        {
            return new StringType();
        }

        public void saveValue(StringType str)
        {

        }

    }
}

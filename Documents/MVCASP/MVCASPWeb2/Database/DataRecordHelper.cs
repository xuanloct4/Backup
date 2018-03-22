using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace MVCASPWeb.Database
{
    public static class DataRecordHelper
    {
        public static void CreateRecord<T>(IDataRecord record, T myClass)
        {
            PropertyInfo[] propertyInfos = typeof(T).GetProperties();

            for (int i = 0; i < record.FieldCount; i++)
            {
                foreach (PropertyInfo propertyInfo in propertyInfos)
                {
                    if (propertyInfo.Name == record.GetName(i))
                    {
                        propertyInfo.SetValue(myClass, Convert.ChangeType(record.GetValue(i), record.GetFieldType(i)), null);
                        break;
                    }
                }
            }
        }

        public static void CreateRecord<T>(FormCollection form, T myClass)
        {
            PropertyInfo[] propertyInfos = typeof(T).GetProperties();

            foreach (PropertyInfo propertyInfo in propertyInfos)
            {
                for (int i = 0; i < form.AllKeys.Count(); i++)
                {
                    if (propertyInfo.Name == form.AllKeys.ElementAt(i))
                    {
                        System.Type type = propertyInfo.GetType();

                        object[] ob = (object[])form.GetValue(form.AllKeys.ElementAt(i)).RawValue;

                        object convrt = Convert.ChangeType(ob[0], propertyInfo.PropertyType);

                        propertyInfo.SetValue(myClass, convrt, null);
                        break;
                    }
                }
            }
        }
    }

}

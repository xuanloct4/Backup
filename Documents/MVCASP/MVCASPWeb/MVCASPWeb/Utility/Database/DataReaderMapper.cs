using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Database
{
    public class DataReaderMapper<T> where T : new()
    {
        Dictionary<int, PropertyInfo> mappings;

        public DataReaderMapper(IDataReader reader)
        {
            //this.mappings = Mappings(reader);
        }

    //    // int part is column indices (ordinals)
    //    static Dictionary<int, PropertyInfo> Mappings(IDataReader reader)
    //    {
    //        var columns = Enumerable.Range(0, reader.FieldCount);
    //        var properties = typeof(T)
    //                        .GetProperties()
    //                        .Select(prop => new
    //                        {
    //                            prop,
    //                            attr = prop.GetCustomAttributes(typeof(DbColumnAttribute)).FirstOrDefault()
    //                        })
    //                        .Select(x => new
    //                        {
    //                            name = x.attr == null ? x.prop.Name : ((DbColumnAttribute)x.attr).Name,
    //                            x.prop
    //                        });
    //        return columns.Join(properties, reader.GetName, x => x.name, (index, x) => new
    //              {
    //                  index,
    //                  prop = !x.prop.CanWrite ? null : x.prop
    //              }, StringComparer.InvariantCultureIgnoreCase)
    //             .Where(x => x.prop != null) // only settable properties accounted for
    //             .ToDictionary(x => x.index, x => x.prop);
    //    }

    //    public T MapFrom(IDataRecord record)
    //    {
    //        var element = new T();
    //        foreach (var map in mappings)
    //            map.Value.SetValue(element, ChangeType(record[map.Key], map.Value.PropertyType));

    //        return element;
    //    }

    //    static object ChangeType(object value, Type targetType)
    //    {
    //        if (value == null || value == DBNull.Value)
    //            return null;

    //        return Convert.ChangeType(value, Nullable.GetUnderlyingType(targetType) ?? targetType);
    //    }
      }
}

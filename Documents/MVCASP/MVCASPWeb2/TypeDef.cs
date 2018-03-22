using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using StringType = System.Collections.Generic.List<string>;
namespace MVCASPWeb
{
    //public class stringtype:list<chartype>
    public class StringType:Type
    {
        public StringType(string _entity)
        {
            entity = _entity;
        }
        public string entity;
    }

    public class CharType
    {
    
    }
    public class ModelUtilities
    {
        public StringType sample;
        public Model model;
        public DictionaryType realStructure;
    }


    public class KeyValueType
{
        public KeyType key;
        public ValueType value;
}

    public class ListType<T>:List<T>
    {
    
    }
    public class DictionaryType
    {
    public ListType<KeyValueType> record;
    }

    public class Type
    {
        public static Boolean areTypesSame(Type type1, Type type2)
        {
            return false;
        }
    }
    public enum Quantative : int {Zero=1 , One, Multi, ZeroOne, ZeroMulti, OneMulti };

    public class SubModel
    {
       public StringType entity;
       public Quantative occurences;
        //...
    }
    public class Model:SubModel
    {
        public List<Model> subModel;
        public Boolean areModelsSame(Model modl1, Model modl2)
        {
            int i;
            int model1Size = modl1.subModel.Count();
            int model2Size = modl2.subModel.Count();
            if (model1Size != model2Size)
            {
                return false;
            }
            else if ((model1Size == model2Size) && (model1Size == 0))
            {
                return true;
            }
            else {
                for (i = 0; i < model1Size; i++)
                {
                    Object suModeli1 = modl1.subModel.ElementAt(i);
                    Object suModeli2 = modl2.subModel.ElementAt(i);
                    if ((suModeli1.GetType() == typeof(StringType)) && (suModeli1.GetType() == typeof(StringType)))
                    {
                        if (!areEntitiesSame((StringType)suModeli1, (StringType)suModeli2))
                        {
                            return false;
                        }
                    }
                    else if ((suModeli1.GetType() == typeof(Model)) && (suModeli1.GetType() == typeof(Model)))
                    {
                        if (!areModelsSame((Model)suModeli1, (Model)suModeli2))
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public Boolean areEntitiesSame(StringType entity1, StringType entity2)
        {
            return false;
        }
    }


}

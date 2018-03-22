using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using StringType = System.Collections.Generic.List<string>;

//public class stringtype:list<chartype>
public class StringType : Model
{
    public String entity;
    public StringType()
    {
        entity = "";
    }
    public StringType(string _entity)
    {
        entity = _entity;
    }

    public static StringType createBuffer(StringType obj, StringType attribute)
    {
        StringType buffer = new StringType();

        StringType startNode = new StringType();
        startNode = StringType.stringByAppend(startNode, new StringType("<"));
        startNode = StringType.stringByAppend(startNode, attribute);
        startNode = StringType.stringByAppend(startNode, new StringType(">"));

        StringType endNode = new StringType();
        endNode = StringType.stringByAppend(endNode, new StringType("</"));
        endNode = StringType.stringByAppend(endNode, attribute);
        endNode = StringType.stringByAppend(endNode, new StringType(">"));

        buffer = StringType.stringByAppend(buffer, startNode);
        buffer = StringType.stringByAppend(buffer, obj);
        buffer = StringType.stringByAppend(buffer, endNode);

        return buffer;
    }

    public static StringType readBuffer(StringType buffer, StringType attribute)
    {
        StringType obj = new StringType();
        StringType startNode = new StringType();
        startNode = StringType.stringByAppend(startNode, new StringType("<"));
        startNode = StringType.stringByAppend(startNode, attribute);
        startNode = StringType.stringByAppend(startNode, new StringType(">"));

        int fromIndex = StringType.readUntilMeetSubString(buffer,startNode);
        buffer = StringType.subStringToIndex(buffer, fromIndex);

        StringType endNode = new StringType();
        endNode = StringType.stringByAppend(endNode, new StringType("</"));
        endNode = StringType.stringByAppend(endNode, attribute);
        endNode = StringType.stringByAppend(endNode, new StringType(">"));

        int toIndex = StringType.readUntilMeetSubString(buffer, endNode);
        obj = StringType.subStringToIndex(buffer, toIndex);

        buffer = StringType.subStringToIndex(buffer, toIndex);
        buffer = StringType.subStringToIndex(buffer, endNode.entity.Length);
        return obj;
    }

    public static int stringToInt(StringType obj)
    {
        int quantity = Int32.Parse(obj.entity);
        return quantity;
    }

    public static int readUntilMeetSubString(StringType originalString, StringType subString)
    {
        Boolean isMeet = false;
        if ((originalString == null) || (subString == null))
        {
            return -1;
        }

        int diffLength = originalString.entity.Length - subString.entity.Length;

        for (int i = 0; i <= diffLength; i++)
        {
            StringType sub = subStringFromIndex(originalString, i, subString.entity.Length);
            if (isStringsEqual(sub, subString))
            {
                if (isMeet)
                {
                    return i;
                }
            }
        }
        return -1;
    }

    public static Boolean isStringsEqual(StringType originalString, StringType comparedString)
    {
        if ((originalString == null) && (comparedString == null))
        {
            return true;
        }
        else if (((originalString == null) && (comparedString != null)) || ((originalString != null) && (comparedString == null)))
        {
            return false;
        }
        else
        {
            return (Boolean)originalString.entity.Equals(comparedString.entity, StringComparison.OrdinalIgnoreCase);
        }
    }
    public static StringType subStringFromIndex(StringType originalString, int fromIndex, int length)
    {
        if (originalString == null)
        {
            return new StringType("");
        }

        if ((fromIndex < 0) || (length < 0) || (length + fromIndex > originalString.entity.Length))
        {
            return new StringType("");
        }
        return new StringType(originalString.entity.Substring(fromIndex, length));
    }

    public static StringType subStringToIndex(StringType originalString, int toIndex)
    {
        if (originalString == null)
        {
            return new StringType("");
        }

        if ((toIndex < 0) || (toIndex > originalString.entity.Length))
        {
            return new StringType("");
        }
        return new StringType(originalString.entity.Substring(0, toIndex));
    }
    public static StringType subStringFromToIndex(StringType originalString, int fromIndex, int toIndex)
    {
        if (originalString == null)
        {
            return new StringType("");
        }

        if ((toIndex <= fromIndex) || (toIndex < originalString.entity.Length))
        {
            return new StringType("");
        }
        return new StringType(originalString.entity.Substring(fromIndex, toIndex - fromIndex));
    }

    public static StringType stringByAppend(StringType origString, StringType appendString)
    {
        return new StringType(origString.entity + appendString.entity);
    }
    public static StringType stringByPrepend(StringType origString, StringType prependString)
    {
        return new StringType(prependString.entity + origString.entity);
    }

    public static Boolean headStringContainSubstring(StringType headString, StringType subString)
    {
        int subStringLength = subString.entity.Length;
        if (subStringLength == 0)
        {
            return true;
        }
        string sub = headString.entity.Substring(0, subStringLength);
        if (sub == null)
        {
            return false;
        }
        if (sub.Equals(subString.entity))
        {
            return true;
        }
        return false;
    }

    public static StringType stringByCutHeadString(StringType originalString, StringType headSubString)
    {
        int subStringLength = headSubString.entity.Length;
        int originalStringLength = originalString.entity.Length;
        if (subStringLength > originalStringLength)
        {
            return null;
        }
        string sub = originalString.entity.Substring(subStringLength, originalStringLength);
        return new StringType(sub);
    }

    public static StringType stringByCutTailString(StringType originalString, StringType tailSubString)
    {
        int subStringLength = tailSubString.entity.Length;
        int originalStringLength = originalString.entity.Length;
        if (subStringLength > originalStringLength)
        {
            return null;
        }
        string sub = originalString.entity.Substring(0, originalStringLength - subStringLength);
        return new StringType(sub);
    }


    public static StringType clonedString(StringType origin)
    {
        if (origin == null)
        {
            return null;
        }
        StringType clonedString = new StringType();
        //   //Method1
        //clonedString.entity = (string)origin.entity.Clone();

        //Method2
        int originLength = origin.entity.Length;
        if (originLength == 0)
        {
            clonedString.entity = "";
        }
        else
        {
            char[] destination = new char[originLength];
            origin.entity.CopyTo(0, destination, 0, originLength);
            clonedString.entity = new string(destination);
        }
        return clonedString;
    }

    public static Boolean areStringSame(StringType str1, StringType str2)
    {
        if ((str1 == null) && (str2 != null))
        {
            if (str2.entity.Length == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else if ((str1 != null) && (str2 == null))
        {
            if (str1.entity.Length == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else if ((str1 == null) && (str2 == null))
        {
            return true;
        }
        return str1.entity.Equals(str2.entity, StringComparison.Ordinal);
    }
}


public class CharType
{
    public CharType()
    {

    }
}
public class ModelUtilities
{
    public StringType sample;
    public Model model;
    public DictionaryType realStructure;


}

//public class KeyType:StringType
public class KeyType
{

}

//public class ValueType: StringType
public class ValueType
{

}
public class KeyValueType
{
    public KeyType key;
    public ValueType value;
}

public class ListType<T> : List<T>
{

}
public class DictionaryType
{
    public ListType<KeyValueType> record;
}

//public class Type
//{
//    public static Boolean areTypesSame(Type type1, Type type2)
//    {
//        return false;
//    }
//}
public class Quantative : ObjectToBuffer
{
    private static Quantative quantative = null;

    public const int Zero = 0;
    public const int One = 1;
    public const int Multi = 2;
    public const int ZeroOne = 3;
    public const int ZeroMulti = 4;
    public const int OneMulti = 5;

    //public override StringType createBuffer(StringType obj)
    //{
    //    StringType buffer = base.createBuffer(obj);
    //    return buffer;
    //}

    public static StringType toString(int quantity)
    {
        StringType str = new StringType(quantity.ToString());
        return str;
    }

    public static Quantative getInstance()
    {
        if (quantative == null)
        {
            quantative = new Quantative();
        }
        return quantative;
    }

}

public class SubModel : ObjectToBuffer
{
    //public StringType entity;
    // public Quantative occurences;
    //...
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

public class OptionalDesc : ObjectToBuffer
{
    public int quantity;
    public ConstraintOnModel constrs;
    public Tag tag;
    public int storeOption;
    public StringType name;
    public OptionalDesc()
    {

    }

    public StringType createBuffer(StringType obj, StringType attribute)
    {
        OptionalDesc description = new OptionalDesc();

        // For Quantity
        StringType _quantity = StringType.createBuffer(Quantative.toString(this.quantity), new StringType("Quantity"));
        obj = StringType.stringByAppend(obj, _quantity);

        // For Constrains
        StringType _constrs = this.constrs.createBuffer(ConstraintOnModel.toString(constrs), new StringType("Constraints"));
        obj = StringType.stringByAppend(obj, _constrs);

        // For Tag
        StringType _tag = StringType.createBuffer(tag, new StringType("Tag"));
        obj = StringType.stringByAppend(obj, _tag);

        // For StoreOption
        StringType _storeOption = StringType.createBuffer(StoreOptional.toString(storeOption), new StringType("StoreOption"));
        obj = StringType.stringByAppend(obj, _storeOption);

        // For Name
        StringType _name = StringType.createBuffer(name, new StringType("Name"));
        obj = StringType.stringByAppend(obj, _name);

        obj = base.createBuffer(obj, attribute);
        return obj;
    }

    public static Object readBuffer(StringType buffer, StringType attribute)
    {
        OptionalDesc _description = new OptionalDesc();

        // For Quantity
        StringType _quantity = (StringType)StringType.readBuffer(buffer, new StringType("Quantity"));
        _description.quantity = StringType.stringToInt(_quantity);

        // For Constrains
        ConstraintOnModel _constrs = (ConstraintOnModel)ConstraintOnModel.readBuffer(buffer, new StringType("Constraints"));
        _description.constrs = _constrs;

        // For Tag
        StringType _tag = (StringType)StringType.readBuffer(buffer, new StringType("Tag"));
        _description.tag = (Tag)_tag;

        // For StoreOption
        StringType _storeOption = StringType.createBuffer(buffer, new StringType("StoreOption"));
        _description.storeOption = StringType.stringToInt(_storeOption);

        // For Name
        StringType _name = (StringType)StringType.readBuffer(buffer, new StringType("Name"));
        _description.name = StringType.stringByAppend(buffer, _storeOption);

        return _description;
    }

    public static OptionalDesc clonedDescription(OptionalDesc origin)
    {
        if (origin == null)
        {
            return null;
        }

        OptionalDesc clonedDesc = new OptionalDesc();
        clonedDesc.quantity = origin.quantity;

        //clone ConstraintOnModel
        clonedDesc.constrs = ConstraintOnModel.clonedConstraints(origin.constrs);

        //clone Tag
        clonedDesc.tag = (Tag)StringType.clonedString(origin.tag);

        clonedDesc.storeOption = origin.storeOption;

        //clone Name
        clonedDesc.name = StringType.clonedString(origin.name);

        return clonedDesc;
    }

    public static Boolean areDescriptionSame(OptionalDesc _desc1, OptionalDesc _desc2)
    {
        bool result = true;
        if (_desc1.quantity != _desc2.quantity)
        {
            result = false;
        }

        if (_desc1.storeOption != _desc2.storeOption)
        {
            result = false;
        }

        if (!StringType.areStringSame(_desc1.tag, _desc2.tag))
        {
            result = false;
        }

        if (!StringType.areStringSame(_desc1.name, _desc2.name))
        {
            result = false;
        }

        if (!ConstraintOnModel.areSameConstraints(_desc1.constrs, _desc2.constrs))
        {
            result = false;
        }

        return result;
    }
}

public class MDescription
{

}

public class Tag : StringType
{
    public Tag()
    {

    }


    public List<StringType> splitStringByDelimiter(StringType _delimiter, StringType _string)
    {
        List<StringType> compList = new List<StringType>();


        //char[] delimiterChars = { ' ', ',', '.', ':', '\t' };
        //string text = "one\ttwo three:four,five six seven";
        //System.Console.WriteLine("Original text: '{0}'", text);
        //string[] words = text.Split(delimiterChars);

        string[] subIndex = Regex.Split(_string.entity, _delimiter.entity);

        if (subIndex.Count() > 0)
        {
            for (int i = 0; i < subIndex.Count(); i++)
            {
                StringType subTag = new StringType();
                subTag.entity = subIndex[i];
                compList.Add(subTag);
            }
        }

        return compList;
    }
    public int lastTagIndex(Tag tag)
    {
        int m = -99999;
        try
        {
            StringType _delimiter = new StringType();
            _delimiter.entity = ".";
            List<StringType> compList = splitStringByDelimiter(_delimiter, tag);
            if (compList.Count() > 0)
            {
                m = Int32.Parse(compList.Last().entity);
            }
        }
        catch (FormatException e)
        {
            Console.WriteLine(e.Message);
        }
        return m;
    }

    public int firststTagIndex(Tag tag)
    {
        int m = -99999;
        try
        {
            StringType _delimiter = new StringType();
            _delimiter.entity = ".";
            List<StringType> compList = splitStringByDelimiter(_delimiter, tag);
            if (compList.Count() > 0)
            {
                m = Int32.Parse(compList.First().entity);
            }
        }
        catch (FormatException e)
        {
            Console.WriteLine(e.Message);
        }
        return m;
    }

    public static Tag tagByAppend(int index, Tag tag)
    {
        Tag appendedTag = new Tag();
        appendedTag.entity = tag.entity + "." + index.ToString();
        return appendedTag;
    }
    public static Tag tagByPrepend(int index, Tag tag)
    {
        Tag prependedTag = new Tag();
        prependedTag.entity = index.ToString() + "." + tag.entity;
        return prependedTag;
    }
}

public class StoreOptional : ObjectToBuffer
{
    public int Disard = 0;
    public int Keep = 1;
    public static StringType toString(int _store)
    {
        StringType str = new StringType(_store.ToString());
        return str;
    }
}


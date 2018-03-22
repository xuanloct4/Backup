using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

    public class CloneModel
    {
    //Clone OptionalDesc
    public static OptionalDesc cloneOptionalDescription(OptionalDesc _desc)
    {
        OptionalDesc descCloned = new OptionalDesc();
        //Clone properties of OptionalDesc
        return descCloned;
    }

    //Clone StringType
    public static StringType cloneString(StringType _string)
    {
        if (_string == null)
        {
            return null;
        }
        StringType stringCloned = new StringType();
        int stringSize = _string.entity.Length;
        char[] destination = new char[stringSize];
        _string.entity.CopyTo(0, destination, 0, stringSize);
        String copiedSring = new String(destination);
        stringCloned.entity = copiedSring;
        return stringCloned;
    }

    //Clone ConstraintOnModel

    //Clone Tag
    public static Tag cloneTag(Tag tag)
    {
       // Tag tagCloned = new Tag();
        Tag tagCloned = (Tag)CloneModel.cloneString(tag);
        return tagCloned;
    }
    //Clone StoreOptional

    //Clone Quantative

    //Clone Model/SubModel
    public static Model cloneModel(Model _model)
    {
        Model modelCloned = new Model(new OptionalDesc(),new List<Model>());
        //Clone OptionalDescription
        modelCloned.description = OptionalDesc.clonedDescription(_model.description);

        //Clone ConstraintOnModel
   

        //Clone Tag
        if (_model.description.tag != null)
        {
            modelCloned.description.tag = (Tag)CloneModel.cloneString(_model.description.tag);
        }

        //Clone Name
        if (_model.description.name != null)
        {
            modelCloned.description.name = CloneModel.cloneString(_model.description.name);
        }
        //CLone ... others

        //Clone receivedString
        if (_model.receivedString != null)
        {
            modelCloned.receivedString = CloneModel.cloneString(_model.receivedString);
        }
        //Clone returnedString;
        if (_model.returnString != null)
        {
            modelCloned.returnString = CloneModel.cloneString(_model.returnString);
        }
            //Clone subModel list
            if (_model.subModel == null)
        {
            return modelCloned;
        }
        int subModelSize = _model.subModel.Count;
        if(subModelSize == 0)
        {
            modelCloned.subModel = new List<Model>();
        }
        else if(subModelSize > 0){
            for (int i = 0; i < subModelSize; i++)
            {
                if (_model.subModel.ElementAt(i).GetType() == typeof(StringType))
                {
                    modelCloned.subModel.Add(CloneModel.cloneString((StringType)_model.subModel.ElementAt(i)));
                }
                else {
                    modelCloned.subModel.Add(CloneModel.cloneModel((Model)_model.subModel.ElementAt(i)));
                }
            }
        }

        return modelCloned;
    }
}


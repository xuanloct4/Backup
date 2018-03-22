using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class Model : SubModel
{
    public OptionalDesc description;
    public StringType returnString;
    public StringType receivedString;
    public List<Model> subModel;

    public Model()
    {

    }

    public StringType createBuffer(StringType obj, StringType attribute)
    {
        // For Description
        StringType _description = this.description.createBuffer(obj, new StringType("OptionalDescription"));
        obj = StringType.stringByAppend(obj, _description);

        // For ReceivedString
        StringType _receivedString = StringType.createBuffer(receivedString, new StringType("ReceivedString"));
        obj = StringType.stringByAppend(obj, _receivedString);

        // For sub models
        StringType _subModel = createSubModelBuffer(this.subModel, new StringType("SubModels"));
        obj = StringType.stringByAppend(obj, _subModel);

        obj = base.createBuffer(obj, attribute);
        return obj;
    }

    public static Object readBuffer(StringType buffer, StringType attribute)
    {
        Model _model = new Model();
        _model.description = (OptionalDesc)OptionalDesc.readBuffer(buffer, new StringType("OptionalDescription"));
        _model.receivedString = StringType.readBuffer(buffer, new StringType("ReceivedString"));
        _model.subModel = readSubModelBuffer(buffer, new StringType("SubModels"));
        return _model;
    }


    public static List<Model> readSubModelBuffer(StringType buffer, StringType attribute)
    {
        // Initialize
        List<Model> _subModels = new List<Model>();

        buffer = StringType.readBuffer(buffer, attribute);

        while(buffer.entity.Length > 0)
        {
            _subModels.Add((Model)Model.readBuffer(buffer, new StringType("Model")));
        }

        return _subModels;
    }
    public StringType createSubModelBuffer(List<Model> _subModel, StringType attribute)
    {
        // Initialize
        StringType buffer = new StringType();
        if ((_subModel != null) && (_subModel.Count > 0))
        {
            for (int i = 0; i < _subModel.Count; i++)
            {
                Model sub = _subModel.ElementAt(i);
                buffer = StringType.stringByAppend(buffer, sub.createBuffer(buffer, new StringType("Model")));
            }
        }
        buffer = base.createBuffer(buffer, attribute);
        return buffer;
    }



    public Model(OptionalDesc _description)
    {
        description = _description;
    }

    public Model(List<Model> _subModel)
    {
        subModel = _subModel;
    }

    public Model(OptionalDesc _description, List<Model> _subModel)
    {
        description = _description;
        subModel = _subModel;
    }
    public static void getReceivedString(Model _model)
    {
        int subModelCount = _model.subModel.Count;

        for (int i = 0; i < subModelCount; i++)
        {
            Model subModel = _model.subModel.ElementAt(i);
            _model.receivedString = StringType.stringByAppend(_model.receivedString, subModel.receivedString);
        }
    }



    public static void setTagForSubModel(Model _model)
    {
        if (_model.subModel == null)
        {
            return;
        }
        int subModelCount = _model.subModel.Count;
        if (_model.description.tag == null)
        {
            for (int i = 0; i < subModelCount; i++)
            {
                Model subModel = _model.subModel.ElementAt(i);
                Tag tag = new Tag();
                tag.entity = i.ToString();
                subModel.description.tag = tag;
            }
        }
        else
        {
            for (int i = 0; i < subModelCount; i++)
            {
                Model subModel = _model.subModel.ElementAt(i);
                Tag tag = _model.description.tag;
                subModel.description.tag = Tag.tagByAppend(i, tag);
            }
        }
    }


    public static Model cloneModel(Model origin)
    {
        if (origin == null)
        {
            return null;
        }

        Model clonedModel = new Model();

        //clone OptionalDesc
        clonedModel.description = OptionalDesc.clonedDescription(origin.description);

        //clone returnedString 
        clonedModel.returnString = StringType.clonedString(origin.returnString);

        //clone receivedString
        clonedModel.receivedString = StringType.clonedString(origin.receivedString);

        //clone subModels
        if (origin.subModel != null)
        {
            clonedModel.subModel = new List<Model>();
            for (int i = 0; i < origin.subModel.Count; i++)
            {
                Object _subMod = origin.subModel.ElementAt(i);
                if (_subMod.GetType() == typeof(StringType))
                {
                    clonedModel.subModel.Add(StringType.clonedString((StringType)_subMod));
                }
                else if (_subMod.GetType() == typeof(Model))
                {
                    clonedModel.subModel.Add(Model.cloneModel((Model)_subMod));
                }
            }
        }
        return clonedModel;
    }
    public static Boolean areModelsSame(Model modl1, Model modl2)
    {
        //Compare OptionalDesc
        if (!OptionalDesc.areDescriptionSame(modl1.description, modl2.description))
        {
            return false;
        }

        //Compare receivedString
        if (!StringType.areStringSame(modl1.receivedString, modl2.receivedString))
        {
            return false;
        }

        //Compare returnedString
        if (!StringType.areStringSame(modl1.returnString, modl2.returnString))
        {
            return false;
        }

        if (((modl1.subModel == null) && (modl2.subModel != null)) || ((modl2.subModel == null) && (modl1.subModel != null)))
        {
            if (((modl2.subModel != null) && (modl2.subModel.Count == 0)) || ((modl1.subModel != null) && (modl1.subModel.Count == 0)))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else if ((modl1.subModel == null) && (modl2.subModel == null))
        {
            return true;
        }
        else
        {
            int model1Size = modl1.subModel.Count();
            int model2Size = modl2.subModel.Count();
            if (model1Size != model2Size)
            {
                return false;
            }
            //else if ((model1Size == model2Size) && (model1Size == 0))
            //{
            //    return true;
            //}
            //else
            //{
            for (int i = 0; i < model1Size; i++)
            {
                Object suModeli1 = modl1.subModel.ElementAt(i);
                Object suModeli2 = modl2.subModel.ElementAt(i);
                if ((suModeli1.GetType() == typeof(StringType)) && (suModeli1.GetType() == typeof(StringType)))
                {
                    if (!StringType.areStringSame((StringType)suModeli1, (StringType)suModeli2))
                    {
                        return false;
                    }
                }
                else if (((suModeli1.GetType() == typeof(StringType)) && (suModeli2.GetType() != typeof(StringType))) || ((suModeli1.GetType() != typeof(StringType)) && (suModeli2.GetType() == typeof(StringType))))
                {
                    return false;
                }
                // else if ((suModeli1.GetType() != typeof(StringType)) && (suModeli2.GetType() != typeof(StringType)))
                else
                {
                    if (!areModelsSame((Model)suModeli1, (Model)suModeli2))
                    {
                        return false;
                    }
                }
            }
            //}
        }
        return true;
    }

    public int findFirstPosOfEntityInSample(StringType sample, StringType entity)
    {
        return findFirstPosOfEntityInSampleFromOffSet(sample, entity, 0);
    }
    public int findFirstPosOfEntityInSampleFromOffSet(StringType sample, StringType entity, int offSet)
    {
        string subSample = sample.entity.Substring(offSet, sample.entity.Length);
        return subSample.IndexOf(entity.entity);
    }
    public int findFirstPosOfEntityInSampleToOffSet(StringType sample, StringType entity, int offSet)
    {
        string subSample = sample.entity.Substring(0, offSet);
        return subSample.IndexOf(entity.entity);
    }

    public List<int> findAllPosOfEntityInSampleFromOffSet(StringType sample, StringType entity, int offSet)
    {
        List<int> pos = new List<int>();
        for (int i = offSet; i < (sample.entity.Length - entity.entity.Length + 1); i++)
        {
            string subSample = sample.entity.Substring(i, entity.entity.Length);
            bool result = entity.entity.Equals(subSample, StringComparison.Ordinal);
            if (result)
            {
                pos.Add(i);
            }
        }
        return pos;
    }

    public List<int> findAllPosOfEntityInSampleToOffSet(StringType sample, StringType entity, int offSet)
    {
        List<int> pos = new List<int>();
        for (int i = 0; i < (offSet - entity.entity.Length + 1); i++)
        {
            string subSample = sample.entity.Substring(i, entity.entity.Length);
            bool result = entity.entity.Equals(subSample, StringComparison.Ordinal);
            if (result)
            {
                pos.Add(i);
            }
        }
        return pos;
    }

    public List<int> findAllPosOfEntityInSampleFromOffSetToOffSet(StringType sample, StringType entity, int fromOffSet, int toOffSet)
    {
        List<int> pos = new List<int>();
        for (int i = fromOffSet; i < (toOffSet - entity.entity.Length + 1); i++)
        {
            string subSample = sample.entity.Substring(i, entity.entity.Length);
            bool result = entity.entity.Equals(subSample, StringComparison.Ordinal);
            if (result)
            {
                pos.Add(i);
            }
        }
        return pos;
    }

    public static void modelByDeleteSubModel(Model _model, Model _subModel)
    {
        //Delete subModel
        //Re-Tag
    }

    public static void modelByAddSubModel(Model _model, Model _subModel)
    {
        //Add subModel
        //Re-Tag
    }
    public void extractSampleToModel(StringType sample, Model _model)
    {

    }
}

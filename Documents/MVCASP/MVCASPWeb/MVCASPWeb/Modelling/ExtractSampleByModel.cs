using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class ExtractSampleByModel
{
    public Model model;
    public StringType sample;

    public static Boolean extractForModel(Model _model, StringType _sample)
    {
        Boolean isSubModelContained = true;

        //Iterate over all sub model
        int subModelCount = _model.subModel.Count;
        if (subModelCount == 0)
        {
            return true;
        }
        for (int i = 0; i < subModelCount; i++)
        {
            Model subModel = _model.subModel.ElementAt(i);
            //if have constr 
            //hande it before
            if (subModel.description.constrs != null)
            {
                handleConstraintOnModel(_model, _sample);
            }

            //handleQuantative
            int quantity = subModel.description.quantity;
            Boolean isFound = handleDescriptionOnModel(subModel, _sample, quantity);
            if (!isFound)
            {
                isSubModelContained = false;
            }

        }

        return isSubModelContained;
    }



    public static Boolean extractStringModel(Model _model, StringType _sample)
    {
        Boolean isHeadContainString = StringType.headStringContainSubstring(_sample, (StringType)_model);
        if (isHeadContainString)
        {
            //Remove each character from the head
            //ad compare extractStringModel(Model _model, StringType subsample)
            _model.receivedString = (StringType)_model;
            _sample = StringType.stringByCutHeadString(_sample, (StringType)_model);
            _model.returnString = _sample;
            return true;
        }
        else
        {
            return false;
        }
    }

    public static void handleConstraintOnModel(Model _model, StringType _sample)
    {
        if (_model.description.constrs == null)
        {

        }
        else
        {
            //Modify sample
            //Re-extract from model tag... 

        }
    }

    public static Boolean handleDescriptionOnModel(Model _model, StringType _sample, int _quantity)
    {
        StringType _clonedSample = StringType.clonedString(_sample);
        Model _clonedModel = Model.cloneModel(_model);

        switch (_quantity)
        {
            case Quantative.Zero:
                {
                    if (!isFoundEntity(_clonedModel, _clonedSample))
                    {
                        return true;
                    }
                    else {
                        return false;
                    }
                    //break;
                }
            case Quantative.One:
                {
                    if (isFoundEntity(_clonedModel, _clonedSample))
                    {
                        Boolean isFound = isFoundEntity(_clonedModel, _clonedSample);
                      if (!isFound)
                      {
               isFoundEntity(_model, _sample);
                          return true;
                      }
                      else
                      {
                          return false;
                      }
                    }
                    else
                    {
                        return false;
                    }
                    //break;
                }
            case Quantative.Multi:
                {

                    break;
                }
            case Quantative.ZeroOne:
                {
                    if (!isFoundEntity(_clonedModel, _clonedSample))
                    {
                        return true;
                    }
                    else
                    {
                        Boolean isFound = isFoundEntity(_clonedModel, _clonedSample);
                        if (!isFound)
                        {
                            isFoundEntity(_model, _sample);
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    //break;
                }
            case Quantative.ZeroMulti:
                {
                    Boolean isFound = isFoundEntity(_clonedModel, _clonedSample);
                    if(isFound)
                    {
                        isFoundEntity(_model, _sample);
                        handleDescriptionOnModel(_model, _sample, Quantative.ZeroMulti); 
                    }
                    return true;
                    //break;
                }
            case Quantative.OneMulti:
                {
                    Boolean isFound = isFoundEntity(_clonedModel, _clonedSample);
                    if (isFound)
                    {
                       isFoundEntity(_model, _sample);
                       handleDescriptionOnModel(_model, _sample, Quantative.ZeroMulti);
                       return true;
                    }
                    else {
                        return false;
                    }
                    //break;
                }
            //...
            default:
                {
                    return true;
                    //break;
                }
        }
        return true;

    }

    public static Boolean isFoundEntity(Model _subModel, StringType _sample)
    {
        //if sub model is contains submodel -> iterate
        //else compare string
        if ((_subModel.subModel != null) && (_subModel.subModel.Count > 0))
        {
            if (extractForModel(_subModel, _sample))
            {
                return true;
            }
            else
            {
                //_model.subModel.RemoveAt(i);
                return false;
            }
        }
        else
        {
            if (extractStringModel(_subModel, _sample))
            {
                return true;
            }
            else
            {
                //_model.subModel.RemoveAt(i);
                return false;
            }
        }
    }


}

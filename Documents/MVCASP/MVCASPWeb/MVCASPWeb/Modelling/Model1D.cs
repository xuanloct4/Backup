using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
    public class Model1D:Model
    {
        public Model1D(OptionalDesc _description):base(_description)
        {
            base.description = _description;
        }

        public void addSubModel(Model _subModel)
        {
            subModel.Add(_subModel);
         
        }

        public void insertSubModelAtIndex(Model _subModel, int _index)
        {
            subModel.Insert(_index, _subModel);
        }

        public static Model objectAtIndex(Model _subModel, int _index)
        {
            return _subModel.subModel.ElementAt(_index);
        }
        public Boolean removeSubModelAtIndex(int index)
        {
            if (objectAtIndex(this, index) != null)
            {
                subModel.RemoveAt(index);
                return true;
            }
            return false;
        }
      //  public Model prepareSubModel(StringType obj, Quantative quantative)
      //  {
      //  Model _model = new Model(new OptionalDesc());
      //  _model.entity = obj;
      ////  _model.occurences = quantative;
      //  return _model;
      //  }

        //public int findFirstOccurenceSubModelOnSample(Model _subModel, StringType _sample)
        //{
        //    return _subModel.entity.entity.IndexOf(_sample.entity);
        //}
        public void prepareModel()
        { 
        
        }
    }

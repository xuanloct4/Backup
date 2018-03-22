using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb
{
    public class Model1D:Model
    {
        public Model1D()
        {
        
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
        public Model prepareSubModel(StringType obj, Quantative quantative)
        {
        Model _model = new Model();
        _model.entity = obj;
        _model.occurences = quantative;
        return _model;
        }

        public int findFirstOccurenceSubModelOnSample(Model _subModel, StringType _sample)
        {
            return _subModel.entity.entity.IndexOf(_sample.entity);
        }
        public void prepareModel()
        { 
        
        }


    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

    //Model -> array/list
    public class SaveModelToBuffer
    {
        //Algorithm

        // Avoid repeating to save idetified objects
        // Save OPtialDesc , returnedStrig, recievedStrig of model firstly
        // the, save only submodels that is StrigType(etity) of Model
        // because the submodels that is refered to aother, can be saved in different locatio and use tag to refer to
        public static StringType saveModelToBuffer(Model _model)
        {
            return _model.createBuffer(new StringType(), new StringType("Model"));
        }

        public static void readModelFromBuffer()
        {

        }
    }

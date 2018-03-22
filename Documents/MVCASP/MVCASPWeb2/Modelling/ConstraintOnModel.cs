using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

  public class ConstraintOnModel:ObjectToBuffer
    {

 
    public ConstraintOnModel()
    {

    }

    public static Boolean areSameConstraints(ConstraintOnModel _constr1, ConstraintOnModel _constr2)
    {
        bool result = true;
        return result;
    }
    public static ConstraintOnModel clonedConstraints(ConstraintOnModel origin)
    {
        ConstraintOnModel clonedConstr = new ConstraintOnModel();

        return clonedConstr;
    }


    public static Object readBuffer(StringType buffer, StringType attribute)
    {
       //buffer = base.createBuffer(buffer, attribute);
        return null;
    }
    public static StringType toString(ConstraintOnModel _constr)
    {
        StringType str = new StringType();
        return str;
    }
}

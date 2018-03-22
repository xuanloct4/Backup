using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Simulating
{

    public interface IStandard
    {
         Boolean isPassStandard(CustomTuple result);

         CustomTuple specifyStandard(CustomTuple everStandards);
    }
    public class Standard:IStandard
    {
        public CustomTuple standards;
        public Standard()
        {
            standards = new CustomTuple();
        }

        public CustomTuple specifyStandard(CustomTuple everStandards)
        {
            return new CustomTuple();
        }

        public Boolean isPassStandard(CustomTuple result)
        {
            return true;
        }
    }
}

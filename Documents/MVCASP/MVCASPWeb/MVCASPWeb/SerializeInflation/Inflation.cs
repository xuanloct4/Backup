using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility
{
    public class Inflation
    {
        public List<StringType> delimiters;
        public List<KeyValueType> flattenedObject;
        public Inflation()
        {


        }

        public void startRead(StringType str)
        {
            StringType delimiter = meetDelimiter(str);
            if (delimiter != null)
            {
                if (objectShouldDecideScope(str))
                {
                    decideActionForNextStep(str);
                }
            }
            else
            {
                endRead(str);
            }

        }

        public Boolean objectShouldDecideScope(StringType str)
        {
            return false;
        }

        public Boolean objectShouldDecideStructure(StringType str)
        {
            return false;
        }

        public Boolean objectShouldCollectData(StringType str)
        {
            return false;
        }


        public Boolean isReferenToObject(StringType str)
        {
            return false;
        }
      

        public Boolean endRead(StringType str)
        {
            return true;
        }

        public Boolean actionFromCollectedData()
        {
            return false;
        }

        public Boolean actionFromRelations()
        {
            return false;
        }

        public Boolean actionFromTopo()
        {
          return actionFromRelations();
        }

        public void decideActionForNextStep(StringType str)
        {
            if (isReferenToObject(str))
            {
            } else
            {
                if (objectShouldDecideStructure(str))
                {
                    if (objectShouldCollectData(str))
                    {

                    }
                }
            }
        }

        public StringType meetDelimiter(StringType str)
        {
            foreach (StringType delimiter in delimiters)
            {
                if (StringType.headStringContainSubstring(str, delimiter))
                {
                    str = StringType.stringByCutHeadString(str, delimiter);
                    return delimiter;
                }
            }
            return null;
        }



    }



}

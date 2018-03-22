
#region using

using System;
using System.Collections.Generic;
using System.Reflection;

#endregion using

namespace DynamicType
{
    public class DynamicDemo
    {
        #region var's

        private Type extendedType = null;

        #endregion var's

        #region CreatePresentable

        public PresentingData CreatePresentable(dynamic src, Dictionary<string, Type> extendedPropertiesDict)
        {
            //create the dynamic type & class based on the dictionary - hold the extended class in a variable of the base-type
            PresentingData classicEx = DynamicFactory.CreateClass<PresentingData>(GetExtendedType<PresentingData>(extendedPropertiesDict));
            //fill in the base-type's properties
            classicEx.Composer = src.ComposerName;
            classicEx.Composition = src.CompositionName;
            classicEx.Orquestra = src.Orquestra;
            classicEx.Conductor = src.Conductor;
            //fill in the dynamically created properties
            SetExtendedProperties(classicEx as dynamic, src, extendedPropertiesDict);
            return classicEx;
        }

        #endregion CreatePresentable

        #region GetExtendedType

        //generic method that will extend dynamically the type T. keeping a global variable that holds the dynamic type
        //makes sure I create type only once (the class on the other hand has to be instantiated for each data-row
        protected Type GetExtendedType<T>(Dictionary<string, Type> extendedPropertiesDict) where T : class
        {
            if (extendedType == null)
            {
                extendedType = DynamicFactory.ExtendTheType<T>(extendedPropertiesDict);
            }
            return extendedType;
        }

        #endregion GetExtendedType

        #region SetExtendedProperties

        //generic method that enumerates the dictionary and populate the dynamic class with values from the source
        //class that contains all the 20 columns.
        //there is an assumption here that the newly created properties have the same name as the original ones
        //in the source class.
        //the dynamic class (destination) is passed-in using the keyword dynamic in order defer the GetType()
        //operation until runtime when the dynamic type is available.
        public void SetExtendedProperties<T>(dynamic dest, T src, Dictionary<string, Type> extendedPropsDict)
        {
            foreach (var word in extendedPropsDict)
            {
                var src_pi = src.GetType().GetProperty(word.Key);
                var dest_pi = dest.GetType().GetProperty(word.Key) as PropertyInfo;
                var val = src_pi.GetValue(src, null);
                //format the data based on its type
                if (val is DateTime)
                {
                    dest_pi.SetValue(dest, ((DateTime)val).ToShortDateString(), null);
                }
                else if (val is decimal)
                {
                    dest_pi.SetValue(dest, ((decimal)val).ToString("C"), null);
                }
                else
                {
                    dest_pi.SetValue(dest, val, null);
                }
            }
        }

        #endregion SetExtendedProperties
    }

    #region the data classes

    //base class of the presenting data
    public class PresentingData
    {
        public string Composer { get; set; }
        public string Composition { get; set; }
        public string Orquestra { get; set; }
        public string Conductor { get; set; }
    }

    //complete data as comes from the query
    public class CompleteData
    {
        public string ComposerName { get; set; }
        public string CompositionName { get; set; }
        public string Orquestra { get; set; }
        public string Conductor { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Maker { get; set; }
        public string Country { get; set; }
        public string Soloist { get; set; }
        public DateTime PurchaseDate { get; set; }
        public int Id { get; set; }
        public int RecordedYear { get; set; }
        public decimal Cost { get; set; }
    }

    #endregion the data classes
}

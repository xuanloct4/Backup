//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;
//using System.IO;
//using System.Dynamic;
//using DevExpress.AgDataGrid.Data;
//using DevExpress.AgDataGrid.Internal;
//using DevExpress.AgDataGrid.Tests;
//using DevExpress.AgDataGrid.UIAutomation;
//using DevExpress.AgDataGrid.Utils;
//using System.Xml.Linq;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Xml.Linq;
//using System.Reflection;
//using System.Reflection.Emit;
//using System.Threading;
//using System.Type;
//using System.Collections.Generic;
//using System.Reflection;

//namespace DynamicType
//{
//  public  class CreateDynamicsClass
//    {
//    }

//public class DynamicsClassTest
//{

//protected Dictionary<string, T> ExtendedColumnsDict = null;
        
//        public void start(XElement dynamicQuery)
//        {
//            ExtendedColumnsDict = ExtractFromXelement(dynamicQuery);
//        }
        
//        protected override ClassicP CreateClassicP(dynamic src, Dictionary<string> extendedColumnsDict)
//        {
//            //create the dynamic type & class based on the dictionary - 
//            //hold the extended class in a variable of the base-type
//            ClassicP classicEx = DynamicFactory.CreateClass
//            <classicp>(GetExtendedType<classicp>(extendedColumnsDict));
//            //fill in the base-type's properties
//            classicEx.Composer = src.ComposerName;
//            classicEx.Composition = src.CompositionName;
//            classicEx.Orquestra = src.Orquestra;
//            classicEx.Conductor = src.Conductor;
//            classicEx.SubCategory = src.SubCategory;
//            classicEx.Maker = src.Make;
//            classicEx.Details = src;
//            classicEx.Id = src.RecordingId;
//            classicEx.CdBoxId = src.CD_BoxId;
//            //fill in the dynamically created properties
//            SetExtendedProperties(classicEx as dynamic, src, extendedColumnsDict);
//            return classicEx;
//        }

//        //generic method that will extend dynamically the type T. 
//        //keeping a global variable that holds the dynamic type
//        //makes sure i create type only once 
//        //(the class on the other hand has to be instantiated for each data-row
//        protected Type GetExtendedType<T>(Dictionary<string,T> extendedColumnsDict) where T : class
//        {
//            if (ExtendedType == null)
//            {
//                ExtendedType = DynamicFactory.ExtendTheType<t>(ExtendedColumnsDict);
//            }
//            return ExtendedType;
//        }
        
//        //generic method that enumerates the dictionary and 
//        //populate the dynamic class with values from the source
//        //class that contains all the 20 columns.
//        //there is an assumption here that the newly created properties 
//        //have the same name as the original ones
//        //in the source class.
//        //the dynamic class (destination) is passed-in using the 
//        //keyword dynamic in order defer the GetType()
//        //operation until runtime when the dynamic type is available.
//        protected void SetExtendedProperties<T>(dynamic dest, T src, Dictionary<string,> extendedPropsDict)
//        {
//            foreach (var word in extendedPropsDict)
//            {
//                var src_pi = src.GetType().GetProperty(word.Key);
//                var dest_pi = dest.GetType().GetProperty(word.Key) as PropertyInfo;
//                var val = src_pi.GetValue(src, null);
//                //format the data based on its type
//                if (val is DateTime)
//                {
//                    dest_pi.SetValue(dest, ((DateTime) val).ToShortDateString(), null);
//                }
//                else if (val is decimal)
//                {
//                    dest_pi.SetValue(dest, ((decimal) val).ToString("C"), null);
//                }
//                else
//                {
//                    dest_pi.SetValue(dest, val, null);
//                }
//            }
//        }
//}

//   public class NotDynamic
//{
//    public string Composer {get; set;}
//    public string Composition {get; set;}

//        public void cccreate(){
//        Type dynamicType = CreateMyNewType("newTypeName","Cost", typeof(decimal), typeof(NotDynamic));
////use this variable for existing properties
//NotDynamic newClassBase =  Activator.CreateInstance(dynamicType);
//newClassBase.Composer = "Beethoven";
////use this variable for dynamically created properties.
//dynamic newClass = newClassBase;
//newClass.Cost = 19.50;
//        }

//    public static Type CreateMyNewType(string newTypeName, Dictionary<string> dict, Type baseClassType)
//        {
//            bool noNewProperties = true;
//            // create a dynamic assembly and module 
//            AssemblyBuilder assemblyBldr = Thread.GetDomain().DefineDynamicAssembly
//            (new AssemblyName("tmpAssembly"), AssemblyBuilderAccess.Run);
//            ModuleBuilder moduleBldr = assemblyBldr.DefineDynamicModule("tmpModule");

//            // create a new type builder
//            TypeBuilder typeBldr = moduleBldr.DefineType
//        (newTypeName, TypeAttributes.Public | TypeAttributes.Class, baseClassType);

//            // Loop over the attributes that will be used as the 
//            // properties names in my new type
//            string propertyName = null;
//            Type propertyType = null;
//            var baseClassObj = Activator.CreateInstance(baseClassType);
//            foreach (var word in dict)
//            {
//                propertyName = word.Key;
//                propertyType = word.Value;

//                //is it already in the base class?
//                var src_pi = baseClassObj.GetType().GetProperty(propertyName);
//                if (src_pi != null)
//                {
//                    continue;
//                }

//                // Generate a private field for the property
//                FieldBuilder fldBldr = typeBldr.DefineField
//        ("_" + propertyName, propertyType, FieldAttributes.Private);
//                // Generate a public property
//                PropertyBuilder prptyBldr = typeBldr.DefineProperty
//            (propertyName, PropertyAttributes.None, propertyType,
//                            new Type[] {propertyType});
//                // The property set and property get methods need the 
//                // following attributes:
//                MethodAttributes GetSetAttr = MethodAttributes.Public | 
//                        MethodAttributes.HideBySig;
//                // Define the "get" accessor method for newly created private field.
//                MethodBuilder currGetPropMthdBldr = typeBldr.DefineMethod
//                ("get_value", GetSetAttr, propertyType, null);

//                // Intermediate Language stuff... as per Microsoft
//                ILGenerator currGetIL = currGetPropMthdBldr.GetILGenerator();
//                currGetIL.Emit(OpCodes.Ldarg_0);
//                currGetIL.Emit(OpCodes.Ldfld, fldBldr);
//                currGetIL.Emit(OpCodes.Ret);

//                // Define the "set" accessor method for the newly created private field.
//                MethodBuilder currSetPropMthdBldr = typeBldr.DefineMethod
//            ("set_value", GetSetAttr, null, new Type[] {propertyType});

//                // More Intermediate Language stuff...
//                ILGenerator currSetIL = currSetPropMthdBldr.GetILGenerator();
//                currSetIL.Emit(OpCodes.Ldarg_0);
//                currSetIL.Emit(OpCodes.Ldarg_1);
//                currSetIL.Emit(OpCodes.Stfld, fldBldr);
//                currSetIL.Emit(OpCodes.Ret);

//                // Assign the two methods created above to the 
//                // PropertyBuilder's Set and Get
//                prptyBldr.SetGetMethod(currGetPropMthdBldr);
//                prptyBldr.SetSetMethod(currSetPropMthdBldr);
//                noNewProperties = false; //I added at least one property
//            }

//            if (noNewProperties == true)
//            {
//                return baseClassType; //deliver the base class
//            }
//            // Generate (and deliver) my type
//            return typeBldr.CreateType();
//        }
//   }
//}

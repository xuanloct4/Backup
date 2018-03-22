
#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;

#endregion using

namespace DynamicType
{
    public class DynamicFactory
    {
        #region crt'r do not use

        private DynamicFactory()
        {
        }

        #endregion crt'r do not use

        #region CreateClass

        public static T CreateClass<T>(Type newType) where T : class
        {
            return Activator.CreateInstance(newType) as T;
        }

        #endregion CreateClass

        #region ExtendTheType

        public static Type ExtendTheType<T>(Dictionary<string, Type> dict) where T : class
        {
            if (dict.Count == 0)
            {
                return typeof(T);
            }
            string typeName = typeof(T).ToString() + dict.First().Key + "Extended";
            return CreateMyNewType(typeName, dict, typeof(T));
        }

        #endregion ExtendTheType

        #region CreateMyNewType

        public static Type CreateMyNewType(string newTypeName, string propertyName, Type propertyType, Type baseClassType)
        {
            // create a dynamic assembly and module 
            AssemblyBuilder assemblyBldr = Thread.GetDomain().DefineDynamicAssembly(new AssemblyName("tmpAssembly"), AssemblyBuilderAccess.Run);
            ModuleBuilder moduleBldr = assemblyBldr.DefineDynamicModule("tmpModule");

            // create a new type builder
            TypeBuilder typeBldr = moduleBldr.DefineType(newTypeName, TypeAttributes.Public | TypeAttributes.Class, baseClassType);

            // Generate a private field for the property
            FieldBuilder fldBldr = typeBldr.DefineField("_" + propertyName, propertyType, FieldAttributes.Private);
            // Generate a public property
            PropertyBuilder prptyBldr = typeBldr.DefineProperty(propertyName, PropertyAttributes.None, propertyType, new Type[] { propertyType });
            // The property set and property get methods need the following attributes:
            MethodAttributes GetSetAttr = MethodAttributes.Public | MethodAttributes.HideBySig;
            // Define the "get" accessor method for newly created private field.
            MethodBuilder currGetPropMthdBldr = typeBldr.DefineMethod("get_value", GetSetAttr, propertyType, null); //Type.EmptyTypes);

            // Intermediate Language stuff... as per MS
            ILGenerator currGetIL = currGetPropMthdBldr.GetILGenerator();
            currGetIL.Emit(OpCodes.Ldarg_0);
            currGetIL.Emit(OpCodes.Ldfld, fldBldr);
            currGetIL.Emit(OpCodes.Ret);

            // Define the "set" accessor method for the newly created private field.
            MethodBuilder currSetPropMthdBldr = typeBldr.DefineMethod("set_value", GetSetAttr, null, new Type[] { propertyType });

            // More Intermediate Language stuff...
            ILGenerator currSetIL = currSetPropMthdBldr.GetILGenerator();
            currSetIL.Emit(OpCodes.Ldarg_0);
            currSetIL.Emit(OpCodes.Ldarg_1);
            currSetIL.Emit(OpCodes.Stfld, fldBldr);
            currSetIL.Emit(OpCodes.Ret);

            // Assign the two methods created above to the PropertyBuilder's Set and Get
            prptyBldr.SetGetMethod(currGetPropMthdBldr);
            prptyBldr.SetSetMethod(currSetPropMthdBldr);

            // Generate (and deliver) my type
            return typeBldr.CreateType();
        }

        public static Type CreateMyNewType(string newTypeName, Dictionary<string, Type> dict, Type baseClassType)
        {
            bool noNewProperties = true;
            // create a dynamic assembly and module 
            AssemblyBuilder assemblyBldr = Thread.GetDomain().DefineDynamicAssembly(new AssemblyName("tmpAssembly"), AssemblyBuilderAccess.Run);
            ModuleBuilder moduleBldr = assemblyBldr.DefineDynamicModule("tmpModule");

            // create a new type builder
            TypeBuilder typeBldr = moduleBldr.DefineType(newTypeName, TypeAttributes.Public | TypeAttributes.Class, baseClassType);

            // Loop over the attributes that will be used as the properties names in my new type
            string propertyName = null;
            Type propertyType = null;
            var baseClassObj = Activator.CreateInstance(baseClassType);
            foreach (var word in dict)
            {
                propertyName = word.Key;
                propertyType = word.Value;

                //is it already in the base class?
                var src_pi = baseClassObj.GetType().GetProperty(propertyName);
                if (src_pi != null)
                {
                    continue;
                }

                // Generate a private field for the property
                FieldBuilder fldBldr = typeBldr.DefineField("_" + propertyName, propertyType, FieldAttributes.Private);
                // Generate a public property
                PropertyBuilder prptyBldr = typeBldr.DefineProperty(propertyName, PropertyAttributes.None, propertyType,
                                                                    new Type[] { propertyType });
                // The property set and property get methods need the following attributes:
                MethodAttributes GetSetAttr = MethodAttributes.Public | MethodAttributes.HideBySig;
                // Define the "get" accessor method for newly created private field.
                MethodBuilder currGetPropMthdBldr = typeBldr.DefineMethod("get_value", GetSetAttr, propertyType, null);

                // Intermediate Language stuff... as per MS
                ILGenerator currGetIL = currGetPropMthdBldr.GetILGenerator();
                currGetIL.Emit(OpCodes.Ldarg_0);
                currGetIL.Emit(OpCodes.Ldfld, fldBldr);
                currGetIL.Emit(OpCodes.Ret);

                // Define the "set" accessor method for the newly created private field.
                MethodBuilder currSetPropMthdBldr = typeBldr.DefineMethod("set_value", GetSetAttr, null, new Type[] { propertyType });

                // More Intermediate Language stuff...
                ILGenerator currSetIL = currSetPropMthdBldr.GetILGenerator();
                currSetIL.Emit(OpCodes.Ldarg_0);
                currSetIL.Emit(OpCodes.Ldarg_1);
                currSetIL.Emit(OpCodes.Stfld, fldBldr);
                currSetIL.Emit(OpCodes.Ret);

                // Assign the two methods created above to the PropertyBuilder's Set and Get
                prptyBldr.SetGetMethod(currGetPropMthdBldr);
                prptyBldr.SetSetMethod(currSetPropMthdBldr);
                noNewProperties = false; //I added at least one property
            }

            if (noNewProperties == true)
            {
                return baseClassType; //deliver the base class
            }
            // Generate (and deliver) my type
            return typeBldr.CreateType();
        }

        #endregion CreateMyNewType
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

public class Unittest
    {

        public Unittest()
        {
    
            Model _mod = new Model(new OptionalDesc());
        //_mod.description.quantity = Quantative.Multi;
        //Model _mod2 = _mod;
        //_mod2.description.quantity = Quantative.One;
        //_mod.description.storeOption = StoreOptional.Disard;
        //MethodInfo[] Methodsinfo = typeof(String).GetMethods();
        //PropertyInfo[] Propertiesinfo = typeof(String).GetProperties();
        //foreach (var prop in typeof(Model).GetProperties())
        //{
        //    string ame = prop.Name;
        //    System.Diagnostics.Debug.WriteLine("Model properties: {0}", prop.Name);
        //}

        createHtmlModel(_mod);
        Model _clonedModel = Model.cloneModel(_mod);
        _clonedModel.description.name = new StringType("clonedModel");
        bool isSameModels = Model.areModelsSame(_mod,_clonedModel);
        //SerializeToFile.SerializeObject(_clonedModel,"D:\\serialize.ser");

        }

        public static void createCharModel(Model _model)
        {

        }

        public static void createExceptionStringModel(Model _model,List<Model>exceptionList)
        {
            createCharModel(_model);
            int exceptionListSize = exceptionList.Count;
            if (exceptionListSize == 0)
            {
                return;
            }
            for (int i = exceptionListSize - 1; i >= 0; i--)
            {
               exceptionList[i].description.quantity = Quantative.Zero;
                //...
                _model.subModel.Insert(0,exceptionList[i]); ;
            }

        }
        public static void createHtmlModel(Model html_model)
        {
            //Create model <html><head></head><body></body></html>
            //Model html_model = new Model(new OptionalDesc());
            html_model.description = new OptionalDesc();
            html_model.description.name = new StringType("html_model");
            html_model.subModel = new List<Model>();
            html_model.description.quantity = Quantative.One;
            Model head_model = new Model(new OptionalDesc());
            head_model.description.quantity = Quantative.One;
            Model body_model = new Model(new OptionalDesc());
            body_model.description.quantity = Quantative.One;

            Model htmlTagStart_model = new Model(new OptionalDesc());
            htmlTagStart_model.description.quantity = Quantative.One;
            htmlTagStart_model.description.name = new StringType("htmlTagStart_model");
            StringType str1 = new StringType("<");
            StringType str2 = new StringType("html");
            StringType str3 = new StringType(">");
            htmlTagStart_model.subModel = new List<Model>();
            htmlTagStart_model.subModel.Add(str1);
            htmlTagStart_model.subModel.Add(str2);
            htmlTagStart_model.subModel.Add(str3);

            Model htmlTagEnd_model = new Model(new OptionalDesc());
            htmlTagEnd_model.description.quantity = Quantative.One;
            StringType str4 = new StringType("/html");
            htmlTagEnd_model.subModel = new List<Model>();
            htmlTagEnd_model.subModel.Add(str1);
            htmlTagEnd_model.subModel.Add(str4);
            htmlTagEnd_model.subModel.Add(str3);

            html_model.subModel.Add(htmlTagStart_model);
            html_model.subModel.Add(head_model);
            htmlTagStart_model.description.quantity = Quantative.Multi;
            html_model.subModel.Add(body_model);
            html_model.subModel.Add(htmlTagEnd_model);





            // Model bodyTagStart_model = new Model(new OptionalDesc());
            //bodyTagStart_model.description.quantity = Quantative.Multi;
            //Model bodyTagEd_model = new Model(new OptionalDesc());
            //bodyTagEd_model.description.quantity = Quantative.Multi;

            //body_model.subModel.Add(bodyTagStart_model);
            //body_model.subModel.Add(bodyTagEd_model);
            
        }
    }
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types.DynamicObject
{
   public class DynamicReference
    {
       public static void DynamicReferenceTest(string[] args)
        {
            dynamic dyn = 1;
            object obj = 1;

            // Rest the mouse pointer over dyn and obj to see their
            // types at compile time.
            System.Console.WriteLine(dyn.GetType());
            System.Console.WriteLine(obj.GetType());


            ExampleClass ec = new ExampleClass();
            Console.WriteLine(ec.exampleMethod(10));
            Console.WriteLine(ec.exampleMethod("value"));

            // The following line causes a compiler error because exampleMethod
            // takes only one argument.
            //Console.WriteLine(ec.exampleMethod(10, 4));

            dynamic dynamic_ec = new ExampleClass();
            Console.WriteLine(dynamic_ec.exampleMethod(10));

            // Because dynamic_ec is dynamic, the following call to exampleMethod
            // with two arguments does not produce an error at compile time.
            // However, itdoes cause a run-time error. 
            //Console.WriteLine(dynamic_ec.exampleMethod(10, 4));

            int i = 8;
            dynamic d;
            //// With the is operator.
            //// The dynamic type behaves like object. The following
            //// expression returns true unless someVar has the value null.
            //if (someVar is dynamic) { }

            // With the as operator.
            d = i as dynamic;

            // With typeof, as part of a constructed type.
            Console.WriteLine(typeof(List<dynamic>));

            // The following statement causes a compiler error.
            //Console.WriteLine(typeof(dynamic));
        }
       public static void convertToDynamic()
        {
            dynamic d;
            int i = 20;
            d = (dynamic)i;
            Console.WriteLine(d);

            string s = "Example string.";
            d = (dynamic)s;
            Console.WriteLine(d);

            DateTime dt = DateTime.Today;
            d = (dynamic)dt;
            Console.WriteLine(d);

        }
        // Results:
        // 20
        // Example string.
        // 2/17/2009 9:12:00 AM
    }


    class ExampleClass
    {
        // A dynamic field.
        static dynamic field;

        // A dynamic property.
        dynamic prop { get; set; }

        // A dynamic return type and a dynamic parameter type.
        public dynamic exampleMethod(dynamic d)
        {
            // A dynamic local variable.
            dynamic local = "Local variable";
            int two = 2;

            if (d is int)
            {
                return local;
            }
            else
            {
                return two;
            }
        }
    }
}

using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.Linq.Expressions;
namespace System.Dynamic
{
    //public sealed class ExpandoObject : IDynamicMetaObjectProvider, IDictionary<string, object>, ICollection<KeyValuePair<string, object>>, IEnumerable<KeyValuePair<string, object>>, IEnumerable, INotifyPropertyChanged
    public sealed class ExpandoObjectExample
    {
        public static void ExpandoTest()
        {
            dynamic sampleObject = new ExpandoObject();
            //Adding New Members
            sampleObject.test = "Dynamic Property";
            Console.WriteLine(sampleObject.test);
            Console.WriteLine(sampleObject.test.GetType());
            // This code example produces the following output:
            // Dynamic Property
            // System.String

            sampleObject.number = 10;
            sampleObject.Increment = (Action)(() => { sampleObject.number++; });

            // Before calling the Increment method.
            Console.WriteLine(sampleObject.number);

            sampleObject.Increment();

            // After calling the Increment method.
            Console.WriteLine(sampleObject.number);
            // This code example produces the following output:
            // 10
            // 11
        }

        //Add event to instance
        public static void ExpandoObjectTest()
        {
            dynamic sampleObject = new ExpandoObject();

            // Create a new event and initialize it with null.
            sampleObject.sampleEvent = null;

            // Add an event handler.
            sampleObject.sampleEvent += new EventHandler(SampleHandler);

            // Raise an event for testing purposes.
            sampleObject.sampleEvent(sampleObject, new EventArgs());

            //Passing As a Parameter
            dynamic employee, manager;

            employee = new ExpandoObject();
            employee.Name = "John Smith";
            employee.Age = 33;

            manager = new ExpandoObject();
            manager.Name = "Allison Brown";
            manager.Age = 42;
            manager.TeamSize = 10;


            Func<int, int> func = x => 2 * x;
            manager.Foo = func;
            int i = manager.Foo(123); // now you see it
            manager.Foo = null; // now you don't

            WritePerson(manager);
            WritePerson(employee);


            //Enumerating and Deleting Members
            foreach (var property in (IDictionary<String, Object>)employee)
            {
                Console.WriteLine(property.Key + ": " + property.Value);
            }
            // This code example produces the following output:
            // Name: John Smith
            // Age: 33

            //In languages that do not have syntax for deleting members (such as C# and Visual Basic), you can delete a member by implicitly casting an instance of the ExpandoObject to the IDictionary<String, Object> interface and then deleting the member as a key/value pair. This is shown in the following example.
            ((IDictionary<String, Object>)employee).Remove("Name");
        }

        // Event handler.
        static void SampleHandler(object sender, EventArgs e)
        {
            Console.WriteLine("SampleHandler for {0} event", sender);
        }
        private static void WritePerson(dynamic person)
        {
            Console.WriteLine("{0} is {1} years old.",
                              person.Name, person.Age);
            // The following statement causes an exception
            // if you pass the employee object.
            // Console.WriteLine("Manages {0} people", person.TeamSize);
        }

        //Receiving Notifications of Property Changes
        public static void Test()
        {
            dynamic employee = new ExpandoObject();
            ((INotifyPropertyChanged)employee).PropertyChanged +=
                new PropertyChangedEventHandler(HandlePropertyChanges);
            employee.Name = "John Smith";
        }

        private static void HandlePropertyChanges(
            object sender, PropertyChangedEventArgs e)
        {
            Console.WriteLine("{0} has changed.", e.PropertyName);
        }
    }
}
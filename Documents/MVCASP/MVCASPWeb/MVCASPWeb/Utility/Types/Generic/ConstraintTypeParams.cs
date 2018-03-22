using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types.Generic
{
    class ConstraintTypeParams
    {
    }

    public class Employee
    {
        private string name;
        private int id;

        public Employee(string s, int i)
        {
            name = s;
            id = i;
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public int ID
        {
            get { return id; }
            set { id = value; }
        }
    }

    public class GenericList<T> where T : Employee
//        //or multi-constraints
//        class GenericList<T> where T : Employee, IEmployee, System.IComparable<T>, new()
//{
//    // ...
//}
    {
        //private class Node
        //{
        //    private Node next;
        //    private T data;

        //    public Node(T t)
        //    {
        //        next = null;
        //        data = t;
        //    }

        //    public Node Next
        //    {
        //        get { return next; }
        //        set { next = value; }
        //    }

        //    public T Data
        //    {
        //        get { return data; }
        //        set { data = value; }
        //    }
        //}

        //private Node head;

        //public GenericList() //constructor
        //{
        //    head = null;
        //}

        //public void AddHead(T t)
        //{
        //    Node n = new Node(t);
        //    n.Next = head;
        //    head = n;
        //}

        //public IEnumerator<T> GetEnumerator()
        //{
        //    Node current = head;

        //    while (current != null)
        //    {
        //        yield return current.Data;
        //        current = current.Next;
        //    }
        //}

        //public T FindFirstOccurrence(string s)
        //{
        //    Node current = head;
        //    T t = null;

        //    while (current != null)
        //    {
        //        //The constraint enables access to the Name property.
        //        if (current.Data.Name == s)
        //        {
        //            t = current.Data;
        //            break;
        //        }
        //        else
        //        {
        //            current = current.Next;
        //        }
        //    }
        //    return t;
        //}
    }


    //Constraining Multiple Parameters
    class Base { }
class Test<T, U>
    where U : struct
    where T : Base, new() { }

    //Type Parameters as Constraints
    class List<T>
{
    void Add<U>(List<U> items) where U : T {/*...*/}
}
    //Type parameter V is used as a type constraint.
public class SampleClass<T, U, V> where T : V { }



//    public static void OpTest<T>(T s, T t) where T : class
//{
//    System.Console.WriteLine(s == t);
//}
// static void Main()
//{
//    string s1 = "target";
//    System.Text.StringBuilder sb = new System.Text.StringBuilder("target");
//    string s2 = sb.ToString();
//    OpTest<string>(s1, s2);
//}


}

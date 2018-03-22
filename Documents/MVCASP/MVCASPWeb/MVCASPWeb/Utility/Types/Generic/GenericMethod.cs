using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types.Generic
{
    class GenericMethod
    {

       public static void Swap<T>(ref T lhs, ref T rhs)
        {
            T temp;
            temp = lhs;
            lhs = rhs;
            rhs = temp;
        }

        public static void TestSwap()
        {
            int a = 1;
            int b = 2;

            Swap<int>(ref a, ref b);
            System.Console.WriteLine(a + " " + b);
        }
    }

    public class SampleClass<T>
    {
       public static void Swap(ref T lhs, ref T rhs) {
       
       }

       public void Swap1(T lhs, T rhs)
       {

       }
    }

    public class GenericList1<T>
    {
        // CS0693
        void SampleMethod<T>() { }
        void SwapIfGreater<T>(ref T lhs, ref T rhs) where T : System.IComparable<T>
        {
            T temp;
            if (lhs.CompareTo(rhs) > 0)
            {
                temp = lhs;
                lhs = rhs;
                rhs = temp;
            }
        }
    }

    public class GenericList2<T>
    {
        //No warning
        void SampleMethod<U>() { }
    }

   
}

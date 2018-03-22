using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

     delegate void StackEventHandler<T, U>(T sender, U eventArgs);

        class Stack<T>
        {
            public class StackEventArgs : System.EventArgs { }
            public event StackEventHandler<Stack<T>, StackEventArgs> stackEvent;

            protected virtual void OnStackChanged(StackEventArgs a)
            {
                stackEvent(this, a);
            }
        }

        class SampleClass
        {
            public void HandleStackChange<T>(Stack<T> stack, Stack<T>.StackEventArgs args) { }
        }

        public class GenericDelegateTest
        {
            public static void Test()
            {
                Stack<double> s = new Stack<double>();
                SampleClass o = new SampleClass();
                s.stackEvent += o.HandleStackChange;
            }
        }

    class GenericDelegate
    {
        public delegate void Del<T>(T item);
        public static void Notify(int i) { }

        Del<int> m1 = new Del<int>(Notify);
        Del<int> m2 = Notify;
    }

    //class Stack<T>
    //{
    //    T[] items;
    //    int index;

    //    public delegate void StackDelegate(T[] items);

    //    private static void DoWork(float[] items) { }

    //    public static void TestStack()
    //    {
    //        Stack<float> s = new Stack<float>();
    //        Stack<float>.StackDelegate d = DoWork;
    //    }
    //}


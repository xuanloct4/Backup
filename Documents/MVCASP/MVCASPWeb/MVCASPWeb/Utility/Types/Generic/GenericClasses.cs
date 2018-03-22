using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types.Generic
{
    class BaseNode { }
    class BaseNodeGeneric<T> { }

    // concrete type
    class NodeConcrete<T> : BaseNode { }

    //closed constructed type
    class NodeClosed<T> : BaseNodeGeneric<int> { }

    //open constructed type 
    class NodeOpen<T> : BaseNodeGeneric<T> { }

    //No error
    class Node1 : BaseNodeGeneric<int> { }

    //Generates an error
    //class Node2 : BaseNodeGeneric<T> {}

    //Generates an error
    //class Node3 : T {}

    class BaseNodeMultiple<T, U> { }

    //No error
    class Node4<T> : BaseNodeMultiple<T, int> { }

    //No error
    class Node5<T, U> : BaseNodeMultiple<T, U> { }

    //Generates an error
    //class Node6<T> : BaseNodeMultiple<T, U> {} 

    class NodeItem<T> where T : System.IComparable<T>, new() { }
    class SpecialNodeItem<T> : NodeItem<T> where T : System.IComparable<T>, new() { }

    class SuperKeyType<K, V, U>
        where U : System.IComparable<U>
        where V : new()
    { }

//   public void Swap<T>(List<T> list1, List<T> list2)
//{
//    //code to swap items
//}

//void Swap(List<int> list1, List<int> list2)
//{
//    //code to swap items
//}

}

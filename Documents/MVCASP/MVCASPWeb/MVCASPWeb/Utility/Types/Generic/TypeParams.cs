using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types.Generic
{

          public interface ISessionChannel<TSession> { /*...*/ }
public delegate TOutput Converter<TInput, TOutput>(TInput from);
//public class List<T> { /*...*/ }

//public int IComparer<T>() { return 0; }
public delegate bool Predicate<T>(T item);
public struct Nullable<T> where T : struct { /*...*/ }
//public interface ISessionChannel<TSession>
//{
//    TSession Session { get; }
//}
    class TypeParams
    {
  
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Types
{
   public struct CustomPair
    {
        public int Key;
        public string Value;
    }
    class KeyValue
    {

       
        const int _max = 300000000;
       public static void CustomPairExample()
        {
            CustomPair p1;
            p1.Key = 4;
            p1.Value = "perls";
            Method(p1);

            KeyValuePair<int, string> p2 = new KeyValuePair<int, string>(4, "perls");
            Method(p2);

            for (int a = 0; a < 5; a++)
            {
                //var s1 = Stopwatch.StartNew();
                for (int i = 0; i < _max; i++)
                {
                    Method(p1);
                    Method(p1);
                }
                //s1.Stop();
                //var s2 = Stopwatch.StartNew();
                for (int i = 0; i < _max; i++)
                {
                    Method(p2);
                    Method(p2);
                }
                //s2.Stop();

                //Console.WriteLine(((double)(s1.Elapsed.TotalMilliseconds * 1000000) /
                //_max).ToString("0.00 ns"));
                //Console.WriteLine(((double)(s2.Elapsed.TotalMilliseconds * 1000000) /
                //_max).ToString("0.00 ns"));
            }
            Console.Read();
        }

        static int Method(CustomPair pair)
        {
            return pair.Key + pair.Value.Length;
        }

        static int Method(KeyValuePair<int, string> pair)
        {
            return pair.Key + pair.Value.Length;
        }

        public static void dictionary()
        {


            Dictionary<string, List<string>> kvlist = new Dictionary<string,List<string>>();

            kvlist["qwer"] = new List<string>();
            kvlist["qwer"].Add("value1");
            kvlist["qwer"].Add("value2");

            foreach (var value in kvlist["qwer"])
            {
                Console.WriteLine(value);
                // do something
            }
        }


        public static void keyValuePair()
        {
            var list = new List<KeyValuePair<string, int>>() { 
                new KeyValuePair<string, int>("A", 1),
                new KeyValuePair<string, int>("B", 2),
                new KeyValuePair<string, int>("C", 3),
                new KeyValuePair<string, int>("D", 4),
                new KeyValuePair<string, int>("E", 5),
                new KeyValuePair<string, int>("F", 6),
            };

            int input = 12;
            var alternatives = list.SubSets().Where(x => x.Sum(y => y.Value) == input);

            foreach (var res in alternatives)
            {
                Console.WriteLine(String.Join(",", res.Select(x => x.Key)));
            }
            Console.WriteLine("END");
            Console.ReadLine();
        }
    }

    public static class Extenions
    {
        public static IEnumerable<IEnumerable<T>> SubSets<T>(this IEnumerable<T> enumerable)
        {
            List<T> list = enumerable.ToList();
            ulong upper = (ulong)1 << list.Count;

            for (ulong i = 0; i < upper; i++)
            {
                List<T> l = new List<T>(list.Count);
                for (int j = 0; j < sizeof(ulong) * 8; j++)
                {
                    if (((ulong)1 << j) >= upper) break;

                    if (((i >> j) & 1) == 1)
                    {
                        l.Add(list[j]);
                    }
                }

                yield return l;
            }
        }
    }
}

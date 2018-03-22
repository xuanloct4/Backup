using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility.Threading
{
    class Delay
    {
        public static void runSyn()
        {
            Stopwatch sw = Stopwatch.StartNew();
            var delay = Task.Delay(1000).ContinueWith(_ =>
                                       {
                                           sw.Stop();
                                           return sw.ElapsedMilliseconds;
                                       });

            Console.WriteLine("Elapsed milliseconds: {0}", delay.Result);
        }

        public static void runASyn()
        {
            var delay = Task.Run(async () =>
            {
                Stopwatch sw = Stopwatch.StartNew();
                await Task.Delay(2500);
                sw.Stop();
                return sw.ElapsedMilliseconds;
            });

            Console.WriteLine("Elapsed milliseconds: {0}", delay.Result);
        }

        public static void runASyn1()
        {
            var t = Task.Run(async delegate
                  {
                      await Task.Delay(1000);
                      return 42;
                  });
            t.Wait();
            Console.WriteLine("Task t Status: {0}, Result: {1}",
                              t.Status, t.Result);
        }
    }

   
}

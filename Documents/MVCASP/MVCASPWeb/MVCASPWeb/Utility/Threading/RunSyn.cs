using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility.Threading
{
    class RunSyn
    {
        public static void runTaskSyn()
        {
    

      var asyncTask = Task.Run( () => {        System.Diagnostics.Debug.WriteLine("Task {0} (asyncTask) executing on Thread {1}",
                                                           Task.CurrentId,
                                                           Thread.CurrentThread.ManagedThreadId);
                                         long sum = 0;
                                         for (int ctr = 1; ctr <= 1000000; ctr++ )
                                            sum += ctr;
                                         return sum;
                                      });

      System.Diagnostics.Debug.WriteLine("Application executing on thread {0}",
                Thread.CurrentThread.ManagedThreadId);

      var syncTask = new Task<long>(() =>
      {
          System.Diagnostics.Debug.WriteLine("Task {0} (syncTask) executing on Thread {1}",
                Task.CurrentId,
                Thread.CurrentThread.ManagedThreadId);
          long sum = 0;
          for (int ctr = 1; ctr <= 1000000; ctr++)
              sum += ctr;
          return sum;
      });
      syncTask.RunSynchronously();


      var t = new Task(() =>
      {
                System.Diagnostics.Debug.WriteLine("Task {0} running on thread {1}",
                     Task.CurrentId, Thread.CurrentThread.ManagedThreadId);
          for (int ctr = 1; ctr <= 10; ctr++)
              Console.WriteLine("   Iteration {0}", ctr);
      }
                 );
      t.Start();
      t.Wait();

      System.Diagnostics.Debug.WriteLine("");
      System.Diagnostics.Debug.WriteLine("Task {0} returned {1:N0}", syncTask.Id, syncTask.Result);
      System.Diagnostics.Debug.WriteLine("Task {0} returned {1:N0}", asyncTask.Id, asyncTask.Result);
        
        }
    }
}

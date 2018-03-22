using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility.Threading
{
    class Continue
    {
        public static void ContinueWhenAll()
        {
            Task[] tasks = new Task[2];
            String[] files = null;
            String[] dirs = null;
            String docsDirectory = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);

            tasks[0] = Task.Factory.StartNew(() => files = Directory.GetFiles(docsDirectory));
            tasks[1] = Task.Factory.StartNew(() => dirs = Directory.GetDirectories(docsDirectory));

            Task.Factory.ContinueWhenAll(tasks, completedTasks =>
            {
                Console.WriteLine("{0} contains: ", docsDirectory);
                Console.WriteLine("   {0} subdirectories", dirs.Length);
                Console.WriteLine("   {0} files", files.Length);
            });
        }
        public static void ContinueAfter()
        {
            var firstTask = Task.Factory.StartNew(() =>
            {
                Random rnd = new Random();
                DateTime[] dates = new DateTime[100];
                Byte[] buffer = new Byte[8];
                int ctr = dates.GetLowerBound(0);
                while (ctr <= dates.GetUpperBound(0))
                {
                    rnd.NextBytes(buffer);
                    long ticks = BitConverter.ToInt64(buffer, 0);
                    if (ticks <= DateTime.MinValue.Ticks | ticks >= DateTime.MaxValue.Ticks)
                        continue;

                    dates[ctr] = new DateTime(ticks);
                    ctr++;
                }
                return dates;
            });

            Task continuationTask = firstTask.ContinueWith((antecedent) =>
            {
                DateTime[] dates = antecedent.Result;
                DateTime earliest = dates[0];
                DateTime latest = earliest;

                for (int ctr = dates.GetLowerBound(0) + 1; ctr <= dates.GetUpperBound(0); ctr++)
                {
                    if (dates[ctr] < earliest) earliest = dates[ctr];
                    if (dates[ctr] > latest) latest = dates[ctr];
                }
                Console.WriteLine("Earliest date: {0}", earliest);
                Console.WriteLine("Latest date: {0}", latest);
            });
            // Since a console application otherwise terminates, wait for the continuation to complete.
            continuationTask.Wait();
        }
    }
}

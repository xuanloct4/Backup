using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Utility.Threading
{
    class Timer
    {
          private static void OnTimedEvent(Object source, System.Timers.ElapsedEventArgs e)
        {
            Console.WriteLine("The Elapsed event was raised at {0}", e.SignalTime);
            System.Timers.Timer t = (System.Timers.Timer)source;
            //t.Start();
            //t.Stop();
            t.Close(); // The Close method in turn calls the Dispose method
        }
        public void createTimer()
        {
          // Normally, the timer is declared at the class level, so that it stays in scope as long as it
            // is needed. If the timer is declared in a long-running method, KeepAlive must be used to prevent
            // the JIT compiler from allowing aggressive garbage collection to occur before the method ends.
            // You can experiment with this by commenting out the class-level declaration and uncommenting 
            // the declaration below; then uncomment the GC.KeepAlive(aTimer) at the end of the method.        
            //System.Timers.Timer aTimer;

            // Create a timer and set a two second interval.
            System.Timers.Timer aTimer = new System.Timers.Timer();
            aTimer.Interval = 2000;
            //// Or
            //System.Timers.Timer aTimer = new System.Timers.Timer(2000);
          
            // Alternate method: create a Timer with an interval argument to the constructor.
            //aTimer = new System.Timers.Timer(2000);

            // Create a timer with a two second interval.
            aTimer = new System.Timers.Timer(2000);

            // Hook up the Elapsed event for the timer. 
            aTimer.Elapsed += new System.Timers.ElapsedEventHandler(OnTimedEvent);

            // Have the timer fire repeated events (true is the default)
            aTimer.AutoReset = true;

            // Start the timer
            aTimer.Enabled = true;

            //// Synchronize the timer with the text box
            //aTimer.SynchronizingObject = this.button1;

            Console.WriteLine("Press the Enter key to exit the program at any time... ");
            Console.ReadLine();

            // If the timer is declared in a long-running method, use KeepAlive to prevent garbage collection
            // from occurring before the method ends. 
            //GC.KeepAlive(aTimer) 
        }

    }
}

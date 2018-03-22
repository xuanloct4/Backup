using Microsoft.CSharp;
using System.CodeDom.Compiler;
using System.Reflection;
using System.Text;
using System.Diagnostics;

namespace System
{
    public static class CompileCSCAtRuntime
    {
        public static void HelloWorld()
        {
            string code = @"
                using System;

                namespace First
                {
                    public class Program
                    {
                        public static void Main()
                        {
                        " +
                            "System.Diagnostics.Debug.WriteLine(\"Debug111111:....\");"
                            + "Application.EnableVisualStyles();"
            + "Application.SetCompatibleTextRenderingDefault(false);"
            + " Application.Run(new System.Windows.Forms.Form());"
                          + @"
                        }
                    }
                }
            ";

            // "Console.WriteLine(\"Hello, world!\");"
            //System.Diagnostics.Debug.WriteLine("Debug111111:....");

            CSharpCodeProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters();

            // Reference to System.Drawing library
            parameters.ReferencedAssemblies.Add("System.Drawing.dll");
            parameters.ReferencedAssemblies.Add("System.dll");
       
            // True - memory generation, false - external file generation
            parameters.GenerateInMemory = true;
            // True - exe file generation, false - dll file generation
            parameters.GenerateExecutable = true;

            CompilerResults results = provider.CompileAssemblyFromSource(parameters, code);

            if (results.Errors.HasErrors)
            {
                StringBuilder sb = new StringBuilder();

                foreach (CompilerError error in results.Errors)
                {
                    sb.AppendLine(String.Format("Error ({0}): {1}", error.ErrorNumber, error.ErrorText));
                }

                throw new InvalidOperationException(sb.ToString());
            }

            Assembly assembly = results.CompiledAssembly;
            Type program = assembly.GetType("First.Program");
            MethodInfo main = program.GetMethod("Main");

            main.Invoke(null, null);
        }

        public static void TestMeothds()
        {
            MethodInfo function = CreateFunction("x + 2 * y");
            var betterFunction = (Func<double, double, double>)Delegate.CreateDelegate(typeof(Func<double, double, double>), function);
            Func<double, double, double> lambda = (x, y) => x + 2 * y;

            DateTime start;
            DateTime stop;
            double result;
            int repetitions = 5000000;

            start = DateTime.Now;
            for (int i = 0; i < repetitions; i++)
            {
                result = OriginalFunction(2, 3);
            }
            stop = DateTime.Now;
            Console.WriteLine("Original - time: {0} ms", (stop - start).TotalMilliseconds);

            start = DateTime.Now;
            for (int i = 0; i < repetitions; i++)
            {
                result = (double)function.Invoke(null, new object[] { 2, 3 });
            }
            stop = DateTime.Now;
            Console.WriteLine("Reflection - time: {0} ms", (stop - start).TotalMilliseconds);

            start = DateTime.Now;
            for (int i = 0; i < repetitions; i++)
            {
                result = betterFunction(2, 3);
            }
            stop = DateTime.Now;
            Console.WriteLine("Delegate - time: {0} ms", (stop - start).TotalMilliseconds);

            start = DateTime.Now;
            for (int i = 0; i < repetitions; i++)
            {
                result = lambda(2, 3);
            }
            stop = DateTime.Now;
            Console.WriteLine("Lambda - time: {0} ms", (stop - start).TotalMilliseconds);
        }

        public static double OriginalFunction(double x, double y)
        {
            return x + 2 * y;
        }

        public static MethodInfo CreateFunction(string function)
        {
            string code = @"
                using System;
            
                namespace UserFunctions
                {                
                    public class BinaryFunction
                    {                
                        public static double Function(double x, double y)
                        {
                            return func_xy;
                        }
                    }
                }
            ";

            string finalCode = code.Replace("func_xy", function);

            CSharpCodeProvider provider = new CSharpCodeProvider();
            CompilerResults results = provider.CompileAssemblyFromSource(new CompilerParameters(), finalCode);

            Type binaryFunction = results.CompiledAssembly.GetType("UserFunctions.BinaryFunction");
            return binaryFunction.GetMethod("Function");
        }
    }
}

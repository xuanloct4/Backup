using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Dynamic;
using Microsoft.Scripting.Hosting;
using IronPython.Hosting;
    public enum StringSearchOption
    {
        StartsWith,
        Contains,
        EndsWith
    }
    public class CreateDynamicClass:DynamicObject
    {
        // Store the path to the file and the initial line count value.
        private string p_filePath;

        // Public constructor. Verify that file exists and store the path in 
        // the private variable.
        public CreateDynamicClass(string filePath)
        {
            if (!File.Exists(filePath))
            {
                throw new Exception("File path does not exist.");
            }

            p_filePath = filePath;
        }

        // Implement the TryGetMember method of the DynamicObject class for dynamic member calls.
        public override bool TryGetMember(GetMemberBinder binder,
                                          out object result)
        {
            result = GetPropertyValue(binder.Name);
            return result == null ? false : true;
        }

        // Implement the TryInvokeMember method of the DynamicObject class for 
        // dynamic member calls that have arguments.
        public override bool TryInvokeMember(InvokeMemberBinder binder,
                                             object[] args,
                                             out object result)
        {
            StringSearchOption StringSearchOption = StringSearchOption.StartsWith;
            bool trimSpaces = true;

            try
            {
                if (args.Length > 0) { StringSearchOption = (StringSearchOption)args[0]; }
            }
            catch
            {
                throw new ArgumentException("StringSearchOption argument must be a StringSearchOption enum value.");
            }

            try
            {
                if (args.Length > 1) { trimSpaces = (bool)args[1]; }
            }
            catch
            {
                throw new ArgumentException("trimSpaces argument must be a Boolean value.");
            }

            result = GetPropertyValue(binder.Name, StringSearchOption, trimSpaces);

            return result == null ? false : true;
        }

        public List<string> GetPropertyValue(string propertyName,
                                         StringSearchOption StringSearchOption = StringSearchOption.StartsWith,
                                         bool trimSpaces = true)
        {
            StreamReader sr = null;
            List<string> results = new List<string>();
            string line = "";
            string testLine = "";

            try
            {
                sr = new StreamReader(p_filePath);

                while (!sr.EndOfStream)
                {
                    line = sr.ReadLine();

                    // Perform a case-insensitive search by using the specified search options.
                    testLine = line.ToUpper();
                    if (trimSpaces) { testLine = testLine.Trim(); }

                    switch (StringSearchOption)
                    {
                        case StringSearchOption.StartsWith:
                            if (testLine.StartsWith(propertyName.ToUpper())) { results.Add(line); }
                            break;
                        case StringSearchOption.Contains:
                            if (testLine.Contains(propertyName.ToUpper())) { results.Add(line); }
                            break;
                        case StringSearchOption.EndsWith:
                            if (testLine.EndsWith(propertyName.ToUpper())) { results.Add(line); }
                            break;
                    }
                }
            }
            catch
            {
                // Trap any exception that occurs in reading the file and return null.
                results = null;
            }
            finally
            {
                if (sr != null) { sr.Close(); }
            }

            return results;
        }
    }

    public class DynamicClassTest
    {
        public static void main()
        {
            dynamic rFile = new CreateDynamicClass("C:\\Users\\loctv.TOSHIBA-TSDV\\Documents\\Visual Studio 2013\\Projects\\Visualize\\MVCASPWeb\\Types\\DynamicObject\\TextFile1.txt");
            foreach (string line in rFile.Customer)
            {
                Console.WriteLine(line);
            }
            Console.WriteLine("----------------------------");
            foreach (string line in rFile.Customer(StringSearchOption.Contains, true))
            {
                Console.WriteLine(line);
            }
        }

        public static void pyScript()
        {
            //// Set the current directory to the IronPython libraries.
            //System.IO.Directory.SetCurrentDirectory(
            //   Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) +
            //   @"\IronPython 2.6 for .NET 4.0\Lib");
            System.IO.Directory.SetCurrentDirectory(
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) +
            @"\IronPython 2.7\Lib");

            // Create an instance of the random.py IronPython library.
            Console.WriteLine("Loading random.py");
            ScriptRuntime py = Python.CreateRuntime();
            dynamic random = py.UseFile("random.py");
            Console.WriteLine("random.py loaded.");
            // Initialize an enumerable set of integers.
            int[] items = Enumerable.Range(1, 7).ToArray();

            // Randomly shuffle the array of integers by using IronPython.
            for (int i = 0; i < 5; i++)
            {
                random.shuffle(items);
                foreach (int item in items)
                {
                    Console.WriteLine(item);
                }
                Console.WriteLine("-------------------");
            }
        }
    }
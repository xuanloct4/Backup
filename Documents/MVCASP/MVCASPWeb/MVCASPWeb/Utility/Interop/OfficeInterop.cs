//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;
//using Excel = Microsoft.Office.Interop.Excel;
//using Word = Microsoft.Office.Interop.Word;

//namespace MVCASPWeb.Interop
//{
//  public class OfficeInterop
//    {
//      public static void OfficeInteropTest()
//      {
//          // Create a list of accounts.
//          var bankAccounts = new List<Account> {
//    new Account { 
//                  ID = 345678,
//                  Balance = 541.27
//                },
//    new Account {
//                  ID = 1230221,
//                  Balance = -127.44
//                }
//};
//          // Display the list in an Excel spreadsheet.
//          DisplayInExcel(bankAccounts);

//          // Create a Word document that contains an icon that links to
//          // the spreadsheet.
//          CreateIconInWordDoc();
//      }

//      public static void DisplayInExcel(IEnumerable<Account> accounts)
//      {
//          var excelApp = new Excel.Application();
//          // Make the object visible.
//          excelApp.Visible = true;

//          // Create a new, empty workbook and add it to the collection returned 
//          // by property Workbooks. The new workbook becomes the active workbook.
//          // Add has an optional parameter for specifying a praticular template. 
//          // Because no argument is sent in this example, Add creates a new workbook. 
//          excelApp.Workbooks.Add();

//          // This example uses a single workSheet. The explicit type casting is
//          // removed in a later procedure.
//          Excel._Worksheet workSheet = (Excel.Worksheet)excelApp.ActiveSheet;

//          // Establish column headings in cells A1 and B1.
//          workSheet.Cells[1, "A"] = "ID Number";
//          workSheet.Cells[1, "B"] = "Current Balance";

//          //The foreach loop puts the information from the list of accounts into the first two columns of successive rows of the worksheet 
//          var row = 1;
//          foreach (var acct in accounts)
//          {
//              row++;
//              workSheet.Cells[row, "A"] = acct.ID;
//              workSheet.Cells[row, "B"] = acct.Balance;
//          }

//          //adjust the column widths to fit the content
//          workSheet.Columns[1].AutoFit();
//          workSheet.Columns[2].AutoFit();

//          // Call to AutoFormat in Visual C# 2010.
//          workSheet.Range["A1", "B3"].AutoFormat(
//              Excel.XlRangeAutoFormat.xlRangeAutoFormatClassic2);

//          //// Call to AutoFormat in Visual C# 2010.
//          //workSheet.Range["A1", "B3"].AutoFormat(Format:
//          //    Excel.XlRangeAutoFormat.xlRangeAutoFormatClassic2);

//          //// The AutoFormat method has seven optional value parameters. The
//          //// following call specifies a value for the first parameter, and uses 
//          //// the default values for the other six. 

//          //// Call to AutoFormat in Visual C# 2008. This code is not part of the
//          //// current solution.
//          //excelApp.get_Range("A1", "B4").AutoFormat(Excel.XlRangeAutoFormat.xlRangeAutoFormatTable3,
//          //    Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
//          //    Type.Missing);

//          // Put the spreadsheet contents on the clipboard. The Copy method has one
//          // optional parameter for specifying a destination. Because no argument  
//          // is sent, the destination is the Clipboard.
//          workSheet.Range["A1:B3"].Copy();
//      }

//      static void CreateIconInWordDoc()
//      {
//          var wordApp = new Word.Application();
//          wordApp.Visible = true;

//          // The Add method has four reference parameters, all of which are 
//          // optional. Visual C# 2010 allows you to omit arguments for them if
//          // the default values are what you want.
//          wordApp.Documents.Add();

//          // PasteSpecial has seven reference parameters, all of which are 
//          // optional. This example uses named arguments to specify values 
//          // for two of the parameters. Although these are reference 
//          // parameters, you do not need to use the ref keyword, or to create 
//          // variables to send in as arguments. You can send the values directly.
//          wordApp.Selection.PasteSpecial(Link: true, DisplayAsIcon: true);
//      }

//      static void CreateIconInWordDoc2008()
//      {
//          var wordApp = new Word.Application();
//          wordApp.Visible = true;

//          // The Add method has four parameters, all of which are optional. 
//          // In Visual C# 2008 and earlier versions, an argument has to be sent 
//          // for every parameter. Because the parameters are reference  
//          // parameters of type object, you have to create an object variable
//          // for the arguments that represents 'no value'. 

//          object useDefaultValue = System.Type.Missing;

//          wordApp.Documents.Add(ref useDefaultValue, ref useDefaultValue,
//              ref useDefaultValue, ref useDefaultValue);

//          // PasteSpecial has seven reference parameters, all of which are
//          // optional. In this example, only two of the parameters require
//          // specified values, but in Visual C# 2008 an argument must be sent
//          // for each parameter. Because the parameters are reference parameters,
//          // you have to contruct variables for the arguments.
//          object link = true;
//          object displayAsIcon = true;

//          wordApp.Selection.PasteSpecial(ref useDefaultValue,
//                                          ref link,
//                                          ref useDefaultValue,
//                                          ref displayAsIcon,
//                                          ref useDefaultValue,
//                                          ref useDefaultValue,
//                                          ref useDefaultValue);
//      }
//    }

//    public class Account
//    {
//        public int ID { get; set; }
//        public double Balance { get; set; }

      
//    }
//}

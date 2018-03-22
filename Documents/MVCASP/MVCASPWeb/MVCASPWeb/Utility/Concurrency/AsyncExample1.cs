using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

// Add the following using directives, and add a reference for System.Net.Http.
using System.Net.Http;
using System.IO;
using System.Net;

namespace MVCASPWeb.Concurrency
{
    public partial class AsyncExample1 : Form
    {
        public AsyncExample1()
        {
            InitializeComponent();
        }

        private static void ProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            Console.WriteLine(e.ProgressPercentage);
            //progressBar.Value = e.ProgressPercentage;
        }

        private static void Completed(object sender, AsyncCompletedEventArgs e)
        {
            Console.WriteLine("Download completed!");
            //MessageBox.Show("Download completed!");
        }
        public void downloadFIleAsync()
        {
         IWebProxy proxy = new WebProxy("proxy.tsdv.com.vn", 3128); // port number is of type integer 
            proxy.Credentials = new NetworkCredential("loctv", "123456");

            WebClient webClient = new WebClient();

            webClient.Proxy = proxy;

            webClient.DownloadFileCompleted += new AsyncCompletedEventHandler(Completed);
            webClient.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ProgressChanged);
            webClient.DownloadFileAsync(new Uri("http://www.damtp.cam.ac.uk/user/tong/string/three.pdf"), @"D:\myfile.pdf");
            //webClient.DownloadFile("http://www.damtp.cam.ac.uk/user/tong/string/three.pdf", @"D:\myfile.pdf");
        }
        public static async Task<string> sss()
        {
            try
            {
                IWebProxy proxy = new WebProxy("proxy.tsdv.com.vn", 3128); // port number is of type integer 
                proxy.Credentials = new NetworkCredential("loctv", "123456");

                var webReq = (HttpWebRequest)WebRequest.Create("https://msdn.microsoft.com/library/windows/apps/br211380.aspx");
                //webReq.Proxy = WebRequest.DefaultWebProxy;
                //webReq.Credentials = new NetworkCredential("loctv", "123456", "toshiba-tsdv.com");
                //webReq.Proxy.Credentials = new NetworkCredential("loctv", "123456", "toshiba-tsdv.com");
                webReq.Proxy = proxy;

                WebResponse response = await webReq.GetResponseAsync();
                Stream responseStream = response.GetResponseStream();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return "";
        }


        private async Task SumPageSizesAsync()
        {
            // Make a list of web addresses.
            List<string> urlList = SetUpURLList();

            var total = 0;

            foreach (var url in urlList)
            {
                byte[] urlContents = await GetURLContentsAsync(url);

                // The previous line abbreviates the following two assignment statements.

                // GetURLContentsAsync returns a Task<T>. At completion, the task
                // produces a byte array.
                //Task<byte[]> getContentsTask = GetURLContentsAsync(url);
                //byte[] urlContents = await getContentsTask;

                DisplayResults(url, urlContents);

                System.Console.WriteLine(string.Format("\r\n\r\nBytes returned:  {0}\r\n", urlContents));

                // Update the total.          
                total += urlContents.Length;
            }
            //// Display the total count for all of the websites.
            //resultsTextBox.Text +=
            //    string.Format("\r\n\r\nTotal bytes returned:  {0}\r\n", total);

            System.Console.WriteLine(string.Format("\r\n\r\nTotal bytes returned:  {0}\r\n", total));
        }


        private List<string> SetUpURLList()
        {
            List<string> urls = new List<string> 
            { 
                "https://msdn.microsoft.com/library/windows/apps/br211380.aspx",
                "https://msdn.microsoft.com",
                "https://msdn.microsoft.com/en-us/library/hh290136.aspx",
                "https://msdn.microsoft.com/en-us/library/ee256749.aspx",
                "https://msdn.microsoft.com/en-us/library/hh290138.aspx",
                "https://msdn.microsoft.com/en-us/library/hh290140.aspx",
                "https://msdn.microsoft.com/en-us/library/dd470362.aspx",
                "https://msdn.microsoft.com/en-us/library/aa578028.aspx",
                "https://msdn.microsoft.com/en-us/library/ms404677.aspx",
                "https://msdn.microsoft.com/en-us/library/ff730837.aspx"
            };
            return urls;
        }


        private async Task<byte[]> GetURLContentsAsync(string url)
        {
            // The downloaded resource ends up in the variable named content.
            var content = new MemoryStream();

            // Initialize an HttpWebRequest for the current URL.
            var webReq = (HttpWebRequest)WebRequest.Create(url);

            // Send the request to the Internet resource and wait for
            // the response.                
            using (WebResponse response = await webReq.GetResponseAsync())

            // The previous statement abbreviates the following two statements.

            //Task<WebResponse> responseTask = webReq.GetResponseAsync();
            //using (WebResponse response = await responseTask)
            {
                // Get the data stream that is associated with the specified url.
                using (Stream responseStream = response.GetResponseStream())
                {
                    // Read the bytes in responseStream and copy them to content. 
                    await responseStream.CopyToAsync(content);

                    // The previous statement abbreviates the following two statements.

                    // CopyToAsync returns a Task, not a Task<T>.
                    //Task copyTask = responseStream.CopyToAsync(content);

                    // When copyTask is completed, content contains a copy of
                    // responseStream.
                    //await copyTask;
                }
            }
            // Return the result as a byte array.
            return content.ToArray();
        }


        private void DisplayResults(string url, byte[] content)
        {
            // Display the length of each website. The string format 
            // is designed to be used with a monospaced font, such as
            // Lucida Console or Global Monospace.
            var bytes = content.Length;
            // Strip off the "http://".
            var displayURL = url.Replace("http://", "");
            resultsTextBox.Text += string.Format("\n{0,-58} {1,8}", displayURL, bytes);
        }

        private async void startButton_Click(object sender, EventArgs e)
        {
            this.downloadFIleAsync();

            // Disable the button until the operation is complete.
            startButton.Enabled = false;

            resultsTextBox.Clear();

            //// One-step async call.
            await SumPageSizesAsync();

            // Two-step async call.
            //Task sumTask = SumPageSizesAsync();
            //await sumTask;

            resultsTextBox.Text += "\r\nControl returned to startButton_Click.\r\n";

            // Reenable the button in case you want to run the operation again.
            startButton.Enabled = true;
        }
    }
}

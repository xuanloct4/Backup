using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.Models
{
    public class FileTableInfo
    {
        public Guid StreamID { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public Int64 FileSize { get; set; }
        public int CarId { get; set; }
        public int SubInstId { get; set; }
        public string VideoStart { get; set; }
        public string VideoEnd { get; set; }
        public string Note { get; set; }

        public FileTableInfo()
        {
        }
        /// <summary> 
        /// Construtor 
        /// </summary> 
        /// <param name="_trainId"></param> 
        /// <param name="_health"></param> 
        /// <param name="_hb_count"></param> 
        public FileTableInfo(Guid streamId, string fileName, string fileType, Int64 fileSize, int carId, int subInstId,
            string videoStart, string videoEnd, string note)
        {
            this.StreamID = streamId;
            this.FileName = fileName;
            this.FileType = fileType;
            this.FileSize = fileSize;
            this.CarId = carId;
            this.SubInstId = subInstId;
            this.VideoStart = videoStart;
            this.VideoEnd = videoEnd;
            this.VideoEnd = videoEnd;
            this.Note = note;
        }


        ///// <summary> 
        ///// Constructor 
        ///// </summary> 
        ///// <param name="train_id"></param> 
        //public List<FileTableInfo> GetListofFileInfo()   //StoredVideoFiles 
        //{ 
        //    List<FileTableInfo> listFileInfo = new List<FileTableInfo>(); 
        //    AbstractFactory df = new SQLFactory("DBName"); 
        //    DatabaseRequest req = new DatabaseRequest(); 
        //    req.CommandType = System.Data.CommandType.Text; 
        //    req.Command = "SELECT video_id, video_name, content_type, size, car_id, subsystem_instance_id, video_start, video_end, note FROM video "; 
        //   // req.Parameters.Add(new DatabaseRequest.Parameter("@dirName", dirName, SqlDbType.NVarChar)); 

        //    IDataReader reader = df.ExecuteDataReader(req); 

        //    while (reader.Read()) 
        //    { 
        //        Guid id = reader.GetGuid(0); 
        //        string name = reader.GetString(1); 
        //        string startDate = reader.GetDateTime(6).ToString("yyyy-MM-dd hh:mm", CultureInfo.CreateSpecificCulture("en-US")); 
        //        string endDate   = reader.GetDateTime(7).ToString("yyyy-MM-dd hh:mm", CultureInfo.CreateSpecificCulture("en-US")); 
        //        FileTableInfo fInfo = new FileTableInfo(id, name, reader.GetString(2), reader.GetInt64(3), 
        //            reader.GetInt32(4), reader.GetInt32(5), startDate, endDate, reader.GetString(8)); 
        //        listFileInfo.Add(fInfo); 
        //    } 
        //    reader.Close(); 
        //    return listFileInfo; 
        //} 

        //// Get a file from the database by ID 
        ///// <summary> 
        /////  
        ///// </summary> 
        ///// <param name="id"></param> 
        ///// <returns></returns> 
        //public DataTable GetAFileFromFileTable(Guid id) 
        //{ 
        //    DataTable file = new DataTable(); 

        //    AbstractFactory df = new SQLFactory("DBName"); 
        //    DatabaseRequest req = new DatabaseRequest(); 
        //    req.CommandType = System.Data.CommandType.Text; 
        //    req.Command = "SELECT video_name, content_type, data from video where  video_id=@ID"; 
        //    req.Parameters.Add(new DatabaseRequest.Parameter("@Id", id, SqlDbType.UniqueIdentifier)); 
        //    IDataReader reader = df.ExecuteDataReader(req); 
        //    while (!reader.IsClosed) 
        //    { 
        //        file.Load(reader); 
        //    } 
        //    reader.Close(); 
        //    return file; 
        //} 
    }
}

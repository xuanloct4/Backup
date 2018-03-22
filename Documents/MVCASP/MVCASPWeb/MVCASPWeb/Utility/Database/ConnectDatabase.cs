using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVCASPWeb.Models;
using System.Reflection;

namespace MVCASPWeb.Database
{
   
    class ConnectDatabase
    {
        public static string connString = "Data Source=(LocalDB)\\v11.0;AttachDbFilename=|DataDirectory|\\Movies.mdf;Integrated Security=True";

        public class DbFieldAttribute : Attribute { }
       
        public static IEnumerable<string> GetPropertiesWithDbAttribute<T>()
        {
            var allProps = typeof(T).GetProperties();
            var props = allProps.Where(p => Attribute.IsDefined(p, typeof(DbFieldAttribute))).Select(n => n.Name);
            return props.ToList();
           //return allProps.ToList();
        }

     
        public static List<Movie> select(string query)
        {
            List<Movie> movies = new List<Movie>();


            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    using (SqlCommand command = new SqlCommand(query, conn))
                    {
                        int newID = (int)command.ExecuteScalar();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {


                            int i = 0;

                            var props = GetPropertiesWithDbAttribute<Movie>();

                           

                            while (reader.Read())
                            {
                                Movie p = new Movie();
                                //// To avoid unexpected bugs access columns by name.
                                //p.ID = reader.GetInt32(reader.GetOrdinal("ID"));
                                //p.Title = reader.GetString(reader.GetOrdinal("Title"));
                                //p.ReleaseDate = reader.GetDateTime(reader.GetOrdinal("ReleaseDate"));
                                //p.Genre = reader.GetString(reader.GetOrdinal("Genre"));
                                //p.Price = reader.GetDecimal(reader.GetOrdinal("Price"));
                                //p.Rating = reader.GetString(reader.GetOrdinal("Rating"));

                                //foreach (string item in props)
                                //{
                                //    p.GetType().GetProperties().SetValue(p, reader[item], null);
                                //}

                                MVCASPWeb.Database.DataRecordHelper.CreateRecord<Movie>(reader, p);
                                movies.Add(p);

                                //string[] numb;
                                //numb = new string[reader.FieldCount];
                                //for (int j = 0; j < reader.FieldCount; j++)
                                //{
                                //    numb[j] = reader[j].ToString();
                                //}

                                Console.WriteLine(reader[0]);
                                i++;
                            }
                        }
                    } 
                }

                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }


            return movies;
        }
        public static void connectDatabase()
        {
            ///* get the Path */
            //var directoryName = System.IO.Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
            //var fileName = System.IO.Path.Combine(directoryName, "Foo2Database.sdf");

            ///* check if exists */
            //if (File.Exists(fileName))
            //    File.Delete(fileName);

            //string connStr = @"Data Source = " + fileName;

            ///* create Database */
            //SqlCeEngine engine = new SqlCeEngine(connStr);
            //engine.CreateDatabase();



            string str;
            //SqlConnection myConn = new SqlConnection("Server=localhost;Integrated security=SSPI;database=master");
             SqlConnection myConn = new SqlConnection("Data Source=(LocalDB)\\v11.0;AttachDbFilename=|DataDirectory|\\sqlServerDbFile.mdf;Integrated Security=True;Connect Timeout=30");
             // your db name
             string dbName = "MyDatabase";

             // db creation query
              //str = "CREATE DATABASE " + dbName + ";";

             str = "CREATE TABLE Customer(First_Name char(50),Last_Name char(50),Address char(50),City char(50),Country char(25));";

             //str = "INSERT INTO Customer VALUES(\"aaa\",\"aaa\",\"aaa\",\"aaa\",\"aaa\")";

            SqlCommand myCommand = new SqlCommand(str, myConn);
            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();       
                
            }
            catch (System.Exception ex)
            {
             
            }
            finally
            {
                if (myConn.State == ConnectionState.Open)
                {
                    myConn.Close();
                }
            }
        }


        public static void insertDatabase()
        {
            string str;
            SqlConnection myConn = new SqlConnection("Data Source=(LocalDB)\\v11.0;AttachDbFilename=|DataDirectory|\\sqlServerDbFile.mdf;Integrated Security=True;Connect Timeout=30");
            str = "INSERT INTO Customer(First_Name,Last_Name,Address,City,Country)VALUES('a','a','a','a','a')";
            SqlCommand myCommand = new SqlCommand(str, myConn);
            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {

            }
            finally
            {
                if (myConn.State == ConnectionState.Open)
                {
                    myConn.Close();
                }
            }
        }


        public static void updateDatabase()
        {
            string str;
            SqlConnection myConn = new SqlConnection("Data Source=(LocalDB)\\v11.0;AttachDbFilename=|DataDirectory|\\sqlServerDbFile.mdf;Integrated Security=True;Connect Timeout=30");
            str = "UPDATE Customer SET First_Name='bbb',Last_Name='bbb',Address='bbb',City='bbb' WHERE Country='a'";
            SqlCommand myCommand = new SqlCommand(str, myConn);
            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {

            }
            finally
            {
                if (myConn.State == ConnectionState.Open)
                {
                    myConn.Close();
                }
            }
        }

            // Returns a string containing all the fields in the table

            public static string BuildAllFieldsSQL(DataTable table)
            {
                string sql = "";
                foreach (DataColumn column in table.Columns)
                {
                    if (sql.Length > 0)
                        sql += ", ";
                    sql += column.ColumnName;
                }
                return sql;
            }

            // Returns a SQL INSERT command. Assumes autoincrement is identity (optional)

            public static string BuildInsertSQL(DataTable table)
            {
                StringBuilder sql = new StringBuilder("INSERT INTO " + table.TableName + " (");
                StringBuilder values = new StringBuilder("VALUES (");
                bool bFirst = true;
                bool bIdentity = false;
                string identityType = null;

                foreach (DataColumn column in table.Columns)
                {
                    if (column.AutoIncrement)
                    {
                        bIdentity = true;

                        switch (column.DataType.Name)
                        {
                            case "Int16":
                                identityType = "smallint";
                                break;
                            case "SByte":
                                identityType = "tinyint";
                                break;
                            case "Int64":
                                identityType = "bigint";
                                break;
                            case "Decimal":
                                identityType = "decimal";
                                break;
                            default:
                                identityType = "int";
                                break;
                        }
                    }
                    else
                    {
                        if (bFirst)
                            bFirst = false;
                        else
                        {
                            sql.Append(", ");
                            values.Append(", ");
                        }

                        sql.Append(column.ColumnName);
                        values.Append("@");
                        values.Append(column.ColumnName);
                    }
                }
                sql.Append(") ");
                sql.Append(values.ToString());
                sql.Append(")");

                if (bIdentity)
                {
                    sql.Append("; SELECT CAST(scope_identity() AS ");
                    sql.Append(identityType);
                    sql.Append(")");
                }

                return sql.ToString(); ;
            }


            // Creates a SqlParameter and adds it to the command

            public static void InsertParameter(SqlCommand command,
                                                 string parameterName,
                                                 string sourceColumn,
                                                 object value)
            {
                SqlParameter parameter = new SqlParameter(parameterName, value);

                parameter.Direction = ParameterDirection.Input;
                parameter.ParameterName = parameterName;
                parameter.SourceColumn = sourceColumn;
                parameter.SourceVersion = DataRowVersion.Current;

                command.Parameters.Add(parameter);
            }

            // Creates a SqlCommand for inserting a DataRow
            public static SqlCommand CreateInsertCommand(DataRow row)
            {
                DataTable table = row.Table;
                string sql = BuildInsertSQL(table);
                SqlCommand command = new SqlCommand(sql);
                command.CommandType = System.Data.CommandType.Text;

                foreach (DataColumn column in table.Columns)
                {
                    if (!column.AutoIncrement)
                    {
                        string parameterName = "@" + column.ColumnName;
                        InsertParameter(command, parameterName,
                                          column.ColumnName,
                                          row[column.ColumnName]);
                    }
                }
                return command;
            }

            // Inserts the DataRow for the connection, returning the identity
            public static object InsertDataRow(DataRow row, string connectionString)
            {
                SqlCommand command = CreateInsertCommand(row);

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    command.Connection = connection;
                    command.CommandType = System.Data.CommandType.Text;
                    connection.Open();
                    return command.ExecuteScalar();
                }
            }

        }
}

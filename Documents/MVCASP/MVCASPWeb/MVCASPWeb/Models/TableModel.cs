using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;

namespace MVCASPWeb.Models
{
    public class TableModel
    {
        public int ID { get; set; }

        public string imgUrl { get; set; }

        public string imgCap { get; set; }
    }

    public class TableViewModelDBContext : DbContext
    {
        public DbSet<TableModel> TableView { get; set; }
    }

    public class Person
    {
        public string name;
        public string pet;
        public Person(string _name, string _pet)
        {
            name = _name;
            pet = _pet;
        }
    }
    public class BlackPearlViewModel
    {
        public IEnumerable<Person> Pirates { get; private set; }

        public BlackPearlViewModel(IEnumerable<Person> pirates)
        {
            Pirates = pirates;

        }
    }

    public class Pirates
    {
    }
}

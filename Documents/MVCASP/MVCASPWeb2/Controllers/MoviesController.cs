using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MVCASPWeb.Models;
using FileSending.Database;
using System.Reflection;

namespace MVCASPWeb.Controllers
{
    public class MoviesController : Controller
    {
        // private MovieDBContext db;
        private MovieDBContext db = new MovieDBContext();

        // GET: Movies
        //public ActionResult Index()
        //{
        //    return View(db.Movies.ToList());
        //}

        public ActionResult Index(string movieGenres, string searchString)
        {
           

            var GenreLst = new List<string>();

            var GenreQry = from d in db.Movies
                           orderby d.Genre
                           select d.Genre;

            GenreLst.AddRange(GenreQry.Distinct());
            ViewBag.movieGenre = new SelectList(GenreLst);

            var movies = from m in db.Movies
                         select m;

            if (!String.IsNullOrEmpty(searchString))
            {
                movies = movies.Where(s => s.Title.Contains(searchString));
            }

            if (!string.IsNullOrEmpty(movieGenres))
            {
                movies = movies.Where(x => x.Genre == movieGenres);
            }



            return View(movies);

            if (searchString == null) searchString = "";
            if (movieGenres == null) movieGenres = "Comedy";
            //string query = "SELECT * FROM Movies WHERE Genre='" + movieGenres + "',Title LIKE '%" + searchString + "%'";
            string query = "SELECT * FROM Movies WHERE " + "Title LIKE '%" + searchString + "%'" + " AND Genre='" + movieGenres + "'";
            List<Movie> mov = FileSending.Database.ConnectDatabase.select(query);
          return View(mov);
        }

      
        //public ActionResult Index(string id)
        //{
        //    var movies = from m in db.Movies
        //                 select m;

        //    if (!String.IsNullOrEmpty(id))
        //    {
        //        movies = movies.Where(s => s.Title.Contains(id));
        //    }

        //    return View(movies);
        //}

        // GET: Movies/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movies.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }

        // GET: Movies/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Movies/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,Title,ReleaseDate,Genre,Price,Rating")] Movie movie)
        {
            if (ModelState.IsValid)
            {
                db.Movies.Add(movie);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(movie);
        }

        // GET: Movies/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movies.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }

        // POST: Movies/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public ActionResult Edit([Bind(Include = "ID,Title,ReleaseDate,Genre,Price,Rating")] Movie movie)
        //{
        //    if (ModelState.IsValid)
        //    {
        //       string t = movie.ToString();

        //        db.Entry(movie).State = EntityState.Modified;
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }
        //    return View(movie);
        //}

         [HttpPost]
        public ActionResult Edit(FormCollection form)
        {
            Movie p = new Movie();
            //p.ID = (int)Convert.ChangeType(ob[0], p.ID.GetType());
            //p.Title = (string)form.GetValue("Title").RawValue;
            //p.ReleaseDate = (DateTime)form.GetValue("ReleaseDate").RawValue;
            //p.Genre = (string)form.GetValue("Genre").RawValue;
            //p.Price = (decimal)form.GetValue("Price").RawValue;
            //p.Rating = (string)form.GetValue("Rating").RawValue;

            MVCASPWeb.Database.DataRecordHelper.CreateRecord<Movie>(form, p);

            db.Entry(p).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Index");

            //return RedirectToAction("Index", "Movies", p);
        }


       

        // GET: Movies/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Movie movie = db.Movies.Find(id);
            if (movie == null)
            {
                return HttpNotFound();
            }
            return View(movie);
        }

        // POST: Movies/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Movie movie = db.Movies.Find(id);
            db.Movies.Remove(movie);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}

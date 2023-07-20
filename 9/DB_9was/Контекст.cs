using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace DB_9
{
    public class Контекст : DbContext
    {
        public DbSet<Фильм> Фильмы { get; set; }
        public DbSet<Рейтинг> Рейтинги { get; set; }
        public Контекст()
        {
            Database.EnsureCreated();
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite("Filename=dbOMG.db");
        }
    }
}

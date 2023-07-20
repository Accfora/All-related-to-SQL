using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.ApplicationModel;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// Документацию по шаблону элемента "Пустая страница" см. по адресу https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x419

namespace DB_9
{
    /// <summary>
    /// Пустая страница, которую можно использовать саму по себе или для перехода внутри фрейма.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        public MainPage()
        {
            this.InitializeComponent();
            this.Loaded += MainPage_Loaded;
        }
        private void MainPage_Loaded(object sender, RoutedEventArgs e)
        {
            using (Контекст db = new Контекст())
            {
                List<String> films = db.Фильмы.Select(p => p.Название).ToList();

                filmsList.ItemsSource = films;
            }
        }
        int n;
        double Wasrating()
        {
            using (Контекст db = new Контекст())
            {
                return db.Рейтинги.GroupBy(gb => gb.Id)
                .Select(newe => new { Код_видеозаписи = newe.Key, avg = newe.Average(a => a.Рейтинг_видеозаписи) })
                .Where(w => w.Код_видеозаписи == n).FirstOrDefault().avg;
            }
        }
        private async void FilmsList_SelectionChanged(object sender,
       SelectionChangedEventArgs e)
        {
            rating.Value = -1;
            rating.IsReadOnly = false;
            rating.Caption = "";
            using (Контекст db = new Контекст())
            {
                n = db.Фильмы.Where(c => c.Название == e.AddedItems[0].ToString())
                    .Select(p => p.Id).FirstOrDefault();

                wasrating.Value = Wasrating();

                string path = db.Фильмы.Where(c => c.Id == n && c.Адрес != null).Select(p =>
                 p.Адрес).FirstOrDefault().ToString();
                var file = await Package.Current.InstalledLocation.GetFileAsync("Vids\\" + path);
                var stream = await file.OpenReadAsync();
                media.SetSource(stream, "");
                media.Play();
            }
        }

        private void rating_ValueChanged(RatingControl sender, object args)
        {
            rating.Caption = "Your rating";
            rating.IsReadOnly = true;
            using (Контекст db = new Контекст())
            {

                double changing = rating.Value - wasrating.Value;

                var result = db.Рейтинги.SingleOrDefault(r => r.Id == n);
                result.Рейтинг_видеозаписи += changing / 2;
                db.SaveChanges();

                wasrating.Value = Wasrating();
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace DB_8
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        string connectionString;
        SqlConnection cnn;
        string path = @"C:\Users\borod\OneDrive\Рабочий стол\ThirdDust\Смирнов_БД\8\Заказы\";
        string filename = "";
        int i = 0;
        string booksAdded = "";
        public MainWindow()
        {
            InitializeComponent();
            connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnection"].ConnectionString;
            cnn = new SqlConnection(connectionString);
            cnn.Open();
        }

        void NotEnabled()
        {
            booksAdded = "";
            MakeZakaz.IsEnabled = false;
        }

        void CreateFile()
        {
            do
                filename = "Заказ_" + ++i + ".txt";
            while (File.Exists(path + filename));
            NotEnabled();
            using (FileStream fs = File.Create(path + filename)) ;
            WatchZakazAgo.Content = "Посмотреть \n предыдущий\n  заказ №" + (i-1);
        }

        void FillWithBooks()
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText = @"select Название, count(*) as Популярность
from [Абонемент/Е3] inner join [Книга/E2] on [Абонемент/Е3].Код_книги = [Книга/E2].Код_книги
group by Название, [Книга/E2].Код_книги
having count(*) >= (select min (help.Колво)
				    from (select top 5 Код_книги, count(*) as Колво
					   	  from [Абонемент/Е3]
						  group by Код_книги
						  order by Колво desc) as help)
order by Популярность desc";
            SqlDataReader r = cmd.ExecuteReader();
            listBooks.Items.Clear();
            while (r.Read())
                listBooks.Items.Add(String.Format("{0}", r.GetValue(0).ToString()));
            r.Close();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            CreateFile();
            FillWithBooks();
        }

        private void listBooks_Double(object sender, MouseButtonEventArgs e)
        {
            Korzina.Items.Add(listBooks.SelectedItem);
            listBooks.Items.Remove(listBooks.SelectedItem);
            CheckKorzinaAndButtons();
        }
        private void Korzina_Double(object sender, MouseButtonEventArgs e)
        {
            listBooks.Items.Add(Korzina.SelectedItem);
            Korzina.Items.Remove(Korzina.SelectedItem);
            CheckKorzinaAndButtons();
        }
        void CheckKorzinaAndButtons()
        {
            if (Korzina.Items.Count == 0)
            {
                Zakaz.IsEnabled = false;
                if (booksAdded.Length > 0)
                    MakeZakaz.IsEnabled = true;
                else
                    MakeZakaz.IsEnabled = false;
            }
            else
            {
                Zakaz.IsEnabled = true;
                MakeZakaz.IsEnabled = false;
            }

        }

        private void AddZakaz_Click(object sender, RoutedEventArgs e)
        {
            MakeZakaz.IsEnabled = true;
            using (StreamWriter sw = new StreamWriter(path + filename, true, System.Text.Encoding.Default))
            {
                foreach (var item in Korzina.Items)
                {
                    SqlCommand cmd = cnn.CreateCommand();
                    cmd.CommandText = $"select Фамилия, Имя, Название, Издательство" +
                        $" from [Автор/E1] inner join [Книга/E2] on [Автор/E1].Код_автора = [Книга/E2].Код_автора" +
                        $" where Название like '{item}'" /*+ (booksAdded.Length!=0? $"and Название not in ({booksAdded})":"")*/; /*except({ sql.CommandText})*/
                    SqlDataReader r = cmd.ExecuteReader();
                    while (r.Read())
                    {
                        string line = String.Format("АВТОР: {0} {1}, КНИГА: {2}, ИЗДАТЕЛЬСТВО: {3}",
                            r.GetValue(0).ToString(), r.GetValue(1).ToString(),r.GetValue(2).ToString(), r.GetValue(3).ToString());
                        int beg = line.IndexOf("КНИГА: ") + 7;
                        booksAdded += ",'" + line.Substring(beg, line.IndexOf(", ИЗДАТЕЛЬСТВО") - beg) + "'";
                        booksAdded = booksAdded.Trim(',');
                        sw.WriteLine(line);
                    }
                    r.Close();
                }
            }
            KorzinaClear();
        }

        public void KorzinaClear()
        {
            Korzina.Items.Clear();
            Zakaz.IsEnabled = false;
        }
        private void Re_Click(object sender, RoutedEventArgs e)
        {
            using (StreamWriter sw = new StreamWriter(path + filename, false, System.Text.Encoding.Default)) { }
            FillWithBooks();
            KorzinaClear();
            NotEnabled();
        }

        private void Clo_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            MessageBox.Show("Если вы не оформили заказ, то он не сохранился!");
            File.Delete(path + filename);
        }

        private void MakeZakaz_Click(object sender, RoutedEventArgs e)
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText = @"select Фамилия, Имя, Название, Издательство
from (
select Код_книги, count(*) as Утерянные from [Штраф/E5]
where Книга_утеряна = 1 group by Код_книги
) as help 
inner join [Книга/E2] on help.Код_книги = [Книга/E2].Код_книги 
inner join [Автор/E1] on [Книга/E2].Код_автора = [Автор/E1].Код_автора
where help.Утерянные / 1.0 / Количество_книг > 0.25" + $" and Название not in ({booksAdded})";
            SqlDataReader r = cmd.ExecuteReader();
            using (StreamWriter sw = new StreamWriter(path + filename, true, System.Text.Encoding.Default))
            {
                while (r.Read())
                {
                    string line = String.Format("АВТОР: {0} {1}, КНИГА: {2}, ИЗДАТЕЛЬСТВО: {3}",
                        r.GetValue(0).ToString(), r.GetValue(1).ToString(), r.GetValue(2).ToString(), r.GetValue(3).ToString());
                    int beg = line.IndexOf("КНИГА: ") + 7;
                    booksAdded += ",'" + line.Substring(beg, line.IndexOf(", ИЗДАТЕЛЬСТВО") - beg) + "'";
                    booksAdded = booksAdded.Trim(',');
                    sw.WriteLine(line);
                }
                r.Close();
            }
            Update();
            MessageBox.Show($"Заказ оформлен в {filename}\nКниги уже доставлены!");
            Window_Loaded(this,null);
        }
        void Update()
        {
            SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText = @"update [Книга/E2] 
set Количество_книг = Количество_книг + 1
where Название in "+$"({booksAdded})";
            cmd.ExecuteNonQuery();
        }

        private void WatchZakazAgo_Click(object sender, RoutedEventArgs e)
        {
            string prePathFile = path + "Заказ_" + (i - 1) + ".txt";
            if (File.Exists(prePathFile))
                using (StreamReader sr = new StreamReader(prePathFile, Encoding.Default))
                {
                    MessageBox.Show(sr.ReadToEnd());
                }
            else
                MessageBox.Show("Файла с заказом не существует по техническим причинам!");
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp3
{
    static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            bool f = true;
            while (f)
            {
                try
                {
                    Application.Run(new Form1());
                    f = false;
                }
                catch
                {
                    MessageBox.Show("Кафедра не добавлена или не изменена!","Серьёзная ошибка!!!");
                }
            }
        }
    }
}

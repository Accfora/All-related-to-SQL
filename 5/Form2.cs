using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp3
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            // TODO: данная строка кода позволяет загрузить данные в таблицу "практ_1DataSet2.Таблица_Преподаватели0". При необходимости она может быть перемещена или удалена.
            this.таблица_Преподаватели0TableAdapter.Fill(this.практ_1DataSet2.Таблица_Преподаватели0);

        }
    }
}

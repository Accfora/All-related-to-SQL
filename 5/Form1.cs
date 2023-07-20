using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WindowsFormsApp3
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            //AutoCompleteStringCollection source = new AutoCompleteStringCollection()
            //{
            //    "http://",
            //    "http://no.ru/",
            //    "rsync://",
            //    "upd://"
            //};
            //t4.AutoCompleteCustomSource = source;
            //t4.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            //t4.AutoCompleteSource = AutoCompleteSource.CustomSource;
            //AutoCompleteStringCollection source1 = new AutoCompleteStringCollection()
            //{
            //    "8977",
            //    "8900112",
            //    "8903",
            //    "8977669"
            //};
            //t5.AutoCompleteCustomSource = source1;
            //t5.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            //t5.AutoCompleteSource = AutoCompleteSource.CustomSource;
        }


        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: данная строка кода позволяет загрузить данные в таблицу "практ_1DataSet.Таблица_Преподаватели0". При необходимости она может быть перемещена или удалена.
            this.таблица_Преподаватели0TableAdapter.Fill(this.практ_1DataSet.Таблица_Преподаватели0);
            // TODO: данная строка кода позволяет загрузить данные в таблицу "практ_1DataSet.Таблица_Кафедры0". При необходимости она может быть перемещена или удалена.
            this.таблица_Кафедры0TableAdapter.Fill(this.практ_1DataSet.Таблица_Кафедры0);
        }

        private void bindingNavigatorMoveNextItem_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
            SqlConnection cnn = new SqlConnection(connectionString);
            cnn.Open(); SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText =
                @" select count(*) from Таблица_Преподаватели0 left join Таблица_Кафедры0 
                on Таблица_Кафедры0.номер_кафедры = Таблица_Преподаватели0.номер_кафедры
                where Таблица_Кафедры0.номер_кафедры = '" + t0.Text + "'";
                d.Text = Convert.ToString(cmd.ExecuteScalar());
        }
        private void SecondNavigator(object sender, EventArgs e)
        {
            tN.Text = "";
            if (t10.Text == "") tN.Text += "Код преподавателя, " ; if (t11.Text == "") tN.Text += "Фамилия, "; if (t12.Text == "") tN.Text += "Имя, "; if (t13.Text == "") tN.Text += "Отчество, ";
            if (t14.Text == "") tN.Text += "Образование, "; if (t15.Text == "") tN.Text += "Стаж, "; if (t16.Text == "") tN.Text += "Номер кафедры, "; if (t17.Text == "") tN.Text += "Контактный телефон";
            tN.Text = tN.Text.Trim(); tN.Text = tN.Text.Trim(','); 
        }
        //private void forVyssch(object sender, EventArgs e)
        //{
        //    string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
        //    SqlConnection cnn = new SqlConnection(connectionString);
        //    cnn.Open(); SqlCommand cmd = cnn.CreateCommand();
        //    cmd.CommandText =
        //                @"select count(*) from Таблица_Кафедры0 where номер_кафедры = " + t0.Text;
        //}

        private void b2_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
            SqlConnection cnn = new SqlConnection(connectionString);
            cnn.Open(); SqlCommand cmdf = cnn.CreateCommand();
            string n = t4.Text;
            cmdf.CommandText =
                        @"select count(*) from Таблица_Кафедры0 where номер_кафедры = " + t0.Text;
            if (Convert.ToString(cmdf.ExecuteScalar()) != "0")
                MessageBox.Show("Строка с таким первичным ключом уже есть!!", "Ошибка!");
            else if (t1.Text == "" || t5.Text == "8" || t0.Text == "") 
                MessageBox.Show("Обязательные поля не заполнены (номер кафедры, название кафедры или телефон)!", "Ошибка!");
            else if (Convert.ToInt32(t0.Text) < 1)
                MessageBox.Show("Номер кафедры должен быть натуральным числом!", "Ошибка!");
            else 
            {
                string kov = "'";
                if (t2.Text == "") 
                    t2.Text = "NULL";
                string t3Text = "";
                if (t3.Text == "")
                {
                    t3Text = "NULL";
                }
                if (t4.Text == "http://")
                {
                    n = "NULL";
                    kov = "";
                }
                SqlCommand cmd = cnn.CreateCommand();
                cmd.CommandText =
                    @"insert into Таблица_Кафедры0 (номер_кафедры, код_факультета, 
                    название_кафедры, выпускающая_кафедра, сайт, телефон) values ("
                    +t0.Text+","+t2.Text+",'" + t1.Text + "'," + kov + t3Text + kov + "," + kov 
                    + n + kov + ",'" + t5.Text + "')";
                //MessageBox.Show(cmd.CommandText);
                cmd.ExecuteNonQuery();
                if (t2.Text == "NULL")  t2.Text = "";
                if (t4.Text == "NULL")  t4.Text = "";
                if (t5.Text == "NULL") t5.Text = "";
                MessageBox.Show("Успешно!");
            }
        }
        private void b1_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
            SqlConnection cnn = new SqlConnection(connectionString);
            cnn.Open(); SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText =
                        @"select count(*) from Таблица_Кафедры0 where номер_кафедры = " + t0.Text;
            if (Convert.ToString(cmd.ExecuteScalar()) == "0")
                MessageBox.Show("Строки не существует!", "Ошибка!");
            else if (t5.Text == "8")
            {
                MessageBox.Show("Вы снесли номер телефона!", "Ошибка!");
            }
            else if (t4.Text == "http://")
            {
                MessageBox.Show("Вы снесли сайт!", "Ошибка!");

            }
            else if (t1.Text == "")
                MessageBox.Show("Название кафедры не заполнено!", "Ошибка!");
            else
            {
                SqlCommand cmdq = cnn.CreateCommand();
                cmdq.CommandText =
                            @"select выпускающая_кафедра
from Таблица_Кафедры0
where номер_кафедры = " + t0.Text;
                SqlCommand cmdqe = cnn.CreateCommand();
                cmdqe.CommandText =
                            @"select count(*)
from Таблица_Преподаватели0 
where номер_кафедры = " + t0.Text + " and образование not like 'высшее' ";
                if (Convert.ToString(cmdq.ExecuteScalar()) == "False" && t3.Text == "True" && Convert.ToString(cmdqe.ExecuteScalar()) != "0")
                    MessageBox.Show("На кафедре числятся преподаватели без высшего образования!!", "Невозможно сделать кафедру выпускающей!");
                else
                {
                    SqlCommand cmd3 = cnn.CreateCommand();
                    cmd3.CommandText =
                    @"Update Таблица_Кафедры0 Set название_кафедры = '" + t1.Text + "', код_факультета = " + t2.Text + ", выпускающая_кафедра = '" + t3.Text + "', сайт = '" + t4.Text + "', телефон = '" + t5.Text + "'  Where номер_кафедры = " + t0.Text;
                    cmd3.ExecuteNonQuery();
                    MessageBox.Show("Успешно!");
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
            SqlConnection cnn = new SqlConnection(connectionString);
            cnn.Open(); SqlCommand cmdf = cnn.CreateCommand();
            cmdf.CommandText =
                        @"select count(*) from Таблица_Преподаватели0 where код_преподавателя = " + t10.Text;
            SqlCommand cmdt = cnn.CreateCommand();
            cmdt.CommandText =
                        @"select count(*) 
from Таблица_Кафедры0 
where номер_кафедры = " + t16.Text;
            SqlCommand cmdy = cnn.CreateCommand();
            cmdy.CommandText =
                        @"select count(*)
from Таблица_Кафедры0 
where Таблица_Кафедры0.номер_кафедры = " + t16.Text + " and Таблица_Кафедры0.выпускающая_кафедра = 'True'";
            if (Convert.ToString(cmdf.ExecuteScalar()) != "0")
                MessageBox.Show("Строка с таким первичным ключом уже есть!!", "Ошибка!");
            else if (t10.Text == "" || t11.Text == "" || t12.Text == "" || t13.Text == "" || t16.Text == "")
                MessageBox.Show("Обязательные поля не заполнены (ФИО и номер кафедры)!", "Ошибка!");
            else if (Convert.ToString(cmdt.ExecuteScalar()) == "0")
                MessageBox.Show("Введённой кафедры не существует!!", "Ошибка!");
            else if (Convert.ToString(cmdy.ExecuteScalar()) != "0" & t14.Text != "высшее") 
                MessageBox.Show("У преподавателей, работающих на выпускающих кафедрах, должно быть высшее образование!!", "Ошибка!");
            else
            {
                string kov = "'";
                if (t15.Text == "") t15.Text = "NULL";
                if (t14.Text == "")
                {
                    t14.Text = "NULL";
                    kov = "";
                }
                if (t17.Text == "")
                {
                    t17.Text = "NULL";
                    kov = "";
                }
                SqlCommand cmd = cnn.CreateCommand();
                cmd.CommandText =
                    @"insert into Таблица_Преподаватели0
                    (
                    фамилия,
                    имя,
                    отчество,
                    образование,
                    стаж,
                    номер_кафедры,
                    контактный_телефон
                    ) values ('" + t11.Text + "','" + t12.Text + "','" + t13.Text + "'," + kov
                    + t14.Text + kov + "," + t15.Text + "," + t16.Text + "," + kov + t17.Text + kov + ")";
                cmd.ExecuteNonQuery();
                if (t14.Text == "NULL") t14.Text = "";
                if (t15.Text == "NULL") t15.Text = "";
                if (t17.Text == "NULL") t17.Text = "";
                MessageBox.Show("Успешно!");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=DESKTOP-OKU7E5D;Initial Catalog=Практ_1;Integrated Security=True";
            SqlConnection cnn = new SqlConnection(connectionString);
            cnn.Open(); SqlCommand cmd = cnn.CreateCommand();
            cmd.CommandText =
                        @"select count(*) from Таблица_Преподаватели0 where код_преподавателя = " + t10.Text;
            SqlCommand cmdy = cnn.CreateCommand();
            cmdy.CommandText =
                        @"select count(*)
from Таблица_Кафедры0 
where Таблица_Кафедры0.номер_кафедры = " + t16.Text + " and Таблица_Кафедры0.выпускающая_кафедра = 'True'";
            SqlCommand cmdt = cnn.CreateCommand();
            cmdt.CommandText =
                        @"select count(*) 
from Таблица_Кафедры0 
where номер_кафедры = " + t16.Text;
            if (Convert.ToString(cmd.ExecuteScalar()) == "0")
                MessageBox.Show("Строки не существует!", "Ошибка!");
            else if (Convert.ToString(cmdy.ExecuteScalar()) != "0" & t14.Text != "высшее")
                MessageBox.Show("У преподавателей, работающих на выпускающих кафедрах, должно быть высшее образование!!", "Ошибка!");
            else if (t11.Text == "" || t12.Text == "" || t13.Text == "")
                MessageBox.Show("ФИО не заполнено!", "Ошибка!");
            else if (Convert.ToString(cmdt.ExecuteScalar()) == "0")
                MessageBox.Show("Введённой кафедры не существует!!", "Ошибка!");
            else
            {
                string kov = "'";
                if (t15.Text == "") t15.Text = "NULL";
                if (t14.Text == "")
                {
                    t14.Text = "NULL";
                    kov = "";
                }
                if (t17.Text == "")
                {
                    t17.Text = "NULL";
                    kov = "";
                }
                SqlCommand cmd3 = cnn.CreateCommand();
                cmd3.CommandText =
                @"Update Таблица_Преподаватели0 Set фамилия = '" + t11.Text + "', имя = '" + t12.Text + "', отчество = '" + t13.Text + "', образование = '" + t14.Text + "', стаж = " + t15.Text + ", контактный_телефон = '" + t17.Text + "', номер_кафедры = " + t16.Text + "  Where код_преподавателя = " + t10.Text;
                cmd3.ExecuteNonQuery();
                if (t14.Text == "NULL") t14.Text = "";
                if (t15.Text == "NULL") t15.Text = "";
                if (t17.Text == "NULL") t17.Text = "";
                MessageBox.Show("Успешно!");
            }
        }

        private void bindingNavigatorPositionItem_MouseMove(object sender, MouseEventArgs e)
        {
            bindingNavigatorMoveNextItem_Click(sender, e);
        }
    }
}

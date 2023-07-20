select Название, count(*) as Популярность
from [Абонемент/Е3] inner join [Книга/E2] on [Абонемент/Е3].Код_книги = [Книга/E2].Код_книги
group by Название, [Книга/E2].Код_книги
having count(*) >= (select min (help.Колво)
				    from (select top 3 Код_книги, count(*) as Колво
					   	  from [Абонемент/Е3]
						  group by Код_книги
						  order by Колво desc) as help)
order by Популярность desc
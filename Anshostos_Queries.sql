use Anshostos
go

-- Все поездки (за последнюю неделю)
select *
from Совершённые_поездки
where datediff(d,Дата_поездки,getdate()) < 14
-- Необычные поездки
select *
from Совершённые_поездки
where Станции_проездов not like '%Чепелёво%' or Станции_проездов not like '%Москворечье%'
and Станции_проездов not like '%Царицыно%'
-- Необычайно необычные поездки
select *
from Совершённые_поездки
where Станции_проездов not like '%Чепелёво%' and Станции_проездов not like '%Москворечье%'
-- С контроллёрами
select *
from Совершённые_поездки
where Контроллёры not like 'Не встречены'
-- С ожиданием
select *
from Совершённые_поездки 
where В_ожидании not like 'Без утечек времени'
-- С пересадками
select *
from Совершённые_поездки 
where Станции_проездов like '%-%-%'
-- Все проезды по станциям проездов
select Станции_проездов, count(*) as Использований, count(case when Контроллёры not like 'Не встречены' then 1 end) as Контроллёры,
sum(Оплата) as Потрачено, cast(round(avg(Оплата),2) as decimal(6,2)) Средняя_оплата, 
cast(round(avg(Минут_поездки),0) as int) as Среднее_время, max(Способы_оплаты) Наипопулярнейший_способ
from Совершённые_поездки
group by Станции_проездов order by Использований desc, sum(Оплата), Станции_проездов

-- Популярность

select 
count(distinct Поездка) as Поездки,
--dense_rank() over (order by count(distinct Поездка) desc) as Ранк,
Название_станции,
count (distinct Поездка) - count(case when Станция_прибытия = Id_станции then Станция_прибытия end)  as Посадка,
count (distinct Поездка) - count(case when Станция_отправления = Id_станции then Станция_отправления end)  as Выход,
concat(cast(round(count(distinct Поездка) * 100.0 / (select count(*) from Поездки),2) as decimal(4,1)),'%') as Вовлечённость,
	count(case when Станция_отправления = Id_станции then Станция_отправления end) 
	+ count(case when Станция_прибытия = Id_станции then Станция_прибытия end) 
	- count (distinct Поездка) as Пересадка
from Станции st  
join Маршруты m on st.Id_станции = m.Станция_отправления or st.Id_станции = m.Станция_прибытия
join Проезды pr on m.Id_маршрута = pr.Маршрут
group by Id_станции, Название_станции
order by count(distinct Поездка) desc, Id_станции
--order by Id_станции
go

-- Использование маршрутов

select 
	count(Id_проезда) as Проездов,
	concat(stbegin.Название_станции, ' - ', stend.Название_станции) as Станции_проезда, 
	convert(varchar(5),Время_отправления) as Отправка, 
	case 
		when avg(Опоздание_отправления) = 0 then 'В указанное время' 
		when avg(Опоздание_отправления) < 0  then concat('ОПЕРЕЖЕНИЕ в ',abs(avg(Опоздание_отправления)),' минут') 
		else concat(avg(Опоздание_отправления),' минут ОПОЗДАНИЯ')  end as Среднее_отправление,
	convert(varchar(5),Время_прибытия) as Прибытие, 
	case 
		when avg(Опоздание_прибытия) = 0 then 'В указанное время' 
		when avg(Опоздание_прибытия) < 0  then concat('ОПЕРЕЖЕНИЕ в ',abs(avg(Опоздание_прибытия)),' минут') 
		else concat(avg(Опоздание_прибытия),' минут ОПОЗДАНИЯ')  end as Среднее_прибытие
from Проезды pr join Маршруты m on m.Id_маршрута = pr.Маршрут
join Станции stbegin on stbegin.Id_станции = m.Станция_отправления join Станции stend on stend.Id_станции = m.Станция_прибытия
group by Id_маршрута, Станция_отправления, Станция_прибытия, stbegin.Название_станции,  stend.Название_станции, Время_отправления, Время_прибытия
order by (case when avg(Опоздание_отправления) <> 0 or avg(Опоздание_прибытия) <> 0 then 0 else 1 end),
Станция_отправления, Станция_прибытия, Время_отправления

-- Оплаты по электричкам

select 
	concat(count(Id_поездки), ' раз') as Использований,
	concat(convert(varchar(5),Время_начала_пути), ' из ',stbegin.Название_станции, ' - ', stend.Название_станции) as Путь_электрички,
	case when Посадочная_станция - Конечная_станция > 0 then 'На север' else 'На юг' end as Направление,
	isnull(cast(min(Москворечье) as varchar(10)) + ' в Москворечье',isnull(cast(min(Чепелёво) as varchar(15)) + ' в Чепелёво','Без популярных станций')) as По_популярным,
	concat(cast(avg(Сумма) as decimal(5,2)), ' рублей') Средняя_оплата
from 
(
	select Id_электрички, Id_поездки, sum(Оплата) Сумма, 
	min(case when Станция_отправления = 12 then convert(varchar(5),Время_отправления) when Станция_прибытия = 12 then convert(varchar(5),Время_прибытия) end) as Москворечье,
	min(case when Станция_отправления = 29 then convert(varchar(5),Время_отправления) when Станция_прибытия = 29 then convert(varchar(5),Время_прибытия) end) as Чепелёво
	from Поездки po join Проезды pr on po.Id_поездки = pr.Поездка 
	join Маршруты m on m.Id_маршрута = pr.Маршрут 
	join Электрички e on m.Электричка = e.Id_электрички
	group by Id_электрички, Id_поездки
) grouped 
join Электрички e on grouped.Id_электрички = e.Id_электрички
join Типы_электричек te on te.Id_типа_электрички = e.Тип_электрички
join Станции stbegin on stbegin.Id_станции = te.Посадочная_станция join Станции stend on stend.Id_станции = te.Конечная_станция
group by e.Id_электрички, stbegin.Название_станции, stend.Название_станции, Время_начала_пути, Посадочная_станция, Конечная_станция
order by avg(Сумма), min(Москворечье)
go

-- Все поездки

alter view Совершённые_поездки as
select 
		--concat(Дата_поездки,
		--case count(case when Направление < 0 then )
		--),
		Дата_поездки,
		'Время' = cast(min(convert(varchar(5),Время_отправления))as varchar(8)) + ' - ' + cast(max(convert(varchar(5),Время_прибытия)) as varchar(8)),
		string_agg(s1.Название_станции, ' - ') WITHIN GROUP (ORDER BY Время_отправления) + ' - ' 
		+ (select Название_станции from Проезды inc 
		join Маршруты incoc on inc.Маршрут = incoc.Id_маршрута 
		join Станции we on incoc.Станция_прибытия = we.Id_станции
		where inc.Поездка = max(prm.Поездка) and dateadd(mi,Опоздание_прибытия,Время_прибытия) = max(prm.Время_прибытия)) as Станции_проездов,
		sum (Оплата) as Оплата,
		string_agg(Способ_оплаты, ', ') as Способы_оплаты,
		datediff(mi,min(Время_отправления),max(Время_прибытия)) as Минут_поездки,
		case 
			datediff(mi,min(Время_отправления),max(Время_прибытия)) - sum(datediff(mi,Время_отправления,Время_прибытия)) when 0 then 'Без утечек времени' 
			else cast(datediff(mi,min(Время_отправления),max(Время_прибытия)) - sum(datediff(mi,Время_отправления,Время_прибытия)) as varchar(10))  + ' минут' 
		end as В_ожидании,
		case 
			count(Обнаружение) when 0 then 'Не встречены' 
			else 
				case when count(Пробитие) != 0 then 'Пробит на станции '+ STRING_AGG(k.Пробитие, ', ') 
				else 'Избегнуты со станции '+ STRING_AGG(k.Обнаружение, ', ') 
			end 
		end as Контроллёры
from Поездки po 
	join (select Id_проезда, Оплата, Способ_оплаты, Поездка, Id_маршрута, Станция_отправления, Станция_прибытия, 
		Станция_отправления - Станция_прибытия as Направление, 
		dateadd(mi,Опоздание_отправления,Время_отправления) as Время_отправления, 
		dateadd(mi,Опоздание_прибытия,Время_прибытия) as Время_прибытия 
		from Проезды pr 
		join Маршруты m on m.Id_маршрута = pr.Маршрут) prm on po.Id_поездки = prm.Поездка
	join Станции s1 on prm.Станция_отправления = s1.Id_станции 
	 left join 
(select Проезд, 
STRING_AGG(sto.Название_станции, ', ') Обнаружение,
STRING_AGG(stp.Название_станции, ', ') Пробитие 
from Контроллёры 
left join Станции stp on stp.Id_станции = Станция_пробития
left join Станции sto on sto.Id_станции = Станция_обнаружения
group by Проезд) k on k.Проезд = prm.Id_проезда
group by Дата_поездки, Id_поездки
order by Дата_поездки DESC, min(Время_отправления) DESC offset 0 rows
go

-- Все проезды

select 
	Дата_поездки,
	(select Название_станции from Станции where Id_станции = m.Станция_отправления) 
	+ ' - ' + (select Название_станции from Станции where Id_станции = m.Станция_прибытия) as Проезд,
	Время_отправления,
	Время_прибытия,
	Оплата,
	Вид_электрички,
	(select Название_станции from Станции where Id_станции = te.Посадочная_станция) 
	+ ' - ' + (select Название_станции from Станции where Id_станции = te.Конечная_станция) as Путь_электрички
from Поездки po 
join Проезды pr on po.Id_поездки = pr.Поездка
join Маршруты m on m.Id_маршрута = pr.Маршрут
join Электрички e on m.Электричка = e.Id_электрички
join Типы_электричек te on e.Тип_электрички = te.Id_типа_электрички
order by Дата_поездки
go

--with help as (
--	select 
--	Дата_поездки, Поездка, Станция_отправления, Станция_прибытия, dateadd(mi,Опоздание_отправления,Время_отправления) Время_отправления, 
--	dateadd(mi,Опоздание_прибытия,Время_прибытия) Время_прибытия, cast(concat(Станция_отправления, ' - ',Станция_прибытия) as varchar(100)) cc, 1 su
--	from Проезды pr join Поездки po on po.Id_поездки = pr.Поездка
--	join Маршруты m on m.Id_маршрута = pr.Отрезок_станций
--	-- не работает так как не добавлено опоздание?
--	union all
--	select po.Дата_поездки, pr.Поездка, m.Станция_отправления, m.Станция_прибытия, dateadd(mi,Опоздание_отправления,m.Время_отправления) Время_отправления, 
--	dateadd(mi,Опоздание_прибытия,m.Время_прибытия) Время_прибытия, cast(cte.cc + ' - ' + cast(m.Станция_прибытия as varchar(3)) as varchar(100)) cc, cte.su + 1
--	from Проезды pr join Поездки po on po.Id_поездки = pr.Поездка
--	join Маршруты m on m.Id_маршрута = pr.Отрезок_станций
--	join help cte on cte.Станция_прибытия = m.Станция_отправления and cte.Дата_поездки = po.Дата_поездки and cte.Время_отправления <= m.Время_прибытия
--)
--select * from help
--	where not exists (select * from Проезды zpr join Маршруты zm on zm.Id_маршрута = zpr.Отрезок_станций 
--	where help.Поездка = zpr.Поездка and zm.Время_прибытия < help.Время_прибытия and zm.Время_отправления > help.Время_отправления)
--group by Дата_поездки, Поездка


with smth as (
select * 
	from Поездки po 
	join (select Id_проезда, Оплата, Поездка, Id_маршрута, Станция_отправления, Станция_прибытия, 
		dateadd(mi,Опоздание_отправления,Время_отправления) as Время_отправления, 
		dateadd(mi,Опоздание_прибытия,Время_прибытия) as Время_прибытия 
		from Проезды pr 
		join Маршруты m on m.Id_маршрута = pr.Маршрут) prm on po.Id_поездки = prm.Поездка
	join Станции s1 on prm.Станция_отправления = s1.Id_станции 
	)
select Дата_поездки, 'Время' = cast(min(w1)as varchar(8)) + ' - ' + cast(max(w2) as varchar(8)), 
string_agg(qw.Станции_проездов, ',  ') WITHIN GROUP (ORDER BY w2) as r,
sum(Оплата) as Сумма, cast(sum(Время_поездки) as varchar(8)) + ' минут' as Время_в_пути,
count (*) as Поездки,
case sum(В_ожидании) when 0 then 'Без лишних электричек' else cast(sum(В_ожидании) as varchar(10)) + ' минут' end as На_платформе
from (
	select 
		Дата_поездки,
		min(Время_отправления) as w1, max(Время_прибытия) as w2,
		string_agg(smth.Название_станции, ' - ') WITHIN GROUP (ORDER BY Время_отправления) + ' - ' 
		+ (select Название_станции from Проезды inc 
		join Маршруты incoc on inc.Маршрут = incoc.Id_маршрута 
		join Станции we on incoc.Станция_прибытия = we.Id_станции
		where inc.Поездка = max(smth.Поездка) and dateadd(mi,Опоздание_прибытия,Время_прибытия) = max(smth.Время_прибытия)) as Станции_проездов,
		sum (Оплата) as Оплата,
		datediff(mi,min(Время_отправления),max(Время_прибытия)) as Время_поездки,
		datediff(mi,min(Время_отправления),max(Время_прибытия)) - sum(datediff(mi,Время_отправления,Время_прибытия)) as В_ожидании
	from smth
	group by Дата_поездки, Id_поездки) qw
group by Дата_поездки
go


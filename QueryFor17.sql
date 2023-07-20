use SaaleTrigger
go

IF OBJECT_ID ('Saale','TR') IS NOT NULL
   DROP TRIGGER Saale;
GO

create trigger Saale
on Предпочтения
after insert
as
begin

declare @id int
DECLARE SaaleCurse CURSOR FAST_FORWARD FOR
    SELECT distinct Код_посетителя
    FROM inserted
open SaaleCurse
FETCH NEXT FROM SaaleCurse INTO @id
while @@FETCH_STATUS = 0
begin

--declare @dt_entrance datetime = getdate()
declare @dt_entrance datetime = '2023-05-03 20:51:00', @m int = null
declare @t table (Маршрут int, Зал int, Порядок int);
with cteq as (
	select Номер_зала, 1 q, null bef, cast(concat(Номер_зала,'.') as varchar(200)) pth
	from Залы zmain
	union all
	select zdown.Номер_зала, cteq.q + 1, cteq.Номер_зала bef
	, cast(concat(cteq.pth,zdown.Номер_зала,'.') as varchar(200)) pth
	from cteq join Переходы p on cteq.Номер_зала = p.Второй_зал or cteq.Номер_зала = p.Первый_зал
	join Залы zdown on (zdown.Номер_зала = p.Второй_зал or zdown.Номер_зала = p.Первый_зал)
	and cteq.pth not like concat('%',zdown.Номер_зала,'.%')
) 
insert @t 
select top 1 with ties *
from
(
	select 
		dense_rank() over (order by pth) as Маршрут,
		value as Зал, 
		ROW_NUMBER() over (partition by pth order by pth) as Порядок
	from cteq cross apply string_split(trim('.' from pth),'.') 
	where q = (select max(q) from cteq) 
) omg 
order by sum(case when Зал in 
(select distinct Номер_зала from inserted i 
join Экспозиции e on e.Экспонат = i.Экспонат where Код_посетителя = @id) 
then Порядок else 0 end) over (partition by Маршрут)

while 1 = 1
begin
	set @m = (
	select top 1 Маршрут from @t where Маршрут not in (
		select Маршрут
		from @t vm
		join Маршруты m on vm.Зал = m.Номер_зала 
		join Залы z on z.Номер_зала = vm.Зал
		where DATEDIFF(mi,dateadd(mi,(Порядок-1)*10,@dt_entrance),Дата_и_время_посещения) < 10
		and DATEDIFF(mi,dateadd(mi,(Порядок-1)*10,@dt_entrance),Дата_и_время_посещения) > -10
		group by Маршрут, Зал, Вместимость 
		having Вместимость < count(*) + 1) 
	) 
	
	if @m is null
	set @dt_entrance = dateadd(mi,10,@dt_entrance) else break
end

insert Маршруты 
select @id, dateadd(mi,(Порядок-1)*10,@dt_entrance), Зал, Порядок
from @t
where Маршрут = @m

FETCH NEXT FROM SaaleCurse INTO @id
delete @t
end
deallocate SaaleCurse
end
go

use SaaleTrigger
truncate table Предпочтения
truncate table Маршруты
insert Предпочтения values
(501,10701),
(501,10801),
(501,11601),
(501,11602),
(501,11603),
(502,10701),
(502,10801),
(502,11601),
(502,11602),
(502,11603),
(503,10701),
(503,10801),
(503,11601),
(503,11602),
(503,11603),
(504,10701),
(504,10801),
(504,11601),
(504,11602),
(504,11603)
go






--IF OBJECT_ID ('Возможные_маршруты','V') IS NOT NULL
--   DROP View Возможные_маршруты;
--GO
--create view Возможные_маршруты as
--with cteq as (
--	select Номер_зала, 1 q, null bef, cast(concat(Номер_зала,'.') as varchar(200)) pth
--	from Залы zmain
--	union all
--	select zdown.Номер_зала, cteq.q + 1, cteq.Номер_зала bef
--	, cast(concat(cteq.pth,zdown.Номер_зала,'.') as varchar(200)) pth
--	from cteq join Переходы p on cteq.Номер_зала = p.Второй_зал or cteq.Номер_зала = p.Первый_зал
--	join Залы zdown on (zdown.Номер_зала = p.Второй_зал or zdown.Номер_зала = p.Первый_зал)
--	and cteq.pth not like concat('%',zdown.Номер_зала,'.%')
--) 
----select top 1 with ties *, dateadd(mi, 10*(Порядок-1), getdate()) Дата
----from
----(
--	select 
--		dense_rank() over (order by pth) as Маршрут,
--		value as Зал, 
--		ROW_NUMBER() over (partition by pth order by pth) as Порядок
--	from cteq cross apply string_split(trim('.' from pth),'.') 
--	where q = (select max(q) from cteq) 
----) omg 
----order by sum(case when Зал in (2,6,9) then Порядок else 0 end) over (partition by Маршрут)
--go

--select top 1 with ties * from Возможные_маршруты 
--order by sum(case when Зал in (2,6,9) then Порядок else 0 end) over (partition by Маршрут)




--	--if not exists (declare @dt_entrance datetime = '2023-05-03 20:51:00' select * 
--	--from ( 
--	--	select Номер_зала, 1 Номер_в_порядке_посещения, Дата_и_время_посещения from Маршруты 
--	--	union all  
--	--	select Зал, Порядок, @dt_entrance Дата from Возможные_маршруты where Маршрут = 261) m
--	--join Залы z on z.Номер_зала = m.Номер_зала 
--	--where datediff(mi,dateadd(mi,(Номер_в_порядке_посещения-1)*10,Дата_и_время_посещения),
--	--	dateadd(mi,(Номер_в_порядке_посещения-1)*10,@dt_entrance)) >= -10 
--	--and datediff(mi,dateadd(mi,(Номер_в_порядке_посещения-1)*10,Дата_и_время_посещения),
--	--	dateadd(mi,(Номер_в_порядке_посещения-1)*10,@dt_entrance)) < 10
--	--group by z.Номер_зала, Вместимость having Вместимость < count(*)) break 
	
--	--set @dt_entrance = dateadd(mi,10,@dt_entrance)

--	--declare @dt_entrance datetime = '2023-05-03 20:51:00'
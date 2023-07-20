use ДействительноПочемуБыНеДелать13ЛабуЕщёОдинРаз
go


-- Рандом


create view dbo.vRand(V) as select RAND();
go
create function dbo.getRandom(@min int, @max int)
returns int
as
begin
	return (select FLOOR(@max*V + @min) FROM dbo.vRand)
end
go


-- Задание 2 

IF OBJECT_ID ('SecondIns','TR') IS NOT NULL
   DROP TRIGGER SecondIns;
GO

create trigger SecondIns
on Объекты_строительства
after insert
as
begin

declare @ko int, @ao varchar(200)
DECLARE ccc CURSOR FAST_FORWARD FOR
    SELECT *
    FROM inserted
	order by код_объекта
open ccc
FETCH NEXT FROM ccc INTO @ko, @ao

while @@FETCH_STATUS = 0
begin
	insert into График_работы_на_объектах
	select номер_бригады, @ko as код_объекта, cast(getdate() as date) as дата_начала_строительства,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(окончание) over (partition by @ko)) 
			/ count(*) over (partition by @ko),
		getdate()) as date
	) as дата_окончания_строительства
	from 
	(
		select * 
		from 
		(
			select top 1 номер_бригады,
			'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
			from График_работы_на_объектах g
			where getdate() between дата_начала_строительства and дата_окончания_строительства
			group by номер_бригады
			order by count(код_объекта), dbo.getRandom(1,20)
		) t
		union
		select номер_бригады,''
		from Бригады bd 
		where not exists
		(
			select номер_бригады from График_работы_на_объектах gd
			where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства
		)
	) myyt

	FETCH NEXT FROM ccc INTO @ko, @ao
	end
deallocate ccc
end
go

-- Объекты
insert into Объекты_строительства 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from График_работы_на_объектах
where код_объекта > 8
order by код_объекта, номер_бригады

delete График_работы_на_объектах
where код_объекта > 8
delete Объекты_строительства
where код_объекта > 8
go



select номер_бригады, count(код_объекта) щ
			from График_работы_на_объектах g
			where getdate() between дата_начала_строительства and дата_окончания_строительства
			group by номер_бригады



IF OBJECT_ID ('CursorThough','TR') IS NOT NULL
   DROP TRIGGER CursorThough;
GO

create trigger CursorThough
on Объекты_строительства
after insert
as
begin

declare @ko int, @id int
DECLARE ccc CURSOR FAST_FORWARD FOR
    SELECT код_объекта, ROW_NUMBER() over (order by код_объекта) as id
    FROM inserted
	order by код_объекта
open ccc
FETCH NEXT FROM ccc INTO @ko, @id

while @@FETCH_STATUS = 0
	begin

		insert into График_работы_на_объектах
		select номер_бригады, @ko as код_объекта, cast(getdate() as date) as дата_начала_строительства,
		cast
		(
			dateadd(d, 
				datediff(d, getdate(), max(окончание) over (partition by @ko)) 
				/ count(*) over (partition by @ko),
			getdate()) as date
		) as дата_окончания_строительства
		from 
		(
			select * 
			from 
			(
				select top 1 номер_бригады,
				'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date),
				0 as rn
				from График_работы_на_объектах g left join inserted i on g.код_объекта = i.код_объекта
				where getdate() between дата_начала_строительства and дата_окончания_строительства and 
				номер_бригады not in (select номер_бригады from Бригады bd 
				where not exists
				(
					select номер_бригады from График_работы_на_объектах gd left join inserted i on gd.код_объекта = i.код_объекта
					where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства
					and i.код_объекта is null
				) )
				group by номер_бригады
				order by count(g.код_объекта), dbo.getRandom(1,20)
			) t
			union
			select номер_бригады,'' as o, ROW_NUMBER() over (order by номер_бригады) rn
			from Бригады bd 
			where not exists
			(
				select номер_бригады from График_работы_на_объектах gd left join inserted i on gd.код_объекта = i.код_объекта
				where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства
				and i.код_объекта is null
			) 
		) myyt where rn % (select count(*) from inserted) = @id or rn % (select count(*) from inserted) = 0

		FETCH NEXT FROM ccc INTO @ko, @id
	end
	deallocate ccc
end
go

insert into Объекты_строительства 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from График_работы_на_объектах
where код_объекта > 8
order by код_объекта, номер_бригады

delete График_работы_на_объектах
where код_объекта > 8
delete Объекты_строительства
where код_объекта > 8
go



select номер_бригады, count(код_объекта) щ
			from График_работы_на_объектах g
			where getdate() between дата_начала_строительства and дата_окончания_строительства
			group by номер_бригады






DECLARE @source_table TABLE (ID INT, ID_product INT, COUNT INT)
 
INSERT INTO @source_table (ID, ID_product, COUNT)
    VALUES (1, 12457, 7),
            (2, 11111, 3),
            (3, 22222, 4),
            (4, 33333, 1)
            
SELECT * FROM @source_table
 
;WITH cteRepeat (ID, ID_product, COUNT, lvl)
AS
(
SELECT ID, ID_product, COUNT, 1 AS lvl FROM @source_table
UNION ALL
SELECT A.ID, A.ID_product, A.count, lvl + 1
FROM @source_table AS A
    INNER JOIN cteRepeat AS B
    ON A.ID = B.ID AND A.count> B.lvl
)
SELECT * FROM cteRepeat ORDER BY ID, lvl

-------------------------------------

--IF OBJECT_ID ('SecondIns','TR') IS NOT NULL
--   DROP TRIGGER SecondIns;
--GO

--create trigger SecondIns
--on Объекты_строительства
--after insert
--as
--begin

--with help as(
--	select * 
--	from 
--	(
--		select top 1 номер_бригады,
--		'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
--		from График_работы_на_объектах g
--		where getdate() between дата_начала_строительства and дата_окончания_строительства
--		group by номер_бригады
--		order by count(код_объекта), dbo.getRandom(1,20)
--	) t
--	union
--	select номер_бригады,''
--	from Бригады bd 
--	where not exists
--	(
--		select номер_бригады from График_работы_на_объектах gd
--		where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства
--	)
--)
--select номер_бригады, код_объекта, getdate() as дата_начала_строительства,
--cast
--(
--	dateadd(d, 
--		datediff(d, getdate(), max(окончание) over (partition by начало)) 
--		/ count(*) over (partition by начало),
--	getdate()) as date
--) as дата_окончания_строительства
--from help cross join inserted
--end
--go

--IF OBJECT_ID ('Q','TR') IS NOT NULL
--   DROP TRIGGER Q;
--GO
--create trigger Q
--on Объекты_строительства
--after insert
--as
--begin
--with h as (

--	select номер_бригады, код_объекта, начало as дата_начала_строительства,
--	cast
--	(
--		dateadd(d, 
--			datediff(d, getdate(), max(окончание) over (partition by начало)) 
--			/ count(*) over (partition by начало),
--		getdate()) as date
--	) as дата_окончания_строительства
--	from 
--	(
--		select * 
--		from 
--		(
--			select top 1 номер_бригады,
--			'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)

--			from График_работы_на_объектах g
--			where getdate() between дата_начала_строительства and дата_окончания_строительства
--			group by номер_бригады
--			order by count(код_объекта), dbo.getRandom(1,20)
--		) t
--		union
--		select номер_бригады,''
--		from Бригады bd 
--		where not exists
--		(
--			select номер_бригады from График_работы_на_объектах gd
--			where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства
--		)
--	) myyt cross join (select top 1 код_объекта, 'начало' = cast(getdate() as date) from inserted order by код_объекта ) obj

--	union all
--	SELECT ir.код_объекта, CAST(SPACE(1)+ir.код_объекта AS nvarchar(300)) Name
--	FROM inserted ir
--	JOIN h cte ON ir.код_объекта = cte.код_объекта
--)
--select * from h
--end






	select top 1 номер_бригады,
	'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
	from График_работы_на_объектах g
	where getdate() between дата_начала_строительства and дата_окончания_строительства
	group by номер_бригады
	order by count(код_объекта), dbo.getRandom(1,20)

	union all

	select top 1 номер_бригады,
	'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
	from График_работы_на_объектах g
	where getdate() between дата_начала_строительства and дата_окончания_строительства
	group by номер_бригады
	order by count(код_объекта), dbo.getRandom(1,20)
)







--WITH Letters AS(
--SELECT ASCII('A') code, CHAR(ASCII('A')) letter
--UNION ALL
--SELECT code+1, CHAR(code+1) FROM Letters
--WHERE code+1 <= ASCII('Z')
--)
--SELECT letter FROM Letters;




with heh as 
(
select номер_бригады,
count(код_объекта) objs
from График_работы_на_объектах g 
where getdate() between дата_начала_строительства and дата_окончания_строительства
group by номер_бригады
)
select dense_rank() over (order by objs), 
ROW_NUMBER() over (order by objs,  dbo.getRandom(1,20)), 
номер_бригады, (select max(objs) from heh) - objs as objs, objs as old_objs
from heh
order by objs desc

with h as 
(
	select номер_бригады
	from Бригады
	union all 
)


			--SELECT код_объекта
			--from График_работы_на_объектах g
			--where getdate() between дата_начала_строительства and дата_окончания_строительства 
			--and g.номер_бригады = i.номер_бригады
			--except
			--SELECT код_объекта
			--from График_работы_на_объектах g
			--where номер_бригады = 
			--	(select r.номер_бригады from Распределение r where r.код_рабочего = i.бригадир)
			--and getdate() between дата_начала_строительства and дата_окончания_строительства






						--SELECT must.код_объекта, come.код_объекта
			--from График_работы_на_объектах must join График_работы_на_объектах come 
			--on must.код_объекта = come.код_объекта
			--where must.номер_бригады = 3
			--and come.номер_бригады = (select r.номер_бригады from Распределение r where r.код_рабочего = 1)
			--and getdate() between must.дата_начала_строительства and must.дата_окончания_строительства 
			--and getdate() between come.дата_начала_строительства and come.дата_окончания_строительства 
			--and код_объекта not in not exists 

			--where номер_бригады = 
			--	(select r.номер_бригады from Распределение r where r.код_рабочего = i.бригадир)
			--and код_объекта not in (SELECT код_объекта from График_работы_на_объектах g
			--where getdate() between дата_начала_строительства and дата_окончания_строительства 
			--and g.номер_бригады = i.номер_бригады)
			--and getdate() between дата_начала_строительства and дата_окончания_строительства












			
-- Задание 2 ||| Хорошая попытка

IF OBJECT_ID ('NoCursor','TR') IS NOT NULL
   DROP TRIGGER NoCursor;
GO

create trigger NoCursor
on Объекты_строительства
after insert as begin

declare @ko int = (select min(код_объекта) from inserted)
while @ko is not null
begin
	insert into График_работы_на_объектах
	select номер_бригады, @ko as код_объекта, cast(getdate() as date) as дата_начала_строительства,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(окончание) over (partition by @ko)) 
			/ count(*) over (partition by @ko),
		getdate()) as date
	) as дата_окончания_строительства
	from 
	(
		select * from 
		(	select top 1 номер_бригады,
			'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), 
				getdate()))as date)
			from График_работы_на_объектах g
			where getdate() between дата_начала_строительства and дата_окончания_строительства
			group by номер_бригады
			order by count(код_объекта), dbo.getRandom(1,20)  ) t
		union
		select номер_бригады,''
		from Бригады bd 
		where not exists
		(	select номер_бригады from График_работы_на_объектах gd
			where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства)
	) myyt
	
	set @ko = (select min(код_объекта) from inserted where код_объекта > @ko)
end
end
go

-- Объекты
insert into Объекты_строительства 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from График_работы_на_объектах
where код_объекта > 8
order by код_объекта, номер_бригады

delete График_работы_на_объектах
where код_объекта > 8
delete Объекты_строительства
where код_объекта > 8
go















--IF OBJECT_ID ('NoCursor','TR') IS NOT NULL
--   DROP TRIGGER NoCursor;
--GO

--create trigger NoCursor
--on Объекты_строительства
--after insert as begin

--declare @ko int = (select min(код_объекта) from inserted)
--insert into График_работы_на_объектах
--select номер_бригады, @ko as код_объекта, cast(getdate() as date) as дата_начала_строительства,
--cast
--(
--	dateadd(d, 
--		datediff(d, getdate(), max(окончание) over (partition by @ko)) 
--		/ count(*) over (partition by @ko),
--	getdate()) as date
--) as дата_окончания_строительства
--from 
--(
--	select * from 
--	(	select top 1 номер_бригады,
--		'окончание' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
--		from График_работы_на_объектах g
--		where getdate() between дата_начала_строительства and дата_окончания_строительства
--		group by номер_бригады
--		order by count(код_объекта), dbo.getRandom(1,20)  ) t
--	union
--	select номер_бригады,''
--	from Бригады bd 
--	where not exists
--	(	select номер_бригады from График_работы_на_объектах gd
--		where bd.номер_бригады = gd.номер_бригады and getdate() between дата_начала_строительства and дата_окончания_строительства)
--) myyt

--set @ko = (select min(код_объекта) from inserted where код_объекта > @ko)
--while @ko is not null
--begin
--insert into График_работы_на_объектах 
--	select top 1 номер_бригады, @ko as код_объекта, cast(getdate() as date) as дата_начала_строительства,
--	'дата_окончания_строительства' = cast((select DATEADD(d,avg(datediff(d,дата_начала_строительства,дата_окончания_строительства)), getdate()))as date)
--	from График_работы_на_объектах g
--	where getdate() between дата_начала_строительства and дата_окончания_строительства
--	group by номер_бригады
--	order by count(код_объекта), dbo.getRandom(1,20)  

--	set @ko = (select min(код_объекта) from inserted where код_объекта > @ko)
--end
--end
--go



use ДействительноПочемуБыНеДелать13ЛабуЕщёОдинРаз
go


-- Задание 1


IF OBJECT_ID ('FirstIns','TR') IS NOT NULL
   DROP TRIGGER FirstIns;
GO

create trigger FirstIns
on Бригады 
instead of insert
AS  
begin 
		insert Бригады
		select номер_бригады, профиль, 'бригадир' = null from inserted

		if exists (select * from inserted where бригадир is not null)
			RAISERROR ('Все бригадиры заменены на null', 16, 1);  
		
end
GO


IF OBJECT_ID ('FirstUpd','TR') IS NOT NULL
   DROP TRIGGER FirstUpd;
GO

create trigger FirstUpd
on Бригады 
instead of update
AS  
begin 
		update Бригады
		set бригадир = i.бригадир
		from Бригады b inner join inserted i on b.номер_бригады = i.номер_бригады
		where exists
		(
			select 1
			from График_работы_на_объектах must join График_работы_на_объектах come on must.код_объекта = come.код_объекта
			join Распределение comefrom on come.номер_бригады = comefrom.номер_бригады
			where getdate() between must.дата_начала_строительства and must.дата_окончания_строительства
			and getdate() between come.дата_начала_строительства and come.дата_окончания_строительства
			and must.номер_бригады = i.номер_бригады and i.бригадир = comefrom.код_рабочего
		)

		--where not exists
		--(
		--	SELECT код_объекта
		--	from График_работы_на_объектах g
		--	where номер_бригады = 
		--		(select r.номер_бригады from Распределение r where r.код_рабочего = i.бригадир)
		--	and код_объекта not in 
		--		(select код_объекта from График_работы_на_объектах g
		--		where getdate() between дата_начала_строительства and дата_окончания_строительства 
		--		and g.номер_бригады = i.номер_бригады)
		--	and getdate() between дата_начала_строительства and дата_окончания_строительства
		--)

		if @@ROWCOUNT != (select count(*) from inserted)
			RAISERROR ('Записи, где бригадир не соответствует условиям, не были сохранены', 16, 1); 
end
GO

-- insert
delete Бригады where номер_бригады = 7
insert Бригады values(7,'wege',7)
 
-- Из той же бригады | ЗАПИШЕТ
update Бригады
set бригадир = 2
where номер_бригады = 1

-- Из другой, но подходящей бригады | ЗАПИШЕТ
update Бригады
set бригадир = 14
where номер_бригады = 1

-- Из неподходящей бригады | НЕ ЗАПИШЕТ
update Бригады
set бригадир = 11
where номер_бригады = 1

-- Один из неподходящей бригады, один из подходящей | одну НЕ ЗАПИШЕТ, одну ЗАПИШЕТ
update Бригады 
set бригадир = 11
where номер_бригады = 2 or номер_бригады = 6

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
	select номер_бригады, код_объекта, начало as дата_начала_строительства,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(окончание) over (partition by начало)) 
			/ count(*) over (partition by начало),
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
	) myyt cross join (select @ko код_объекта, 'начало' = cast(getdate() as date)) obj

	FETCH NEXT FROM ccc INTO @ko, @ao
	end
deallocate ccc
end
go

-- Объекты
insert into Объекты_строительства 
values (9,'rfv'), (10,'rgr')

delete График_работы_на_объектах
where код_объекта > 8
delete Объекты_строительства
where код_объекта > 8






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
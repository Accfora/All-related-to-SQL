use ДействительноПочемуБыНеДелать13ЛабуЕщёОдинРаз
go

-- 1

DROP FUNCTION IF EXISTS dbo.f1
go

create function f1 (@br int)
returns int as 
begin
return
(
	select max(datediff(d,дата_начала_строительства,дата_окончания_строительства)) 
		as Количество_дней_наипродолжительнейшей_работы
	from График_работы_на_объектах
	where номер_бригады = @br
)
end
go

print dbo.f1(1)
print dbo.f1(2)

-- 2

DROP FUNCTION IF EXISTS dbo.f2
go

create function f2 ()
returns table as 
return
(
	select код_объекта
	from График_работы_на_объектах 
	group by код_объекта
	having count(номер_бригады) = 1
)
go

select * from dbo.f2()

-- 3

DROP FUNCTION IF EXISTS dbo.f3
go

create function f3 ()
returns @table table
(
	номер_бригады int NOT NULL,
	код_объекта int NOT NULL,
	дата_начала_строительства date NOT NULL,
	дата_окончания_строительства date NOT NULL,
	primary key (номер_бригады, код_объекта)
)
AS
BEGIN
insert @table 
select номер_бригады, код_объекта, дата_начала_строительства,
case when 
(
	select count(код_рабочего) as Количество_рабочих
	from Распределение
	where номер_бригады = g.номер_бригады
	group by номер_бригады
) < 5 
then dateadd(d, datediff(d,дата_начала_строительства, дата_окончания_строительства),дата_окончания_строительства)
else дата_окончания_строительства end as дата_окончания_строительства
from График_работы_на_объектах g
return
END
go

select номер_бригады, код_объекта, дата_начала_строительства, дата_окончания_строительства from График_работы_на_объектах
select номер_бригады, count(код_рабочего) as Количество_рабочих from Распределение group by номер_бригады

select * from dbo.f3()
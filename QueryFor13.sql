use Практ_1
go

--- 1

DROP FUNCTION IF EXISTS dbo.f1
go

create function f1 (@idKaf int)
returns int as 
begin
DECLARE @result INT =
(SELECT count(Таблица_Преподаватели0.код_преподавателя) 
FROM Таблица_Преподаватели0
WHERE номер_кафедры = @idKaf)
RETURN @result
END;
go

print dbo.f1(14)

--- 2

DROP FUNCTION IF EXISTS dbo.f2
go

create function f2 ()
returns table as 
return
(
	select номер_аудитории
	from Расписание
	group by номер_аудитории
	having count(номер_аудитории) = (select max(k) from (select count(номер_аудитории) k from Расписание group by номер_аудитории) p)
)
go

select * from dbo.f2()

--- 3

DROP FUNCTION IF EXISTS dbo.f3
go

create function f3 ()
returns @table table (День_недели varchar(15) not null,
Номер_пары int not null,
Код_преподавателя int not null,
Код_дисциплины int not null,
Номер_группы varchar(15) not null,
Номер_аудитории int not null)
AS
BEGIN
INSERT INTO @table 
select День_недели, Номер_пары, Код_преподавателя, Код_дисциплины, Номер_группы, Номер_аудитории 
from
(
	select *, count(Код_преподавателя) over (partition by Код_дисциплины,
	Номер_группы order by день_недели,номер_группы, код_дисциплины,
	номер_пары,код_преподавателя) as u
	from Расписание 
) as k
where u = 1
RETURN
END;
go

select * from dbo.f3()
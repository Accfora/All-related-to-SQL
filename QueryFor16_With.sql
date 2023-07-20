use �����������������������������13��������������
go


-- ������


create view dbo.vRand(V) as select RAND();
go
create function dbo.getRandom(@min int, @max int)
returns int
as
begin
	return (select FLOOR(@max*V + @min) FROM dbo.vRand)
end
go


-- ������� 2 

IF OBJECT_ID ('SecondIns','TR') IS NOT NULL
   DROP TRIGGER SecondIns;
GO

create trigger SecondIns
on �������_�������������
after insert
as
begin

declare @ko int, @ao varchar(200)
DECLARE ccc CURSOR FAST_FORWARD FOR
    SELECT *
    FROM inserted
	order by ���_�������
open ccc
FETCH NEXT FROM ccc INTO @ko, @ao

while @@FETCH_STATUS = 0
begin
	insert into ������_������_��_��������
	select �����_�������, @ko as ���_�������, cast(getdate() as date) as ����_������_�������������,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(���������) over (partition by @ko)) 
			/ count(*) over (partition by @ko),
		getdate()) as date
	) as ����_���������_�������������
	from 
	(
		select * 
		from 
		(
			select top 1 �����_�������,
			'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
			from ������_������_��_�������� g
			where getdate() between ����_������_������������� and ����_���������_�������������
			group by �����_�������
			order by count(���_�������), dbo.getRandom(1,20)
		) t
		union
		select �����_�������,''
		from ������� bd 
		where not exists
		(
			select �����_������� from ������_������_��_�������� gd
			where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������
		)
	) myyt

	FETCH NEXT FROM ccc INTO @ko, @ao
	end
deallocate ccc
end
go

-- �������
insert into �������_������������� 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from ������_������_��_��������
where ���_������� > 8
order by ���_�������, �����_�������

delete ������_������_��_��������
where ���_������� > 8
delete �������_�������������
where ���_������� > 8
go



select �����_�������, count(���_�������) �
			from ������_������_��_�������� g
			where getdate() between ����_������_������������� and ����_���������_�������������
			group by �����_�������



IF OBJECT_ID ('CursorThough','TR') IS NOT NULL
   DROP TRIGGER CursorThough;
GO

create trigger CursorThough
on �������_�������������
after insert
as
begin

declare @ko int, @id int
DECLARE ccc CURSOR FAST_FORWARD FOR
    SELECT ���_�������, ROW_NUMBER() over (order by ���_�������) as id
    FROM inserted
	order by ���_�������
open ccc
FETCH NEXT FROM ccc INTO @ko, @id

while @@FETCH_STATUS = 0
	begin

		insert into ������_������_��_��������
		select �����_�������, @ko as ���_�������, cast(getdate() as date) as ����_������_�������������,
		cast
		(
			dateadd(d, 
				datediff(d, getdate(), max(���������) over (partition by @ko)) 
				/ count(*) over (partition by @ko),
			getdate()) as date
		) as ����_���������_�������������
		from 
		(
			select * 
			from 
			(
				select top 1 �����_�������,
				'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date),
				0 as rn
				from ������_������_��_�������� g left join inserted i on g.���_������� = i.���_�������
				where getdate() between ����_������_������������� and ����_���������_������������� and 
				�����_������� not in (select �����_������� from ������� bd 
				where not exists
				(
					select �����_������� from ������_������_��_�������� gd left join inserted i on gd.���_������� = i.���_�������
					where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������
					and i.���_������� is null
				) )
				group by �����_�������
				order by count(g.���_�������), dbo.getRandom(1,20)
			) t
			union
			select �����_�������,'' as o, ROW_NUMBER() over (order by �����_�������) rn
			from ������� bd 
			where not exists
			(
				select �����_������� from ������_������_��_�������� gd left join inserted i on gd.���_������� = i.���_�������
				where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������
				and i.���_������� is null
			) 
		) myyt where rn % (select count(*) from inserted) = @id or rn % (select count(*) from inserted) = 0

		FETCH NEXT FROM ccc INTO @ko, @id
	end
	deallocate ccc
end
go

insert into �������_������������� 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from ������_������_��_��������
where ���_������� > 8
order by ���_�������, �����_�������

delete ������_������_��_��������
where ���_������� > 8
delete �������_�������������
where ���_������� > 8
go



select �����_�������, count(���_�������) �
			from ������_������_��_�������� g
			where getdate() between ����_������_������������� and ����_���������_�������������
			group by �����_�������






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
--on �������_�������������
--after insert
--as
--begin

--with help as(
--	select * 
--	from 
--	(
--		select top 1 �����_�������,
--		'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
--		from ������_������_��_�������� g
--		where getdate() between ����_������_������������� and ����_���������_�������������
--		group by �����_�������
--		order by count(���_�������), dbo.getRandom(1,20)
--	) t
--	union
--	select �����_�������,''
--	from ������� bd 
--	where not exists
--	(
--		select �����_������� from ������_������_��_�������� gd
--		where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������
--	)
--)
--select �����_�������, ���_�������, getdate() as ����_������_�������������,
--cast
--(
--	dateadd(d, 
--		datediff(d, getdate(), max(���������) over (partition by ������)) 
--		/ count(*) over (partition by ������),
--	getdate()) as date
--) as ����_���������_�������������
--from help cross join inserted
--end
--go

--IF OBJECT_ID ('Q','TR') IS NOT NULL
--   DROP TRIGGER Q;
--GO
--create trigger Q
--on �������_�������������
--after insert
--as
--begin
--with h as (

--	select �����_�������, ���_�������, ������ as ����_������_�������������,
--	cast
--	(
--		dateadd(d, 
--			datediff(d, getdate(), max(���������) over (partition by ������)) 
--			/ count(*) over (partition by ������),
--		getdate()) as date
--	) as ����_���������_�������������
--	from 
--	(
--		select * 
--		from 
--		(
--			select top 1 �����_�������,
--			'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)

--			from ������_������_��_�������� g
--			where getdate() between ����_������_������������� and ����_���������_�������������
--			group by �����_�������
--			order by count(���_�������), dbo.getRandom(1,20)
--		) t
--		union
--		select �����_�������,''
--		from ������� bd 
--		where not exists
--		(
--			select �����_������� from ������_������_��_�������� gd
--			where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������
--		)
--	) myyt cross join (select top 1 ���_�������, '������' = cast(getdate() as date) from inserted order by ���_������� ) obj

--	union all
--	SELECT ir.���_�������, CAST(SPACE(1)+ir.���_������� AS nvarchar(300)) Name
--	FROM inserted ir
--	JOIN h cte ON ir.���_������� = cte.���_�������
--)
--select * from h
--end






	select top 1 �����_�������,
	'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
	from ������_������_��_�������� g
	where getdate() between ����_������_������������� and ����_���������_�������������
	group by �����_�������
	order by count(���_�������), dbo.getRandom(1,20)

	union all

	select top 1 �����_�������,
	'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
	from ������_������_��_�������� g
	where getdate() between ����_������_������������� and ����_���������_�������������
	group by �����_�������
	order by count(���_�������), dbo.getRandom(1,20)
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
select �����_�������,
count(���_�������) objs
from ������_������_��_�������� g 
where getdate() between ����_������_������������� and ����_���������_�������������
group by �����_�������
)
select dense_rank() over (order by objs), 
ROW_NUMBER() over (order by objs,  dbo.getRandom(1,20)), 
�����_�������, (select max(objs) from heh) - objs as objs, objs as old_objs
from heh
order by objs desc

with h as 
(
	select �����_�������
	from �������
	union all 
)


			--SELECT ���_�������
			--from ������_������_��_�������� g
			--where getdate() between ����_������_������������� and ����_���������_������������� 
			--and g.�����_������� = i.�����_�������
			--except
			--SELECT ���_�������
			--from ������_������_��_�������� g
			--where �����_������� = 
			--	(select r.�����_������� from ������������� r where r.���_�������� = i.��������)
			--and getdate() between ����_������_������������� and ����_���������_�������������






						--SELECT must.���_�������, come.���_�������
			--from ������_������_��_�������� must join ������_������_��_�������� come 
			--on must.���_������� = come.���_�������
			--where must.�����_������� = 3
			--and come.�����_������� = (select r.�����_������� from ������������� r where r.���_�������� = 1)
			--and getdate() between must.����_������_������������� and must.����_���������_������������� 
			--and getdate() between come.����_������_������������� and come.����_���������_������������� 
			--and ���_������� not in not exists 

			--where �����_������� = 
			--	(select r.�����_������� from ������������� r where r.���_�������� = i.��������)
			--and ���_������� not in (SELECT ���_������� from ������_������_��_�������� g
			--where getdate() between ����_������_������������� and ����_���������_������������� 
			--and g.�����_������� = i.�����_�������)
			--and getdate() between ����_������_������������� and ����_���������_�������������












			
-- ������� 2 ||| ������� �������

IF OBJECT_ID ('NoCursor','TR') IS NOT NULL
   DROP TRIGGER NoCursor;
GO

create trigger NoCursor
on �������_�������������
after insert as begin

declare @ko int = (select min(���_�������) from inserted)
while @ko is not null
begin
	insert into ������_������_��_��������
	select �����_�������, @ko as ���_�������, cast(getdate() as date) as ����_������_�������������,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(���������) over (partition by @ko)) 
			/ count(*) over (partition by @ko),
		getdate()) as date
	) as ����_���������_�������������
	from 
	(
		select * from 
		(	select top 1 �����_�������,
			'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), 
				getdate()))as date)
			from ������_������_��_�������� g
			where getdate() between ����_������_������������� and ����_���������_�������������
			group by �����_�������
			order by count(���_�������), dbo.getRandom(1,20)  ) t
		union
		select �����_�������,''
		from ������� bd 
		where not exists
		(	select �����_������� from ������_������_��_�������� gd
			where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������)
	) myyt
	
	set @ko = (select min(���_�������) from inserted where ���_������� > @ko)
end
end
go

-- �������
insert into �������_������������� 
values (9,'rfv'), (10,'rgr'), (11,'rfv'), (12,'rgr'), (13,'rfv'), (14,'rgr'), (15,'rgr')

select * 
from ������_������_��_��������
where ���_������� > 8
order by ���_�������, �����_�������

delete ������_������_��_��������
where ���_������� > 8
delete �������_�������������
where ���_������� > 8
go















--IF OBJECT_ID ('NoCursor','TR') IS NOT NULL
--   DROP TRIGGER NoCursor;
--GO

--create trigger NoCursor
--on �������_�������������
--after insert as begin

--declare @ko int = (select min(���_�������) from inserted)
--insert into ������_������_��_��������
--select �����_�������, @ko as ���_�������, cast(getdate() as date) as ����_������_�������������,
--cast
--(
--	dateadd(d, 
--		datediff(d, getdate(), max(���������) over (partition by @ko)) 
--		/ count(*) over (partition by @ko),
--	getdate()) as date
--) as ����_���������_�������������
--from 
--(
--	select * from 
--	(	select top 1 �����_�������,
--		'���������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
--		from ������_������_��_�������� g
--		where getdate() between ����_������_������������� and ����_���������_�������������
--		group by �����_�������
--		order by count(���_�������), dbo.getRandom(1,20)  ) t
--	union
--	select �����_�������,''
--	from ������� bd 
--	where not exists
--	(	select �����_������� from ������_������_��_�������� gd
--		where bd.�����_������� = gd.�����_������� and getdate() between ����_������_������������� and ����_���������_�������������)
--) myyt

--set @ko = (select min(���_�������) from inserted where ���_������� > @ko)
--while @ko is not null
--begin
--insert into ������_������_��_�������� 
--	select top 1 �����_�������, @ko as ���_�������, cast(getdate() as date) as ����_������_�������������,
--	'����_���������_�������������' = cast((select DATEADD(d,avg(datediff(d,����_������_�������������,����_���������_�������������)), getdate()))as date)
--	from ������_������_��_�������� g
--	where getdate() between ����_������_������������� and ����_���������_�������������
--	group by �����_�������
--	order by count(���_�������), dbo.getRandom(1,20)  

--	set @ko = (select min(���_�������) from inserted where ���_������� > @ko)
--end
--end
--go



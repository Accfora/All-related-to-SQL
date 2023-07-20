use �����������������������������13��������������
go


-- ������� 1


IF OBJECT_ID ('FirstIns','TR') IS NOT NULL
   DROP TRIGGER FirstIns;
GO

create trigger FirstIns
on ������� 
instead of insert
AS  
begin 
		insert �������
		select �����_�������, �������, '��������' = null from inserted

		if exists (select * from inserted where �������� is not null)
			RAISERROR ('��� ��������� �������� �� null', 16, 1);  
		
end
GO


IF OBJECT_ID ('FirstUpd','TR') IS NOT NULL
   DROP TRIGGER FirstUpd;
GO

create trigger FirstUpd
on ������� 
instead of update
AS  
begin 
		update �������
		set �������� = i.��������
		from ������� b inner join inserted i on b.�����_������� = i.�����_�������
		where exists
		(
			select 1
			from ������_������_��_�������� must join ������_������_��_�������� come on must.���_������� = come.���_�������
			join ������������� comefrom on come.�����_������� = comefrom.�����_�������
			where getdate() between must.����_������_������������� and must.����_���������_�������������
			and getdate() between come.����_������_������������� and come.����_���������_�������������
			and must.�����_������� = i.�����_������� and i.�������� = comefrom.���_��������
		)

		--where not exists
		--(
		--	SELECT ���_�������
		--	from ������_������_��_�������� g
		--	where �����_������� = 
		--		(select r.�����_������� from ������������� r where r.���_�������� = i.��������)
		--	and ���_������� not in 
		--		(select ���_������� from ������_������_��_�������� g
		--		where getdate() between ����_������_������������� and ����_���������_������������� 
		--		and g.�����_������� = i.�����_�������)
		--	and getdate() between ����_������_������������� and ����_���������_�������������
		--)

		if @@ROWCOUNT != (select count(*) from inserted)
			RAISERROR ('������, ��� �������� �� ������������� ��������, �� ���� ���������', 16, 1); 
end
GO

-- insert
delete ������� where �����_������� = 7
insert ������� values(7,'wege',7)
 
-- �� ��� �� ������� | �������
update �������
set �������� = 2
where �����_������� = 1

-- �� ������, �� ���������� ������� | �������
update �������
set �������� = 14
where �����_������� = 1

-- �� ������������ ������� | �� �������
update �������
set �������� = 11
where �����_������� = 1

-- ���� �� ������������ �������, ���� �� ���������� | ���� �� �������, ���� �������
update ������� 
set �������� = 11
where �����_������� = 2 or �����_������� = 6

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
	select �����_�������, ���_�������, ������ as ����_������_�������������,
	cast
	(
		dateadd(d, 
			datediff(d, getdate(), max(���������) over (partition by ������)) 
			/ count(*) over (partition by ������),
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
	) myyt cross join (select @ko ���_�������, '������' = cast(getdate() as date)) obj

	FETCH NEXT FROM ccc INTO @ko, @ao
	end
deallocate ccc
end
go

-- �������
insert into �������_������������� 
values (9,'rfv'), (10,'rgr')

delete ������_������_��_��������
where ���_������� > 8
delete �������_�������������
where ���_������� > 8






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
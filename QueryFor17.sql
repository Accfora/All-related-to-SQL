use SaaleTrigger
go

IF OBJECT_ID ('Saale','TR') IS NOT NULL
   DROP TRIGGER Saale;
GO

create trigger Saale
on ������������
after insert
as
begin

declare @id int
DECLARE SaaleCurse CURSOR FAST_FORWARD FOR
    SELECT distinct ���_����������
    FROM inserted
open SaaleCurse
FETCH NEXT FROM SaaleCurse INTO @id
while @@FETCH_STATUS = 0
begin

--declare @dt_entrance datetime = getdate()
declare @dt_entrance datetime = '2023-05-03 20:51:00', @m int = null
declare @t table (������� int, ��� int, ������� int);
with cteq as (
	select �����_����, 1 q, null bef, cast(concat(�����_����,'.') as varchar(200)) pth
	from ���� zmain
	union all
	select zdown.�����_����, cteq.q + 1, cteq.�����_���� bef
	, cast(concat(cteq.pth,zdown.�����_����,'.') as varchar(200)) pth
	from cteq join �������� p on cteq.�����_���� = p.������_��� or cteq.�����_���� = p.������_���
	join ���� zdown on (zdown.�����_���� = p.������_��� or zdown.�����_���� = p.������_���)
	and cteq.pth not like concat('%',zdown.�����_����,'.%')
) 
insert @t 
select top 1 with ties *
from
(
	select 
		dense_rank() over (order by pth) as �������,
		value as ���, 
		ROW_NUMBER() over (partition by pth order by pth) as �������
	from cteq cross apply string_split(trim('.' from pth),'.') 
	where q = (select max(q) from cteq) 
) omg 
order by sum(case when ��� in 
(select distinct �����_���� from inserted i 
join ���������� e on e.�������� = i.�������� where ���_���������� = @id) 
then ������� else 0 end) over (partition by �������)

while 1 = 1
begin
	set @m = (
	select top 1 ������� from @t where ������� not in (
		select �������
		from @t vm
		join �������� m on vm.��� = m.�����_���� 
		join ���� z on z.�����_���� = vm.���
		where DATEDIFF(mi,dateadd(mi,(�������-1)*10,@dt_entrance),����_�_�����_���������) < 10
		and DATEDIFF(mi,dateadd(mi,(�������-1)*10,@dt_entrance),����_�_�����_���������) > -10
		group by �������, ���, ����������� 
		having ����������� < count(*) + 1) 
	) 
	
	if @m is null
	set @dt_entrance = dateadd(mi,10,@dt_entrance) else break
end

insert �������� 
select @id, dateadd(mi,(�������-1)*10,@dt_entrance), ���, �������
from @t
where ������� = @m

FETCH NEXT FROM SaaleCurse INTO @id
delete @t
end
deallocate SaaleCurse
end
go

use SaaleTrigger
truncate table ������������
truncate table ��������
insert ������������ values
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






--IF OBJECT_ID ('���������_��������','V') IS NOT NULL
--   DROP View ���������_��������;
--GO
--create view ���������_�������� as
--with cteq as (
--	select �����_����, 1 q, null bef, cast(concat(�����_����,'.') as varchar(200)) pth
--	from ���� zmain
--	union all
--	select zdown.�����_����, cteq.q + 1, cteq.�����_���� bef
--	, cast(concat(cteq.pth,zdown.�����_����,'.') as varchar(200)) pth
--	from cteq join �������� p on cteq.�����_���� = p.������_��� or cteq.�����_���� = p.������_���
--	join ���� zdown on (zdown.�����_���� = p.������_��� or zdown.�����_���� = p.������_���)
--	and cteq.pth not like concat('%',zdown.�����_����,'.%')
--) 
----select top 1 with ties *, dateadd(mi, 10*(�������-1), getdate()) ����
----from
----(
--	select 
--		dense_rank() over (order by pth) as �������,
--		value as ���, 
--		ROW_NUMBER() over (partition by pth order by pth) as �������
--	from cteq cross apply string_split(trim('.' from pth),'.') 
--	where q = (select max(q) from cteq) 
----) omg 
----order by sum(case when ��� in (2,6,9) then ������� else 0 end) over (partition by �������)
--go

--select top 1 with ties * from ���������_�������� 
--order by sum(case when ��� in (2,6,9) then ������� else 0 end) over (partition by �������)




--	--if not exists (declare @dt_entrance datetime = '2023-05-03 20:51:00' select * 
--	--from ( 
--	--	select �����_����, 1 �����_�_�������_���������, ����_�_�����_��������� from �������� 
--	--	union all  
--	--	select ���, �������, @dt_entrance ���� from ���������_�������� where ������� = 261) m
--	--join ���� z on z.�����_���� = m.�����_���� 
--	--where datediff(mi,dateadd(mi,(�����_�_�������_���������-1)*10,����_�_�����_���������),
--	--	dateadd(mi,(�����_�_�������_���������-1)*10,@dt_entrance)) >= -10 
--	--and datediff(mi,dateadd(mi,(�����_�_�������_���������-1)*10,����_�_�����_���������),
--	--	dateadd(mi,(�����_�_�������_���������-1)*10,@dt_entrance)) < 10
--	--group by z.�����_����, ����������� having ����������� < count(*)) break 
	
--	--set @dt_entrance = dateadd(mi,10,@dt_entrance)

--	--declare @dt_entrance datetime = '2023-05-03 20:51:00'
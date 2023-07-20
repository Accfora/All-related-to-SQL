use �����������������������������13��������������
go

-- 1

DROP FUNCTION IF EXISTS dbo.f1
go

create function f1 (@br int)
returns int as 
begin
return
(
	select max(datediff(d,����_������_�������������,����_���������_�������������)) 
		as ����������_����_���������������������_������
	from ������_������_��_��������
	where �����_������� = @br
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
	select ���_�������
	from ������_������_��_�������� 
	group by ���_�������
	having count(�����_�������) = 1
)
go

select * from dbo.f2()

-- 3

DROP FUNCTION IF EXISTS dbo.f3
go

create function f3 ()
returns @table table
(
	�����_������� int NOT NULL,
	���_������� int NOT NULL,
	����_������_������������� date NOT NULL,
	����_���������_������������� date NOT NULL,
	primary key (�����_�������, ���_�������)
)
AS
BEGIN
insert @table 
select �����_�������, ���_�������, ����_������_�������������,
case when 
(
	select count(���_��������) as ����������_�������
	from �������������
	where �����_������� = g.�����_�������
	group by �����_�������
) < 5 
then dateadd(d, datediff(d,����_������_�������������, ����_���������_�������������),����_���������_�������������)
else ����_���������_������������� end as ����_���������_�������������
from ������_������_��_�������� g
return
END
go

select �����_�������, ���_�������, ����_������_�������������, ����_���������_������������� from ������_������_��_��������
select �����_�������, count(���_��������) as ����������_������� from ������������� group by �����_�������

select * from dbo.f3()
use �����_1
go

--- 1

DROP FUNCTION IF EXISTS dbo.f1
go

create function f1 (@idKaf int)
returns int as 
begin
DECLARE @result INT =
(SELECT count(�������_�������������0.���_�������������) 
FROM �������_�������������0
WHERE �����_������� = @idKaf)
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
	select �����_���������
	from ����������
	group by �����_���������
	having count(�����_���������) = (select max(k) from (select count(�����_���������) k from ���������� group by �����_���������) p)
)
go

select * from dbo.f2()

--- 3

DROP FUNCTION IF EXISTS dbo.f3
go

create function f3 ()
returns @table table (����_������ varchar(15) not null,
�����_���� int not null,
���_������������� int not null,
���_���������� int not null,
�����_������ varchar(15) not null,
�����_��������� int not null)
AS
BEGIN
INSERT INTO @table 
select ����_������, �����_����, ���_�������������, ���_����������, �����_������, �����_��������� 
from
(
	select *, count(���_�������������) over (partition by ���_����������,
	�����_������ order by ����_������,�����_������, ���_����������,
	�����_����,���_�������������) as u
	from ���������� 
) as k
where u = 1
RETURN
END;
go

select * from dbo.f3()
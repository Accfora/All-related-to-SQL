use �����������������������������13��������������
go

if object_id ( '�������_���_�������_�����_�����������_��_������', 'P' ) is not null
drop procedure �������_���_�������_�����_�����������_��_������
go

create procedure �������_���_�������_�����_�����������_��_������
	@city varchar(50)
as
select distinct �����_������� from ������_������_��_�������� q join �������_������������� w
on q.���_������� = w.���_������� where w.�����_������� like '%'+@city+'%'
and �����_������� not in
(
	select distinct �����_������� from ������_������_��_�������� g1
	where exists 
	(
	
			select g2.�����_������� from
			������_������_��_�������� g2 join �������_������������� oo on oo.���_������� = g2.���_�������
			where oo.�����_������� like '%'+@city+'%'
		
		and g1.�����_������� = g2.�����_�������
		and datediff(d, g2.����_������_�������������, g2.����_���������_�������������) >=
		datediff(d, g1.����_������_�������������, g1.����_���������_�������������)
		and g2.����_������_������������� > g1.����_������_�������������
	)
)
go

exec �������_���_�������_�����_�����������_��_������ '������'
exec �������_���_�������_�����_�����������_��_������ '�����'
exec �������_���_�������_�����_�����������_��_������ '�������'


--select * from ������_������_��_��������

--declare @city varchar(50) = '������'
--select distinct �����_������� from ������_������_��_�������� g1
--where exists 
--(
--	select g2.�����_������� from 
--	(
--	select gg.�����_�������, gg.���_�������, gg.����_������_�������������, gg.����_���������_������������� from
--	������_������_��_�������� gg join �������_������������� oo on oo.���_������� = gg.���_�������
--	where oo.�����_������� like '%'+@city+'%'
--	) g2
--	where g1.�����_������� = g2.�����_�������
--	and datediff(d, g2.����_������_�������������, g2.����_���������_�������������) >=
--	datediff(d, g1.����_������_�������������, g1.����_���������_�������������)
--	and g2.����_������_������������� > g1.����_������_�������������
--)




--select datediff(d, g2.����_������_�������������, g2.����_���������_�������������) 
--- datediff(d, g1.����_������_�������������, g1.����_���������_�������������), *
--from ������_������_��_�������� g1 join ������_������_��_�������� g2 on g1.�����_������� = g2.�����_�������
--join ��
--where g1.�����_������� = 1
--and g2.����_������_������������� > g1.����_������_�������������
--and 
use �����������������������������13��������������
go

declare curs cursor for
select ���_��������, �������, ���_�������, ������_�����, �����_����� from
(
	select ROW_NUMBER() over (partition by dates1._b, dates1._d order by g.���_�������) rn, 
	dates1._b �������, g.���_�������, dates1._d ������_�����, dates2._d �����_�����
	from 
	(
		select ROW_NUMBER() over (partition by _b order by _d) rc, * from 
		(
			select g.����_������_������������� _d, g.�����_������� _b, _w = 1
			from ������_������_��_�������� g
			union
			select g.����_���������_������������� _d, g.�����_������� _b, _w = 0
			from ������_������_��_�������� g
			order by _d offset 0 rows
		) uds
	) dates1 join 
	(
		select ROW_NUMBER() over (partition by _b order by _d) rc, * from 
		(
			select g.����_������_������������� _d, g.�����_������� _b, _w = 1
			from ������_������_��_�������� g
			union
			select g.����_���������_������������� _d, g.�����_������� _b, _w = 0
			from ������_������_��_�������� g
			order by _d offset 0 rows
		) uds
	) dates2 on dates1.rc + 1 = dates2.rc and dates1._b = dates2._b and not (dates1._w = 0 and dates2._w = 1)
	join (select * from ������_������_��_��������) g 
		on g.�����_������� = dates1._b
		and (����_������_������������� = dates1._d or ����_���������_������������� = dates2._d
		or ����_������_������������� < dates1._d and ����_���������_������������� > dates2._d)
) h
join (select ROW_NUMBER() over (partition by �����_������� order by ���_��������) rc, * from �������������) r 
	on h.������� = r.�����_�������
where h.rn - 1 = r.rc %
(
	select count(*) from ������_������_��_�������� g
	where (����_������_������������� = h.������_����� or ����_���������_������������� = �����_�����
	or ����_������_������������� < h.������_����� and ����_���������_������������� > �����_�����)
	and g.�����_������� = r.�����_�������
)
order by �������, ������_�����, rn
open curs

declare @q1 int, @q2 int, @q3 int, @q4 date, @q5 date
declare @t table
(
	���_�������� int, 
	������� int, 
	���_������� int, 
	������_����� date, 
	�����_����� date
)
fetch next from curs into @q1, @q2, @q3, @q4, @q5
insert into @t values (@q1, @q2, @q3, @q4, @q5)
while @@FETCH_STATUS = 0
begin
	fetch next from curs into @q1, @q2, @q3, @q4, @q5
	insert into @t values (@q1, @q2, @q3, @q4, @q5)
end
select * from @t

close curs
deallocate curs




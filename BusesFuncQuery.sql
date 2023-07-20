--create view dbo.vRand(V) as select RAND();

--alter function dbo.getRandom(@min int, @max int)
--returns int
--as
--begin
--	return (select FLOOR(@max*V + @min) FROM dbo.vRand)
--end

alter function dbo.func (@numbmarsh integer, @uppertime time, @lowertime time)
returns @rettable table
(
	���_����� int primary key not null,
	��������� varchar(10) not null
)
as 
begin
insert @rettable
select top 3 * from
(
	select ���_�����, '���������' =
	case when datediff	
	(mi,r1.�����_�����������,
		(
			select min(r2.�����_�����������) 
			from Raspisanie r2 where r2.�����_����������� > r1.�����_�����������
			and r2.�����_�������� = r1.�����_��������
		) 
	) < 10 then '��' else '����' end
	from Raspisanie r1
	where �����_�������� = @numbmarsh and �����_����������� between @uppertime and @lowertime
) q
where ��������� = '��'
order by (select dbo.getRandom(1,22))

if @@ROWCOUNT = 0
begin
	insert into @rettable select top 3 ���_�����, '����' from Raspisanie 
	where �����_�������� = @numbmarsh and �����_����������� between @uppertime and @lowertime
	order by ���_����� 
end

return
end
go

select * from dbo.func(1,'7:00:00','13:30:00')
select * from dbo.func(2,'7:00:00','13:30:00')
select * from dbo.func(3,'7:00:00','13:30:00')
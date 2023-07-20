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
	Код_рейса int primary key not null,
	Удобность varchar(10) not null
)
as 
begin
insert @rettable
select top 3 * from
(
	select Код_рейса, 'Удобность' =
	case when datediff	
	(mi,r1.Время_отправления,
		(
			select min(r2.Время_отправления) 
			from Raspisanie r2 where r2.Время_отправления > r1.Время_отправления
			and r2.Номер_маршрута = r1.Номер_маршрута
		) 
	) < 10 then 'уд' else 'неуд' end
	from Raspisanie r1
	where Номер_маршрута = @numbmarsh and Время_отправления between @uppertime and @lowertime
) q
where Удобность = 'уд'
order by (select dbo.getRandom(1,22))

if @@ROWCOUNT = 0
begin
	insert into @rettable select top 3 Код_рейса, 'неуд' from Raspisanie 
	where Номер_маршрута = @numbmarsh and Время_отправления between @uppertime and @lowertime
	order by Код_рейса 
end

return
end
go

select * from dbo.func(1,'7:00:00','13:30:00')
select * from dbo.func(2,'7:00:00','13:30:00')
select * from dbo.func(3,'7:00:00','13:30:00')
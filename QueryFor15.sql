use ƒействительноѕочемуЅыЌеƒелать13Ћабу≈щЄќдин–аз
go

declare curs cursor for
select код_рабочего, бригада, код_объекта, начало_работ, конец_работ from
(
	select ROW_NUMBER() over (partition by dates1._b, dates1._d order by g.код_объекта) rn, 
	dates1._b бригада, g.код_объекта, dates1._d начало_работ, dates2._d конец_работ
	from 
	(
		select ROW_NUMBER() over (partition by _b order by _d) rc, * from 
		(
			select g.дата_начала_строительства _d, g.номер_бригады _b, _w = 1
			from √рафик_работы_на_объектах g
			union
			select g.дата_окончани€_строительства _d, g.номер_бригады _b, _w = 0
			from √рафик_работы_на_объектах g
			order by _d offset 0 rows
		) uds
	) dates1 join 
	(
		select ROW_NUMBER() over (partition by _b order by _d) rc, * from 
		(
			select g.дата_начала_строительства _d, g.номер_бригады _b, _w = 1
			from √рафик_работы_на_объектах g
			union
			select g.дата_окончани€_строительства _d, g.номер_бригады _b, _w = 0
			from √рафик_работы_на_объектах g
			order by _d offset 0 rows
		) uds
	) dates2 on dates1.rc + 1 = dates2.rc and dates1._b = dates2._b and not (dates1._w = 0 and dates2._w = 1)
	join (select * from √рафик_работы_на_объектах) g 
		on g.номер_бригады = dates1._b
		and (дата_начала_строительства = dates1._d or дата_окончани€_строительства = dates2._d
		or дата_начала_строительства < dates1._d and дата_окончани€_строительства > dates2._d)
) h
join (select ROW_NUMBER() over (partition by номер_бригады order by код_рабочего) rc, * from –аспределение) r 
	on h.бригада = r.номер_бригады
where h.rn - 1 = r.rc %
(
	select count(*) from √рафик_работы_на_объектах g
	where (дата_начала_строительства = h.начало_работ or дата_окончани€_строительства = конец_работ
	or дата_начала_строительства < h.начало_работ and дата_окончани€_строительства > конец_работ)
	and g.номер_бригады = r.номер_бригады
)
order by бригада, начало_работ, rn
open curs

declare @q1 int, @q2 int, @q3 int, @q4 date, @q5 date
declare @t table
(
	код_рабочего int, 
	бригада int, 
	код_объекта int, 
	начало_работ date, 
	конец_работ date
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




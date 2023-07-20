use Uzhe18
go


drop trigger Turkiye
go
create trigger Turkiye
on Операции_с_посылками
instead of INSERT
as
begin
	if @@ROWCOUNT = 0 return
	declare curs cursor for select * from inserted open curs
	declare @cpos int, @coper int, @nazv varchar(50), @dprie date, @priotd int, @dotpr date, @otdnazn int, @otpr bit
	fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr
	while @@FETCH_STATUS = 0
	begin
		if @coper = 1 and @priotd <> (select начальный_пункт from Посылки p where код_посылки = @cpos)
		begin print concat('КРИТЕРИЙ 1 не пропустил строку (',@cpos,'.',@coper,')')
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if @coper <> 1 and not exists (select * from Операции_с_посылками o where @priotd = o.отделение_назначения 
		and o.код_посылки = @cpos and o.код_операции = @coper - 1)
		begin print concat('КРИТЕРИЙ 2 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end
		
		if @coper <> 1 and not exists (select * from Операции_с_посылками o 
		where o.отправлено = 1 and o.код_посылки = @cpos and o.код_операции = @coper - 1)
		begin print concat('КРИТЕРИЙ 3 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from Операции_с_посылками o2 
		where @cpos = o2.код_посылки and @priotd = o2.принявшее_отделение and @otdnazn = o2.отделение_назначения
		and o2.код_посылки = @cpos and o2.код_операции = @coper - 2)
		begin print concat('КРИТЕРИЙ 4 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from Операции_с_посылками ago1
		join Операции_с_посылками ago2 on ago1.код_операции - 1 = ago2.код_операции 
		and ago1.код_посылки = ago2.код_посылки
		join Операции_с_посылками ago3 on ago2.код_операции - 1 = ago3.код_операции 
		and ago2.код_посылки = ago3.код_посылки
		join Операции_с_посылками ago4 on ago3.код_операции - 1 = ago4.код_операции 
		and ago3.код_посылки = ago4.код_посылки
		where DATEDIFF(d,@dprie,@dotpr) > DATEDIFF(d,ago1.дата_приёма,ago1.дата_отправки)
		and DATEDIFF(d,ago1.дата_приёма,ago1.дата_отправки) > DATEDIFF(d,ago2.дата_приёма,ago2.дата_отправки)
		and DATEDIFF(d,ago2.дата_приёма,ago2.дата_отправки) > DATEDIFF(d,ago3.дата_приёма,ago3.дата_отправки)
		and DATEDIFF(d,ago3.дата_приёма,ago3.дата_отправки) > DATEDIFF(d,ago4.дата_приёма,ago4.дата_отправки)
		and ago1.код_посылки = @cpos and ago1.код_операции = @coper - 1)
		begin print concat('КРИТЕРИЙ 5 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		declare @ret int = (select gek.код_операции from Операции_с_посылками gek join Посылки p 
		on p.код_посылки = gek.код_посылки where gek.код_посылки = @cpos
		and gek.принявшее_отделение = p.конечный_пункт and (gek.код_операции - 1) * 2 >= @coper
		and gek.код_посылки = @cpos) * 2 - 1
		if @ret is not null and not exists (select * from Операции_с_посылками o 
		where o.отделение_назначения = @priotd and @otdnazn = o.принявшее_отделение
		and o.код_посылки = @cpos and o.код_операции + @coper = @ret)
		begin print concat('КРИТЕРИЙ 6 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		declare @ag int = (select ag.код_операции from 
		(select код_посылки, код_операции, принявшее_отделение from Операции_с_посылками union select @cpos, @coper, @priotd) ag 
		join Посылки p on p.код_посылки = ag.код_посылки where ag.принявшее_отделение = p.начальный_пункт 
		and ag.код_операции <> 1 and ag.код_посылки = @cpos)
		if @ag is not null and exists (select * from Операции_с_посылками o
		where o.отделение_назначения = @otdnazn and @coper % 2 = 1
		and o.код_посылки = @cpos and o.код_операции = @coper - @ag + 1)
		begin print concat('КРИТЕРИЙ 7 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from Посылки p_i
		join (
		select inp.* from Посылки inp join Операции_с_посылками ino on inp.код_посылки = ino.код_посылки 
		where not (ino.отделение_назначения = inp.конечный_пункт and ino.отправлено = 1)
		and код_операции = (select max(код_операции) from Операции_с_посылками inino where inino.код_посылки = ino.код_посылки)
		) p_o 
		on p_i.конечный_пункт = p_o.конечный_пункт and p_i.начальный_пункт = p_o.начальный_пункт 
		join Операции_с_посылками o on p_o.код_посылки = o.код_посылки
		where p_i.код_посылки <> p_o.код_посылки and @priotd = o.принявшее_отделение 
		and @otdnazn = o.отделение_назначения and p_i.код_посылки = @cpos)
        begin print concat('КРИТЕРИЙ 8 не пропустил строку (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end
		
		insert Операции_с_посылками select @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr

		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr
	end
	close curs deallocate curs
end
go

drop trigger Afganistan
go
create trigger Afganistan
on Операции_с_посылками
instead of DELETE
as
begin
	declare @ww varchar(500) = (select 
	STRING_AGG(concat('Невозможно удалить строку (',o.код_посылки,'.', o.код_операции,')'), 
	char(13)) from Операции_с_посылками o join deleted d 
	on d.код_посылки = o.код_посылки and o.код_операции - 1 = d.код_операции)
	print @ww
	delete Операции_с_посылками 
	from (select d.* from deleted d join Операции_с_посылками o on o.код_посылки = d.код_посылки
	where not exists (select * from Операции_с_посылками o where d.код_посылки = o.код_посылки
	and o.код_операции > d.код_операции)) z where 
	Операции_с_посылками.код_посылки = z.код_посылки
	and Операции_с_посылками.код_операции = z.код_операции
end

drop trigger Cyprus
go
create trigger Cyprus
on Операции_с_посылками
instead of UPDATE
as
begin
	if @@ROWCOUNT = 0 return

	declare curs_i cursor for select * from inserted i open curs_i
	declare curs_d cursor for select * from deleted open curs_d
	declare @cpos_i int, @coper_i int, @nazv_i varchar(50), @dprie_i date, 
		@priotd_i int, @dotpr_i date, @otdnazn_i int, @otpr_i bit
	declare @cpos_d int, @coper_d int, @nazv_d varchar(50), @dprie_d date, 
		@priotd_d int, @dotpr_d date, @otdnazn_d int, @otpr_d bit
	fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
	fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d
	while @@FETCH_STATUS = 0
	begin
		if (@cpos_d <> @cpos_i or @coper_d <> @coper_i) 
		and exists (select * from Операции_с_посылками o where o.код_посылки = @cpos_d and o.код_операции - 1 = @coper_d)
		begin print concat('Недопустимо исчезновение строки (',@cpos_d,'.',@coper_d,'). Обновление на (',@cpos_i,'.',@coper_i,') не совершено')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @without_deleted table (
		код_посылки int, код_операции int, название_операции varchar(50), дата_приёма date, 
		принявшее_отделение int, дата_отправки date, отделение_назначения int, отправлено bit)
		insert @without_deleted
			select * from Операции_с_посылками o where o.код_посылки <> @cpos_d or o.код_операции <> @coper_d
			union select @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i

		if @coper_i = 1 and @priotd_i <> (select начальный_пункт from Посылки p where код_посылки = @cpos_i)
		begin print concat('КРИТЕРИЙ 1 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if @coper_i <> 1 and not exists (select * from @without_deleted o where @priotd_i = o.отделение_назначения 
		and o.код_посылки = @cpos_i and o.код_операции = @coper_i - 1)
		begin print concat('КРИТЕРИЙ 2 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end
		
		if @otpr_i = 0 and exists (select * from @without_deleted o 
		where o.код_посылки = @cpos_i and o.код_операции = @coper_i + 1)
		begin print concat('КРИТЕРИЙ 3 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from @without_deleted o2 
		where @cpos_i = o2.код_посылки and @priotd_i = o2.принявшее_отделение and @otdnazn_i = o2.отделение_назначения
		and o2.код_посылки = @cpos_i and o2.код_операции = @coper_i - 2)
		begin print concat('КРИТЕРИЙ 4 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from @without_deleted ago1
		join @without_deleted ago2 on ago1.код_операции - 1 = ago2.код_операции 
		and ago1.код_посылки = ago2.код_посылки
		join @without_deleted ago3 on ago2.код_операции - 1 = ago3.код_операции 
		and ago2.код_посылки = ago3.код_посылки
		join @without_deleted ago4 on ago3.код_операции - 1 = ago4.код_операции 
		and ago3.код_посылки = ago4.код_посылки
		where DATEDIFF(d,@dprie_i,@dotpr_i) > DATEDIFF(d,ago1.дата_приёма,ago1.дата_отправки)
		and DATEDIFF(d,ago1.дата_приёма,ago1.дата_отправки) > DATEDIFF(d,ago2.дата_приёма,ago2.дата_отправки)
		and DATEDIFF(d,ago2.дата_приёма,ago2.дата_отправки) > DATEDIFF(d,ago3.дата_приёма,ago3.дата_отправки)
		and DATEDIFF(d,ago3.дата_приёма,ago3.дата_отправки) > DATEDIFF(d,ago4.дата_приёма,ago4.дата_отправки)
		and ago1.код_посылки = @cpos_i and @coper_i - ago4.код_операции <= 4 and @coper_i - ago4.код_операции >= 0)
		begin print concat('КРИТЕРИЙ 5 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @ret int = (select gek.код_операции from @without_deleted gek join Посылки p 
		on p.код_посылки = gek.код_посылки where gek.код_посылки = @cpos_i
		and gek.принявшее_отделение = p.конечный_пункт and (gek.код_операции - 1) * 2 >= @coper_i
		and gek.код_посылки = @cpos_i) * 2 - 1
		if @ret is not null and not exists (select * from @without_deleted o 
		where o.отделение_назначения = @priotd_i and @otdnazn_i = o.принявшее_отделение
		and o.код_посылки = @cpos_i and o.код_операции + @coper_i = @ret)
		begin print concat('КРИТЕРИЙ 6 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @ag int = (select ag.код_операции from @without_deleted ag 
        join Посылки p on p.код_посылки = ag.код_посылки where ag.принявшее_отделение = p.начальный_пункт 
		and ag.код_операции <> 1 and ag.код_посылки = @cpos_i)
		if @ag is not null and exists (select * from @without_deleted o
		where o.отделение_назначения = @otdnazn_i and @coper_i % 2 = 1
		and o.код_посылки = @cpos_i and o.код_операции = @coper_i - @ag + 1)
		begin print concat('КРИТЕРИЙ 7 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from Посылки p_i
		join (
		select inp.* from Посылки inp join @without_deleted ino on inp.код_посылки = ino.код_посылки 
		where not (ino.отделение_назначения = inp.конечный_пункт and ino.отправлено = 1)
		and код_операции = (select max(код_операции) from @without_deleted inino where inino.код_посылки = ino.код_посылки)
		) p_o 
		on p_i.конечный_пункт = p_o.конечный_пункт and p_i.начальный_пункт = p_o.начальный_пункт 
		join @without_deleted o on p_o.код_посылки = o.код_посылки
		where p_i.код_посылки <> p_o.код_посылки and @priotd_i = o.принявшее_отделение 
		and @otdnazn_i = o.отделение_назначения and p_i.код_посылки = @cpos_i)
        begin print concat('КРИТЕРИЙ 8 не разрешил изменение строки (',@cpos_d,'.',@coper_d,') на (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

	    update Операции_с_посылками
		set код_посылки = @cpos_i, код_операции = @coper_i, название_операции = @nazv_i, дата_приёма = @dprie_i,
		принявшее_отделение = @priotd_i, дата_отправки = @dotpr_i, отделение_назначения = @otdnazn_i, отправлено = @otpr_i
		where код_посылки = @cpos_d and код_операции = @coper_d

		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d
	end
	close curs_i deallocate curs_i
	close curs_d deallocate curs_d
end
go

----- Данные
--truncate table Операции_с_посылками
--insert Операции_с_посылками values
--(1022,1,null,'2023-03-13',2,'2023-03-14',1,1), (1022,2,null,'2023-03-13',1,'2023-03-14',6,1), --- (8.2) ДОШЕДШАЯ посылка 
--(1022,3,null,'2023-03-13',6,'2023-03-14',4,1),

--(-1,1,null,'2023-03-13',4,'2023-03-14',2,1), (-1,2,null,'2023-03-14',2,'2023-03-15',3,1), --- (1) Начальный пункт неверный

----insert Операции_с_посылками values
--(-2,1,null,'2023-03-13',2,'2023-03-14',1,1), (-2,2,null,'2023-03-13',1,'2023-03-14',3,0), --- (3) Не отправлено    (8.1) Недошедшая посылка
--(-2,3,null,'2023-03-13',3,'2023-03-14',6,1), (-2,4,null,'2023-03-13',6,'2023-03-14',4,1),

--(-3,1,null,'2023-03-13',3,'2023-03-20',2,1), (-3,2,null,'2023-03-21',2,'2023-03-22',1,1), 
--(-3,3,null,'2023-03-23',1,'2023-03-25',4,1),
--(-3,4,null,'2023-03-26',4,'2023-03-29',1,1), (-3,5,null,'2023-03-30',1,'2023-04-05',4,1), --- (4) Пересылка
--(-3,6,null,'2023-04-06',4,'2023-04-17',5,1),

--(-4,1,null,'2023-03-13',4,'2023-03-14',5,1), (-4,2,null,'2023-03-14',5,'2023-03-14',6,1), 
--(-4,3,null,'2023-03-13',6,'2023-03-14',1,1),
--(-4,4,null,'2023-03-13',1,'2023-03-14',2,1), (-4,5,null,'2023-03-13',2,'2023-03-14',3,1),

----insert Операции_с_посылками values
--(7,1,null,'2023-03-13',1,'2023-03-20',2,1), (7,2,null,'2023-03-21',2,'2023-03-22',3,1), 
--(7,3,null,'2023-03-23',3,'2023-03-25',4,1),
--(7,4,null,'2023-03-26',4,'2023-03-29',3,1), (7,5,null,'2023-03-30',3,'2023-04-05',2,1), 
--(7,6,null,'2023-04-06',2,'2023-04-07',1,1),												--- (5) Сроки

--(101,1,null,'2023-04-26',2,'2023-04-26',3,1),(101,2,null,'2023-04-26',3,'2023-04-26',4,1),
--(101,3,null,'2023-04-26',4,'2023-04-26',5,1),(101,4,null,'2023-04-26',5,'2023-04-26',4,1),
--(101,5,null,'2023-04-26',4,'2023-04-26',6,1),(101,6,null,'2023-04-26',6,'2023-04-26',2,1), --- (6) Возврат

----insert Операции_с_посылками values
--(102,1,null,'2023-04-26',1,'2023-04-26',2,1),(102,2,null,'2023-04-26',2,'2023-04-26',3,1),
--(102,3,null,'2023-04-26',3,'2023-04-26',4,1),(102,4,null,'2023-04-26',4,'2023-04-26',5,1),
--(102,5,null,'2023-04-26',5,'2023-04-26',4,1),(102,6,null,'2023-04-26',4,'2023-04-26',3,1),
--(102,7,null,'2023-04-26',3,'2023-04-26',2,1),(102,8,null,'2023-04-26',2,'2023-04-26',1,1),
--(102,9,null,'2023-04-26',1,'2023-04-26',6,1),(102,10,null,'2023-04-26',6,'2023-04-26',3,1),
--(102,11,null,'2023-04-26',3,'2023-04-26',4,1),(102,12,null,'2023-04-26',4,'2023-04-26',5,1), --- (7) Повторный путь

--(22,1,null,'2023-03-13',2,'2023-03-14',6,1), 
--(22,2,null,'2023-03-13',6,'2023-03-14',1,1), 
--(22,3,null,'2023-03-13',1,'2023-03-14',3,1) --- (8) Проходит путь 2 посылки
--go

--- Данные
truncate table Операции_с_посылками
insert Операции_с_посылками values
(1,1,null,'2023-05-08',101,'2023-05-10',102,1),
(1,2,null,'2023-05-08',102,'2023-05-10',107,1),

(2,1,null,'2023-05-05',101,'2023-05-07',103,1),
(2,2,null,'2023-05-08',103,'2023-05-10',104,1),
(2,3,null,'2023-05-15',104,'2023-05-17',105,1),
(2,4,null,'2023-05-18',105,'2023-05-20',107,1),

(3,1,null,'2023-05-05',103,'2023-05-07',104,1),
(3,2,null,'2023-05-08',104,'2023-05-10',109,1),

(4,1,null,'2023-05-05',103,'2023-05-07',104,1),
(4,2,null,'2023-05-08',104,'2023-05-10',105,1),
(4,3,null,'2023-05-15',105,'2023-05-17',104,1),
(4,4,null,'2023-05-18',104,'2023-05-20',103,1)
select * from Операции_с_посылками

update Операции_с_посылками set код_операции = 10 where код_посылки = 4 and код_операции = 2
select * from Операции_с_посылками

delete Операции_с_посылками where код_посылки = 2 and код_операции = 2
or код_посылки = 3 and код_операции = 2

update Операции_с_посылками set название_операции = 'y' where код_посылки = 4 and код_операции = 2
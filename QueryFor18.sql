use Uzhe18
go


drop trigger Turkiye
go
create trigger Turkiye
on ��������_�_���������
instead of INSERT
as
begin
	if @@ROWCOUNT = 0 return
	declare curs cursor for select * from inserted open curs
	declare @cpos int, @coper int, @nazv varchar(50), @dprie date, @priotd int, @dotpr date, @otdnazn int, @otpr bit
	fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr
	while @@FETCH_STATUS = 0
	begin
		if @coper = 1 and @priotd <> (select ���������_����� from ������� p where ���_������� = @cpos)
		begin print concat('�������� 1 �� ��������� ������ (',@cpos,'.',@coper,')')
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if @coper <> 1 and not exists (select * from ��������_�_��������� o where @priotd = o.���������_���������� 
		and o.���_������� = @cpos and o.���_�������� = @coper - 1)
		begin print concat('�������� 2 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end
		
		if @coper <> 1 and not exists (select * from ��������_�_��������� o 
		where o.���������� = 1 and o.���_������� = @cpos and o.���_�������� = @coper - 1)
		begin print concat('�������� 3 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from ��������_�_��������� o2 
		where @cpos = o2.���_������� and @priotd = o2.���������_��������� and @otdnazn = o2.���������_����������
		and o2.���_������� = @cpos and o2.���_�������� = @coper - 2)
		begin print concat('�������� 4 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from ��������_�_��������� ago1
		join ��������_�_��������� ago2 on ago1.���_�������� - 1 = ago2.���_�������� 
		and ago1.���_������� = ago2.���_�������
		join ��������_�_��������� ago3 on ago2.���_�������� - 1 = ago3.���_�������� 
		and ago2.���_������� = ago3.���_�������
		join ��������_�_��������� ago4 on ago3.���_�������� - 1 = ago4.���_�������� 
		and ago3.���_������� = ago4.���_�������
		where DATEDIFF(d,@dprie,@dotpr) > DATEDIFF(d,ago1.����_�����,ago1.����_��������)
		and DATEDIFF(d,ago1.����_�����,ago1.����_��������) > DATEDIFF(d,ago2.����_�����,ago2.����_��������)
		and DATEDIFF(d,ago2.����_�����,ago2.����_��������) > DATEDIFF(d,ago3.����_�����,ago3.����_��������)
		and DATEDIFF(d,ago3.����_�����,ago3.����_��������) > DATEDIFF(d,ago4.����_�����,ago4.����_��������)
		and ago1.���_������� = @cpos and ago1.���_�������� = @coper - 1)
		begin print concat('�������� 5 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		declare @ret int = (select gek.���_�������� from ��������_�_��������� gek join ������� p 
		on p.���_������� = gek.���_������� where gek.���_������� = @cpos
		and gek.���������_��������� = p.��������_����� and (gek.���_�������� - 1) * 2 >= @coper
		and gek.���_������� = @cpos) * 2 - 1
		if @ret is not null and not exists (select * from ��������_�_��������� o 
		where o.���������_���������� = @priotd and @otdnazn = o.���������_���������
		and o.���_������� = @cpos and o.���_�������� + @coper = @ret)
		begin print concat('�������� 6 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		declare @ag int = (select ag.���_�������� from 
		(select ���_�������, ���_��������, ���������_��������� from ��������_�_��������� union select @cpos, @coper, @priotd) ag 
		join ������� p on p.���_������� = ag.���_������� where ag.���������_��������� = p.���������_����� 
		and ag.���_�������� <> 1 and ag.���_������� = @cpos)
		if @ag is not null and exists (select * from ��������_�_��������� o
		where o.���������_���������� = @otdnazn and @coper % 2 = 1
		and o.���_������� = @cpos and o.���_�������� = @coper - @ag + 1)
		begin print concat('�������� 7 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end

		if exists (select * from ������� p_i
		join (
		select inp.* from ������� inp join ��������_�_��������� ino on inp.���_������� = ino.���_������� 
		where not (ino.���������_���������� = inp.��������_����� and ino.���������� = 1)
		and ���_�������� = (select max(���_��������) from ��������_�_��������� inino where inino.���_������� = ino.���_�������)
		) p_o 
		on p_i.��������_����� = p_o.��������_����� and p_i.���������_����� = p_o.���������_����� 
		join ��������_�_��������� o on p_o.���_������� = o.���_�������
		where p_i.���_������� <> p_o.���_������� and @priotd = o.���������_��������� 
		and @otdnazn = o.���������_���������� and p_i.���_������� = @cpos)
        begin print concat('�������� 8 �� ��������� ������ (',@cpos,'.',@coper,')') 
		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr continue end
		
		insert ��������_�_��������� select @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr

		fetch next from curs into @cpos, @coper, @nazv, @dprie, @priotd, @dotpr, @otdnazn, @otpr
	end
	close curs deallocate curs
end
go

drop trigger Afganistan
go
create trigger Afganistan
on ��������_�_���������
instead of DELETE
as
begin
	declare @ww varchar(500) = (select 
	STRING_AGG(concat('���������� ������� ������ (',o.���_�������,'.', o.���_��������,')'), 
	char(13)) from ��������_�_��������� o join deleted d 
	on d.���_������� = o.���_������� and o.���_�������� - 1 = d.���_��������)
	print @ww
	delete ��������_�_��������� 
	from (select d.* from deleted d join ��������_�_��������� o on o.���_������� = d.���_�������
	where not exists (select * from ��������_�_��������� o where d.���_������� = o.���_�������
	and o.���_�������� > d.���_��������)) z where 
	��������_�_���������.���_������� = z.���_�������
	and ��������_�_���������.���_�������� = z.���_��������
end

drop trigger Cyprus
go
create trigger Cyprus
on ��������_�_���������
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
		and exists (select * from ��������_�_��������� o where o.���_������� = @cpos_d and o.���_�������� - 1 = @coper_d)
		begin print concat('����������� ������������ ������ (',@cpos_d,'.',@coper_d,'). ���������� �� (',@cpos_i,'.',@coper_i,') �� ���������')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @without_deleted table (
		���_������� int, ���_�������� int, ��������_�������� varchar(50), ����_����� date, 
		���������_��������� int, ����_�������� date, ���������_���������� int, ���������� bit)
		insert @without_deleted
			select * from ��������_�_��������� o where o.���_������� <> @cpos_d or o.���_�������� <> @coper_d
			union select @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i

		if @coper_i = 1 and @priotd_i <> (select ���������_����� from ������� p where ���_������� = @cpos_i)
		begin print concat('�������� 1 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if @coper_i <> 1 and not exists (select * from @without_deleted o where @priotd_i = o.���������_���������� 
		and o.���_������� = @cpos_i and o.���_�������� = @coper_i - 1)
		begin print concat('�������� 2 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end
		
		if @otpr_i = 0 and exists (select * from @without_deleted o 
		where o.���_������� = @cpos_i and o.���_�������� = @coper_i + 1)
		begin print concat('�������� 3 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from @without_deleted o2 
		where @cpos_i = o2.���_������� and @priotd_i = o2.���������_��������� and @otdnazn_i = o2.���������_����������
		and o2.���_������� = @cpos_i and o2.���_�������� = @coper_i - 2)
		begin print concat('�������� 4 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from @without_deleted ago1
		join @without_deleted ago2 on ago1.���_�������� - 1 = ago2.���_�������� 
		and ago1.���_������� = ago2.���_�������
		join @without_deleted ago3 on ago2.���_�������� - 1 = ago3.���_�������� 
		and ago2.���_������� = ago3.���_�������
		join @without_deleted ago4 on ago3.���_�������� - 1 = ago4.���_�������� 
		and ago3.���_������� = ago4.���_�������
		where DATEDIFF(d,@dprie_i,@dotpr_i) > DATEDIFF(d,ago1.����_�����,ago1.����_��������)
		and DATEDIFF(d,ago1.����_�����,ago1.����_��������) > DATEDIFF(d,ago2.����_�����,ago2.����_��������)
		and DATEDIFF(d,ago2.����_�����,ago2.����_��������) > DATEDIFF(d,ago3.����_�����,ago3.����_��������)
		and DATEDIFF(d,ago3.����_�����,ago3.����_��������) > DATEDIFF(d,ago4.����_�����,ago4.����_��������)
		and ago1.���_������� = @cpos_i and @coper_i - ago4.���_�������� <= 4 and @coper_i - ago4.���_�������� >= 0)
		begin print concat('�������� 5 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @ret int = (select gek.���_�������� from @without_deleted gek join ������� p 
		on p.���_������� = gek.���_������� where gek.���_������� = @cpos_i
		and gek.���������_��������� = p.��������_����� and (gek.���_�������� - 1) * 2 >= @coper_i
		and gek.���_������� = @cpos_i) * 2 - 1
		if @ret is not null and not exists (select * from @without_deleted o 
		where o.���������_���������� = @priotd_i and @otdnazn_i = o.���������_���������
		and o.���_������� = @cpos_i and o.���_�������� + @coper_i = @ret)
		begin print concat('�������� 6 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		declare @ag int = (select ag.���_�������� from @without_deleted ag 
        join ������� p on p.���_������� = ag.���_������� where ag.���������_��������� = p.���������_����� 
		and ag.���_�������� <> 1 and ag.���_������� = @cpos_i)
		if @ag is not null and exists (select * from @without_deleted o
		where o.���������_���������� = @otdnazn_i and @coper_i % 2 = 1
		and o.���_������� = @cpos_i and o.���_�������� = @coper_i - @ag + 1)
		begin print concat('�������� 7 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

		if exists (select * from ������� p_i
		join (
		select inp.* from ������� inp join @without_deleted ino on inp.���_������� = ino.���_������� 
		where not (ino.���������_���������� = inp.��������_����� and ino.���������� = 1)
		and ���_�������� = (select max(���_��������) from @without_deleted inino where inino.���_������� = ino.���_�������)
		) p_o 
		on p_i.��������_����� = p_o.��������_����� and p_i.���������_����� = p_o.���������_����� 
		join @without_deleted o on p_o.���_������� = o.���_�������
		where p_i.���_������� <> p_o.���_������� and @priotd_i = o.���������_��������� 
		and @otdnazn_i = o.���������_���������� and p_i.���_������� = @cpos_i)
        begin print concat('�������� 8 �� �������� ��������� ������ (',@cpos_d,'.',@coper_d,') �� (',@cpos_i,'.',@coper_i,')')
		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d continue end

	    update ��������_�_���������
		set ���_������� = @cpos_i, ���_�������� = @coper_i, ��������_�������� = @nazv_i, ����_����� = @dprie_i,
		���������_��������� = @priotd_i, ����_�������� = @dotpr_i, ���������_���������� = @otdnazn_i, ���������� = @otpr_i
		where ���_������� = @cpos_d and ���_�������� = @coper_d

		fetch next from curs_i into @cpos_i, @coper_i, @nazv_i, @dprie_i, @priotd_i, @dotpr_i, @otdnazn_i, @otpr_i
		fetch next from curs_d into @cpos_d, @coper_d, @nazv_d, @dprie_d, @priotd_d, @dotpr_d, @otdnazn_d, @otpr_d
	end
	close curs_i deallocate curs_i
	close curs_d deallocate curs_d
end
go

----- ������
--truncate table ��������_�_���������
--insert ��������_�_��������� values
--(1022,1,null,'2023-03-13',2,'2023-03-14',1,1), (1022,2,null,'2023-03-13',1,'2023-03-14',6,1), --- (8.2) �������� ������� 
--(1022,3,null,'2023-03-13',6,'2023-03-14',4,1),

--(-1,1,null,'2023-03-13',4,'2023-03-14',2,1), (-1,2,null,'2023-03-14',2,'2023-03-15',3,1), --- (1) ��������� ����� ��������

----insert ��������_�_��������� values
--(-2,1,null,'2023-03-13',2,'2023-03-14',1,1), (-2,2,null,'2023-03-13',1,'2023-03-14',3,0), --- (3) �� ����������    (8.1) ���������� �������
--(-2,3,null,'2023-03-13',3,'2023-03-14',6,1), (-2,4,null,'2023-03-13',6,'2023-03-14',4,1),

--(-3,1,null,'2023-03-13',3,'2023-03-20',2,1), (-3,2,null,'2023-03-21',2,'2023-03-22',1,1), 
--(-3,3,null,'2023-03-23',1,'2023-03-25',4,1),
--(-3,4,null,'2023-03-26',4,'2023-03-29',1,1), (-3,5,null,'2023-03-30',1,'2023-04-05',4,1), --- (4) ���������
--(-3,6,null,'2023-04-06',4,'2023-04-17',5,1),

--(-4,1,null,'2023-03-13',4,'2023-03-14',5,1), (-4,2,null,'2023-03-14',5,'2023-03-14',6,1), 
--(-4,3,null,'2023-03-13',6,'2023-03-14',1,1),
--(-4,4,null,'2023-03-13',1,'2023-03-14',2,1), (-4,5,null,'2023-03-13',2,'2023-03-14',3,1),

----insert ��������_�_��������� values
--(7,1,null,'2023-03-13',1,'2023-03-20',2,1), (7,2,null,'2023-03-21',2,'2023-03-22',3,1), 
--(7,3,null,'2023-03-23',3,'2023-03-25',4,1),
--(7,4,null,'2023-03-26',4,'2023-03-29',3,1), (7,5,null,'2023-03-30',3,'2023-04-05',2,1), 
--(7,6,null,'2023-04-06',2,'2023-04-07',1,1),												--- (5) �����

--(101,1,null,'2023-04-26',2,'2023-04-26',3,1),(101,2,null,'2023-04-26',3,'2023-04-26',4,1),
--(101,3,null,'2023-04-26',4,'2023-04-26',5,1),(101,4,null,'2023-04-26',5,'2023-04-26',4,1),
--(101,5,null,'2023-04-26',4,'2023-04-26',6,1),(101,6,null,'2023-04-26',6,'2023-04-26',2,1), --- (6) �������

----insert ��������_�_��������� values
--(102,1,null,'2023-04-26',1,'2023-04-26',2,1),(102,2,null,'2023-04-26',2,'2023-04-26',3,1),
--(102,3,null,'2023-04-26',3,'2023-04-26',4,1),(102,4,null,'2023-04-26',4,'2023-04-26',5,1),
--(102,5,null,'2023-04-26',5,'2023-04-26',4,1),(102,6,null,'2023-04-26',4,'2023-04-26',3,1),
--(102,7,null,'2023-04-26',3,'2023-04-26',2,1),(102,8,null,'2023-04-26',2,'2023-04-26',1,1),
--(102,9,null,'2023-04-26',1,'2023-04-26',6,1),(102,10,null,'2023-04-26',6,'2023-04-26',3,1),
--(102,11,null,'2023-04-26',3,'2023-04-26',4,1),(102,12,null,'2023-04-26',4,'2023-04-26',5,1), --- (7) ��������� ����

--(22,1,null,'2023-03-13',2,'2023-03-14',6,1), 
--(22,2,null,'2023-03-13',6,'2023-03-14',1,1), 
--(22,3,null,'2023-03-13',1,'2023-03-14',3,1) --- (8) �������� ���� 2 �������
--go

--- ������
truncate table ��������_�_���������
insert ��������_�_��������� values
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
select * from ��������_�_���������

update ��������_�_��������� set ���_�������� = 10 where ���_������� = 4 and ���_�������� = 2
select * from ��������_�_���������

delete ��������_�_��������� where ���_������� = 2 and ���_�������� = 2
or ���_������� = 3 and ���_�������� = 2

update ��������_�_��������� set ��������_�������� = 'y' where ���_������� = 4 and ���_�������� = 2
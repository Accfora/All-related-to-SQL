use Anshostos
go

-- ��� ������� (�� ��������� ������)
select *
from �����������_�������
where datediff(d,����_�������,getdate()) < 14
-- ��������� �������
select *
from �����������_�������
where �������_�������� not like '%�������%' or �������_�������� not like '%�����������%'
and �������_�������� not like '%��������%'
-- ���������� ��������� �������
select *
from �����������_�������
where �������_�������� not like '%�������%' and �������_�������� not like '%�����������%'
-- � ������������
select *
from �����������_�������
where ���������� not like '�� ���������'
-- � ���������
select *
from �����������_������� 
where �_�������� not like '��� ������ �������'
-- � �����������
select *
from �����������_������� 
where �������_�������� like '%-%-%'
-- ��� ������� �� �������� ��������
select �������_��������, count(*) as �������������, count(case when ���������� not like '�� ���������' then 1 end) as ����������,
sum(������) as ���������, cast(round(avg(������),2) as decimal(6,2)) �������_������, 
cast(round(avg(�����_�������),0) as int) as �������_�����, max(�������_������) ����������������_������
from �����������_�������
group by �������_�������� order by ������������� desc, sum(������), �������_��������

-- ������������

select 
count(distinct �������) as �������,
--dense_rank() over (order by count(distinct �������) desc) as ����,
��������_�������,
count (distinct �������) - count(case when �������_�������� = Id_������� then �������_�������� end)  as �������,
count (distinct �������) - count(case when �������_����������� = Id_������� then �������_����������� end)  as �����,
concat(cast(round(count(distinct �������) * 100.0 / (select count(*) from �������),2) as decimal(4,1)),'%') as �������������,
	count(case when �������_����������� = Id_������� then �������_����������� end) 
	+ count(case when �������_�������� = Id_������� then �������_�������� end) 
	- count (distinct �������) as ���������
from ������� st  
join �������� m on st.Id_������� = m.�������_����������� or st.Id_������� = m.�������_��������
join ������� pr on m.Id_�������� = pr.�������
group by Id_�������, ��������_�������
order by count(distinct �������) desc, Id_�������
--order by Id_�������
go

-- ������������� ���������

select 
	count(Id_�������) as ��������,
	concat(stbegin.��������_�������, ' - ', stend.��������_�������) as �������_�������, 
	convert(varchar(5),�����_�����������) as ��������, 
	case 
		when avg(���������_�����������) = 0 then '� ��������� �����' 
		when avg(���������_�����������) < 0  then concat('���������� � ',abs(avg(���������_�����������)),' �����') 
		else concat(avg(���������_�����������),' ����� ���������')  end as �������_�����������,
	convert(varchar(5),�����_��������) as ��������, 
	case 
		when avg(���������_��������) = 0 then '� ��������� �����' 
		when avg(���������_��������) < 0  then concat('���������� � ',abs(avg(���������_��������)),' �����') 
		else concat(avg(���������_��������),' ����� ���������')  end as �������_��������
from ������� pr join �������� m on m.Id_�������� = pr.�������
join ������� stbegin on stbegin.Id_������� = m.�������_����������� join ������� stend on stend.Id_������� = m.�������_��������
group by Id_��������, �������_�����������, �������_��������, stbegin.��������_�������,  stend.��������_�������, �����_�����������, �����_��������
order by (case when avg(���������_�����������) <> 0 or avg(���������_��������) <> 0 then 0 else 1 end),
�������_�����������, �������_��������, �����_�����������

-- ������ �� �����������

select 
	concat(count(Id_�������), ' ���') as �������������,
	concat(convert(varchar(5),�����_������_����), ' �� ',stbegin.��������_�������, ' - ', stend.��������_�������) as ����_����������,
	case when ����������_������� - ��������_������� > 0 then '�� �����' else '�� ��' end as �����������,
	isnull(cast(min(�����������) as varchar(10)) + ' � �����������',isnull(cast(min(�������) as varchar(15)) + ' � �������','��� ���������� �������')) as ��_����������,
	concat(cast(avg(�����) as decimal(5,2)), ' ������') �������_������
from 
(
	select Id_����������, Id_�������, sum(������) �����, 
	min(case when �������_����������� = 12 then convert(varchar(5),�����_�����������) when �������_�������� = 12 then convert(varchar(5),�����_��������) end) as �����������,
	min(case when �������_����������� = 29 then convert(varchar(5),�����_�����������) when �������_�������� = 29 then convert(varchar(5),�����_��������) end) as �������
	from ������� po join ������� pr on po.Id_������� = pr.������� 
	join �������� m on m.Id_�������� = pr.������� 
	join ���������� e on m.���������� = e.Id_����������
	group by Id_����������, Id_�������
) grouped 
join ���������� e on grouped.Id_���������� = e.Id_����������
join ����_���������� te on te.Id_����_���������� = e.���_����������
join ������� stbegin on stbegin.Id_������� = te.����������_������� join ������� stend on stend.Id_������� = te.��������_�������
group by e.Id_����������, stbegin.��������_�������, stend.��������_�������, �����_������_����, ����������_�������, ��������_�������
order by avg(�����), min(�����������)
go

-- ��� �������

alter view �����������_������� as
select 
		--concat(����_�������,
		--case count(case when ����������� < 0 then )
		--),
		����_�������,
		'�����' = cast(min(convert(varchar(5),�����_�����������))as varchar(8)) + ' - ' + cast(max(convert(varchar(5),�����_��������)) as varchar(8)),
		string_agg(s1.��������_�������, ' - ') WITHIN GROUP (ORDER BY �����_�����������) + ' - ' 
		+ (select ��������_������� from ������� inc 
		join �������� incoc on inc.������� = incoc.Id_�������� 
		join ������� we on incoc.�������_�������� = we.Id_�������
		where inc.������� = max(prm.�������) and dateadd(mi,���������_��������,�����_��������) = max(prm.�����_��������)) as �������_��������,
		sum (������) as ������,
		string_agg(������_������, ', ') as �������_������,
		datediff(mi,min(�����_�����������),max(�����_��������)) as �����_�������,
		case 
			datediff(mi,min(�����_�����������),max(�����_��������)) - sum(datediff(mi,�����_�����������,�����_��������)) when 0 then '��� ������ �������' 
			else cast(datediff(mi,min(�����_�����������),max(�����_��������)) - sum(datediff(mi,�����_�����������,�����_��������)) as varchar(10))  + ' �����' 
		end as �_��������,
		case 
			count(�����������) when 0 then '�� ���������' 
			else 
				case when count(��������) != 0 then '������ �� ������� '+ STRING_AGG(k.��������, ', ') 
				else '��������� �� ������� '+ STRING_AGG(k.�����������, ', ') 
			end 
		end as ����������
from ������� po 
	join (select Id_�������, ������, ������_������, �������, Id_��������, �������_�����������, �������_��������, 
		�������_����������� - �������_�������� as �����������, 
		dateadd(mi,���������_�����������,�����_�����������) as �����_�����������, 
		dateadd(mi,���������_��������,�����_��������) as �����_�������� 
		from ������� pr 
		join �������� m on m.Id_�������� = pr.�������) prm on po.Id_������� = prm.�������
	join ������� s1 on prm.�������_����������� = s1.Id_������� 
	 left join 
(select ������, 
STRING_AGG(sto.��������_�������, ', ') �����������,
STRING_AGG(stp.��������_�������, ', ') �������� 
from ���������� 
left join ������� stp on stp.Id_������� = �������_��������
left join ������� sto on sto.Id_������� = �������_�����������
group by ������) k on k.������ = prm.Id_�������
group by ����_�������, Id_�������
order by ����_������� DESC, min(�����_�����������) DESC offset 0 rows
go

-- ��� �������

select 
	����_�������,
	(select ��������_������� from ������� where Id_������� = m.�������_�����������) 
	+ ' - ' + (select ��������_������� from ������� where Id_������� = m.�������_��������) as ������,
	�����_�����������,
	�����_��������,
	������,
	���_����������,
	(select ��������_������� from ������� where Id_������� = te.����������_�������) 
	+ ' - ' + (select ��������_������� from ������� where Id_������� = te.��������_�������) as ����_����������
from ������� po 
join ������� pr on po.Id_������� = pr.�������
join �������� m on m.Id_�������� = pr.�������
join ���������� e on m.���������� = e.Id_����������
join ����_���������� te on e.���_���������� = te.Id_����_����������
order by ����_�������
go

--with help as (
--	select 
--	����_�������, �������, �������_�����������, �������_��������, dateadd(mi,���������_�����������,�����_�����������) �����_�����������, 
--	dateadd(mi,���������_��������,�����_��������) �����_��������, cast(concat(�������_�����������, ' - ',�������_��������) as varchar(100)) cc, 1 su
--	from ������� pr join ������� po on po.Id_������� = pr.�������
--	join �������� m on m.Id_�������� = pr.�������_�������
--	-- �� �������� ��� ��� �� ��������� ���������?
--	union all
--	select po.����_�������, pr.�������, m.�������_�����������, m.�������_��������, dateadd(mi,���������_�����������,m.�����_�����������) �����_�����������, 
--	dateadd(mi,���������_��������,m.�����_��������) �����_��������, cast(cte.cc + ' - ' + cast(m.�������_�������� as varchar(3)) as varchar(100)) cc, cte.su + 1
--	from ������� pr join ������� po on po.Id_������� = pr.�������
--	join �������� m on m.Id_�������� = pr.�������_�������
--	join help cte on cte.�������_�������� = m.�������_����������� and cte.����_������� = po.����_������� and cte.�����_����������� <= m.�����_��������
--)
--select * from help
--	where not exists (select * from ������� zpr join �������� zm on zm.Id_�������� = zpr.�������_������� 
--	where help.������� = zpr.������� and zm.�����_�������� < help.�����_�������� and zm.�����_����������� > help.�����_�����������)
--group by ����_�������, �������


with smth as (
select * 
	from ������� po 
	join (select Id_�������, ������, �������, Id_��������, �������_�����������, �������_��������, 
		dateadd(mi,���������_�����������,�����_�����������) as �����_�����������, 
		dateadd(mi,���������_��������,�����_��������) as �����_�������� 
		from ������� pr 
		join �������� m on m.Id_�������� = pr.�������) prm on po.Id_������� = prm.�������
	join ������� s1 on prm.�������_����������� = s1.Id_������� 
	)
select ����_�������, '�����' = cast(min(w1)as varchar(8)) + ' - ' + cast(max(w2) as varchar(8)), 
string_agg(qw.�������_��������, ',  ') WITHIN GROUP (ORDER BY w2) as r,
sum(������) as �����, cast(sum(�����_�������) as varchar(8)) + ' �����' as �����_�_����,
count (*) as �������,
case sum(�_��������) when 0 then '��� ������ ����������' else cast(sum(�_��������) as varchar(10)) + ' �����' end as ��_���������
from (
	select 
		����_�������,
		min(�����_�����������) as w1, max(�����_��������) as w2,
		string_agg(smth.��������_�������, ' - ') WITHIN GROUP (ORDER BY �����_�����������) + ' - ' 
		+ (select ��������_������� from ������� inc 
		join �������� incoc on inc.������� = incoc.Id_�������� 
		join ������� we on incoc.�������_�������� = we.Id_�������
		where inc.������� = max(smth.�������) and dateadd(mi,���������_��������,�����_��������) = max(smth.�����_��������)) as �������_��������,
		sum (������) as ������,
		datediff(mi,min(�����_�����������),max(�����_��������)) as �����_�������,
		datediff(mi,min(�����_�����������),max(�����_��������)) - sum(datediff(mi,�����_�����������,�����_��������)) as �_��������
	from smth
	group by ����_�������, Id_�������) qw
group by ����_�������
go


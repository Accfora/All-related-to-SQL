select �������, ���, ��������, ������������
from [�����/E5] inner join [���������/�3] on [�����/E5].����_������ = [���������/�3].����_������ and 
[�����/E5].���_����� = [���������/�3].���_����� and [�����/E5].���_�������� = [���������/�3].���_��������
inner join [�����/E2] on [�����/E2].���_����� = [���������/�3].���_����� 
inner join [�����/E1] on [�����/E2].���_������ = [�����/E1].���_������ 
where �����_������� = 1 and (select count(*) from [�����/E5] where �����_������� = 1)
/ (cast((select count(*) from [�����/E2]) as float)) > 0.25

select ��������
from [�����/E5] inner join [���������/�3] on [�����/E5].����_������ = [���������/�3].����_������ and 
[�����/E5].���_����� = [���������/�3].���_����� and [�����/E5].���_�������� = [���������/�3].���_��������
inner join [�����/E2] on [�����/E2].���_����� = [���������/�3].���_����� 
inner join [�����/E1] on [�����/E2].���_������ = [�����/E1].���_������ 
where �����_������� = 1 and (select count(*) from [�����/E5] where �����_������� = 1)
/ (cast((select ����������_���� from [�����/E2] where ���_����� = ) as float)) > 0.25

select �������, ���, ��������, ������������
from (
select ���_�����, count(*) as ��������� from [�����/E5]
where �����_������� = 1 group by ���_�����
) as help 
inner join [�����/E2] on help.���_����� = [�����/E2].���_����� 
inner join [�����/E1] on [�����/E2].���_������ = [�����/E1].���_������
where help.��������� / 1.0 / ����������_���� > 0.25 and �������� not in ('������')

update [�����/E2] 
set ����������_���� = ����������_���� + 1
where �������� in ('������','�������')

select ��������, count(*) as ������������
from [���������/�3] inner join [�����/E2] on [���������/�3].���_����� = [�����/E2].���_�����
group by ��������, [�����/E2].���_�����
having count(*) >= (select min (help.�����)
				    from (select top 5 ���_�����, count(*) as �����
					   	  from [���������/�3]
						  group by ���_�����
						  order by ����� desc) as help)
order by ������������ desc
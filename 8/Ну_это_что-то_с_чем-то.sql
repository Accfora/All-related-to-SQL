select �������, ���, ��������, ������������ 
from [�����/E1] inner join [�����/E2] on [�����/E1].���_������ = [�����/E2].���_������ 
where �������� like '������' except (select �������, ���, ��������, ������������
from [�����/E5] inner join [���������/�3] on [�����/E5].����_������ = [���������/�3].����_������ and 
[�����/E5].���_����� = [���������/�3].���_����� and [�����/E5].���_�������� = [���������/�3].���_��������
inner join [�����/E2] on [�����/E2].���_����� = [���������/�3].���_����� 
inner join [�����/E1] on [�����/E2].���_������ = [�����/E1].���_������ 
where �����_������� = 1 and (select count(*) from [�����/E5] where �����_������� = 1)
/ (cast((select count(*) from [�����/E2]) as float)) > 0.25)

---

select �������, ���, ��������, ������������
from [�����/E5] inner join [���������/�3] on [�����/E5].����_������ = [���������/�3].����_������ and 
[�����/E5].���_����� = [���������/�3].���_����� and [�����/E5].���_�������� = [���������/�3].���_��������
inner join [�����/E2] on [�����/E2].���_����� = [���������/�3].���_����� 
inner join [�����/E1] on [�����/E2].���_������ = [�����/E1].���_������ 
where �����_������� = 1 and (select count(*) from [�����/E5] where �����_������� = 1)
/ (cast((select count(*) from [�����/E2]) as float)) > 0.25

---

select (select count(*) from [�����/E5] where �����_������� = 1)
/ (cast((select count(*) from [�����/E2]) as float)) 
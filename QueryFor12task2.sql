alter view ������������_������_�_�����������_������ as 
select *
from ������������
where ���_������������ not in 
(
select distinct a.���_������������
from ������ aed join �����_������� a on aed.���_������ = a.���_������ join �����_������� b on 
a.���_��������� = b.���_��������� and a.���_������������ = b.���_������������ 
join ������ bed on b.���_������ = bed.���_������
where aed.����_�_�����_������_������ < bed.����_�_�����_������_������ and a.����������_����_����� >= b.����������_����_�����
)

select * from ������������_������_�_�����������_������
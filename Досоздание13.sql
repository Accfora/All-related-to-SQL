create table ���������� 
(
����_������ varchar(15) not null,
�����_���� int not null,
���_������������� int not null,
���_���������� int not null,
�����_������ varchar(15) not null,
�����_��������� int not null,
constraint PK_���������� primary key (����_������, �����_����, ���_�������������, ���_����������, �����_������),
)

create table ��������
(
���_������������� int not null,
���_���������� int not null,
���������_���� decimal (7,2) null,
���������_������ bit null,
constraint PK_�������� primary key (���_�������������, ���_����������),
constraint FK_��������_������������� foreign key (���_�������������) references [dbo].[�������_�������������0](���_�������������)
)

alter table ���������� add constraint FK_����������_�������� foreign key (���_�������������, ���_����������) 
references �������� (���_�������������, ���_����������) 
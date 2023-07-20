use master;
IF DB_ID (N'lab11') IS NOT NULL
DROP DATABASE lab11;
GO

create database lab11 on
( NAME = my1file,
    FILENAME = 'D:\mies\my1.mdf',
    SIZE = 50,
    MAXSIZE = 1 gb,
    FILEGROWTH = 10%),
filegroup mygroup
( NAME = my2file,
    FILENAME = 'D:\mies\my2.ndf',
    SIZE = 50,
    MAXSIZE = 1 gb,
    FILEGROWTH = 10%)
LOG ON
( NAME = my_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\mylog.ldf',
    SIZE = 100,
    MAXSIZE = 500,
    FILEGROWTH = 100 ) ;
GO

use lab11;
go

create table �������� 
(���_�������� int not null,
�������� varchar(50) not null,
�������������� varchar(2000) not null,
���_�������� int not null, 
��������_�������� varchar(50) not null, 
���������_�������� int not null,
�����������_������ bit not null, 
�����������_������� bit not null,
constraint pk_�������� primary key (���_��������)
);

create table ����_��������� 
(���_����_�������� int not null,
��������_���� varchar(50) not null,
��������� varchar(50) not null,
��������_���������_������ bit not null,
��������������_������� varbinary(max) null,
�����������_����������_�_���� real not null,
constraint pk_����_��������� primary key (���_����_��������));

create table ��������� 
(���_��������� int not null,
���_������������ int not null,
���_�������� int not null,
����_�_�����_������������ smalldatetime not null,
��������_������� bit not null,
����_�_���� float null, 
����_�_����� float null,
����_�_�������� float null,
constraint pk_��������� primary key (���_���������,���_������������,���_��������));

create table ��������� 
(���_��������� int not null,
���_������������ int not null,
���_��������� varchar(50) not null, 
�������_��������� varchar(3000) null, 
�������_��������� tinyint not null, 
������_������_��������� varchar(2000) null,
constraint pk_��������� primary key(���_���������,���_������������));

create table �����_������� 
(���_��������� int not null,
���_������ int not null, 
���_������������ int not null,
����������_����_����� int not null, 
�������_�_������� float null,
����������_�������� tinyint null, 
�����_�_������ time not null, 
�������_�������� bit not null, 
����������_��_�����_������ bit not null,
constraint pk_�����_������� primary key (���_���������,���_������,���_������������));

create table ������ 
(���_������ int not null,
������� varchar(30) not null,
����_�_�����_������_������ smalldatetime not null,
�����������������_������ time not null, 
����������_������_����_�������_x float not null,
����������_������_����_�������_y float not null,
����������_������_����_�������_z float not null,
����������_������_�_������ int not null,
constraint pk_������ primary key (���_������));

create table ������������ 
(���_������������ int not null,
�����������_����� varchar(100) not null, 
����� varchar(100) not null,
������ varchar(30) not null, 
������� varchar(30) not null,
�������_������������ tinyint not null,
constraint pk_������������ primary key (���_������������));

alter table �������� add constraint fk_��������_����_��������� foreign key (���_��������) references ����_���������(���_����_��������)
alter table ��������� add constraint fk_���������_������������ foreign key (���_������������) references ������������(���_������������)
alter table ��������� add constraint fk_���������_��������� foreign key (���_���������,���_������������) references ���������(���_���������,���_������������)
alter table ��������� add constraint fk_���������_�������� foreign key (���_��������) references ��������(���_��������)
alter table �����_������� add constraint fk_�����_�������_��������� foreign key (���_���������,���_������������) references ���������(���_���������,���_������������)
alter table �����_������� add constraint fk_�����_�������_������ foreign key (���_������) references ������(���_������)
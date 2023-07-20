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

create table Предметы 
(код_предмета int not null,
название varchar(50) not null,
характеристика varchar(2000) not null,
вид_предмета int not null, 
редкость_предмета varchar(50) not null, 
стоимость_предмета int not null,
возможность_обмена bit not null, 
возможность_продажи bit not null,
constraint pk_Предметы primary key (код_предмета)
);

create table Виды_предметов 
(код_вида_предмета int not null,
название_вида varchar(50) not null,
коллекция varchar(50) not null,
является_предметом_одежды bit not null,
дополнительный_контент varbinary(max) null,
вероятность_нахождения_в_игре real not null,
constraint pk_Виды_предметов primary key (код_вида_предмета));

create table Инвентарь 
(код_персонажа int not null,
код_пользователя int not null,
код_предмета int not null,
дата_и_время_приобретения smalldatetime not null,
активный_предмет bit not null,
плюс_к_силе float null, 
плюс_к_броне float null,
плюс_к_здоровью float null,
constraint pk_Инвентарь primary key (код_персонажа,код_пользователя,код_предмета));

create table Персонажи 
(код_персонажа int not null,
код_пользователя int not null,
имя_персонажа varchar(50) not null, 
история_персонажа varchar(3000) null, 
уровень_персонажа tinyint not null, 
особые_умения_персонажа varchar(2000) null,
constraint pk_Персонажи primary key(код_персонажа,код_пользователя));

create table Итоги_раундов 
(код_персонажа int not null,
код_раунда int not null, 
код_пользователя int not null,
полученные_очки_опыта int not null, 
рейтинг_в_команде float null,
количество_страйков tinyint null, 
время_в_раунде time not null, 
команда_победила bit not null, 
отключение_во_время_раунда bit not null,
constraint pk_Итоги_раундов primary key (код_персонажа,код_раунда,код_пользователя));

create table Раунды 
(код_раунда int not null,
локация varchar(30) not null,
дата_и_время_начала_раунда smalldatetime not null,
продолжительность_раунда time not null, 
координаты_начала_игры_команды_x float not null,
координаты_начала_игры_команды_y float not null,
координаты_начала_игры_команды_z float not null,
количество_команд_в_раунде int not null,
constraint pk_Раунды primary key (код_раунда));

create table Пользователи 
(код_пользователя int not null,
электронная_почта varchar(100) not null, 
логин varchar(100) not null,
пароль varchar(30) not null, 
никнейм varchar(30) not null,
уровень_пользователя tinyint not null,
constraint pk_Пользователи primary key (код_пользователя));

alter table Предметы add constraint fk_Предметы_Виды_предметов foreign key (вид_предмета) references Виды_предметов(код_вида_предмета)
alter table Персонажи add constraint fk_Персонажи_Пользователи foreign key (код_пользователя) references Пользователи(код_пользователя)
alter table Инвентарь add constraint fk_Инвентарь_Персонажи foreign key (код_персонажа,код_пользователя) references Персонажи(код_персонажа,код_пользователя)
alter table Инвентарь add constraint fk_Инвентарь_Предметы foreign key (код_предмета) references Предметы(код_предмета)
alter table Итоги_раундов add constraint fk_Итоги_раундов_Персонажи foreign key (код_персонажа,код_пользователя) references Персонажи(код_персонажа,код_пользователя)
alter table Итоги_раундов add constraint fk_Итоги_раундов_Раунды foreign key (код_раунда) references Раунды(код_раунда)
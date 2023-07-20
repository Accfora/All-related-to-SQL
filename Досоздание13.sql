create table Расписание 
(
День_недели varchar(15) not null,
Номер_пары int not null,
Код_преподавателя int not null,
Код_дисциплины int not null,
Номер_группы varchar(15) not null,
Номер_аудитории int not null,
constraint PK_Расписание primary key (День_недели, Номер_пары, Код_преподавателя, Код_дисциплины, Номер_группы),
)

create table Нагрузка
(
Код_преподавателя int not null,
Код_дисциплины int not null,
Стоимость_часа decimal (7,2) null,
Почасовая_оплата bit null,
constraint PK_Нагрузка primary key (Код_преподавателя, Код_дисциплины),
constraint FK_Нагрузка_Преподаватели foreign key (Код_преподавателя) references [dbo].[Таблица_Преподаватели0](Код_преподавателя)
)

alter table Расписание add constraint FK_Расписание_Нагрузка foreign key (Код_преподавателя, Код_дисциплины) 
references Нагрузка (Код_преподавателя, Код_дисциплины) 
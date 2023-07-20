CREATE TABLE [Факультет]
(
 [Код_факультета] Int NOT NULL,
 [Название_факультета] Nvarchar(50) NOT NULL,
 [Дата_основания] Date NOT NULL,
 [Род_деятельности] Nvarchar(50) NOT NULL,
 [Макс_кол_во_студентов] Int NOT NULL
)
go

-- Add keys for table Факультет

ALTER TABLE [Факультет] ADD CONSTRAINT [PK_Факультет] PRIMARY KEY ([Код_факультета])
go

-- Table Кафедра

CREATE TABLE [Кафедра]
(
 [Код_кафедры] Int NOT NULL,
 [Название_кафедры] Nvarchar(50) NOT NULL,
 [Выпускающая_кафедра] Nvarchar(50) NOT NULL,
 [Сайт] Nvarchar(50) NOT NULL,
 [Телефон] Nchar(11) NOT NULL,
 [Код_факультета] Int NOT NULL,
 [Зав_кафедрой] Int NOT NULL
)
go

-- Create indexes for table Кафедра

CREATE INDEX [IX_Relationship9] ON [Кафедра] ([Код_факультета])
go

CREATE INDEX [IX_Relationship11] ON [Кафедра] ([Зав_кафедрой])
go

-- Add keys for table Кафедра

ALTER TABLE [Кафедра] ADD CONSTRAINT [PK_Кафедра] PRIMARY KEY ([Код_кафедры])
go

-- Table Группа

CREATE TABLE [Группа]
(
 [Номер_группы] Nchar(14) NOT NULL,
 [Макс_кол_во_человек] Int NOT NULL,
 [Код_преподавателя] Int NULL,
 [Код_факультета] Int NULL
)
go

-- Create indexes for table Группа

CREATE INDEX [IX_Relationship7] ON [Группа] ([Код_преподавателя])
go

CREATE INDEX [IX_Relationship8] ON [Группа] ([Код_факультета])
go

-- Add keys for table Группа

ALTER TABLE [Группа] ADD CONSTRAINT [PK_Группа] PRIMARY KEY ([Номер_группы])
go

-- Table Преподаватель

CREATE TABLE [Преподаватель]
(
 [Код_преподавателя] Int NOT NULL,
 [Фамилия] Nvarchar(20) NOT NULL,
 [Имя] Nvarchar(20) NOT NULL,
 [Отчество] Nvarchar(20) NOT NULL,
 [Образование] Nvarchar(20) NOT NULL,
 [Стаж] Int NOT NULL,
 [Контактный_телефон] Nchar(11) NOT NULL,
 [Код_кафедры] Int NOT NULL
)
go

-- Create indexes for table Преподаватель

CREATE INDEX [IX_Relationship10] ON [Преподаватель] ([Код_кафедры])
go

-- Add keys for table Преподаватель

ALTER TABLE [Преподаватель] ADD CONSTRAINT [PK_Преподаватель] PRIMARY KEY ([Код_преподавателя])
go

-- Table Студент

CREATE TABLE [Студент]
(
 [Код_студента] Int NOT NULL,
 [Фамилия] Nvarchar(20) NOT NULL,
 [Имя] Nvarchar(20) NOT NULL,
 [Отчество] Nvarchar(20) NOT NULL,
 [Дата_рождения] Date NOT NULL,
 [Адрес] Nvarchar(100) NOT NULL,
 [Телефон] Nchar(11) NOT NULL,
 [Номер_группы] Nchar(14) NULL
)
go

-- Create indexes for table Студент

CREATE INDEX [IX_Relationship6] ON [Студент] ([Номер_группы])
go

-- Add keys for table Студент

ALTER TABLE [Студент] ADD CONSTRAINT [PK_Студент] PRIMARY KEY ([Код_студента])
go

-- Table Расписание

CREATE TABLE [Расписание]
(
 [День_недели] Int NOT NULL,
 [Номер_пары] Int NOT NULL,
 [Номер_группы] Nchar(14) NOT NULL,
 [Код_дисциплина] Int NOT NULL,
 [Примечание] Nvarchar(100) NOT NULL,
 [Код_преподавателя] Int NOT NULL,
 [Номер_лаборатории] Int NOT NULL
)
go

-- Create indexes for table Расписание

CREATE INDEX [IX_Relationship5] ON [Расписание] ([Номер_лаборатории])
go

-- Add keys for table Расписание

ALTER TABLE [Расписание] ADD CONSTRAINT [PK_Расписание] PRIMARY KEY ([День_недели],[Номер_пары],[Номер_группы],[Код_дисциплина],[Код_преподавателя])
go

-- Table Лаборатория

CREATE TABLE [Лаборатория]
(
 [Номер_лаборатории] Int NOT NULL,
 [Название] Nvarchar(50) NOT NULL,
 [Род_деятельности] Nvarchar(20) NOT NULL,
 [Количество_рабочих_мест] Int NOT NULL,
 [Наличие_проектного_оборудования] Bit NOT NULL,
 [Код_кафедры] Int NULL,
 [Код_преподавателя] Int NULL
)
go

-- Create indexes for table Лаборатория

CREATE INDEX [IX_Relationship12] ON [Лаборатория] ([Код_кафедры])
go

CREATE INDEX [IX_Relationship13] ON [Лаборатория] ([Код_преподавателя])
go

-- Add keys for table Лаборатория

ALTER TABLE [Лаборатория] ADD CONSTRAINT [PK_Лаборатория] PRIMARY KEY ([Номер_лаборатории])
go

-- Table Нагрузка

CREATE TABLE [Нагрузка]
(
 [Стоимость_часа] Int NOT NULL,
 [Почасовая_оплата] Int NOT NULL,
 [Код_дисциплина] Int NOT NULL,
 [Код_преподавателя] Int NOT NULL
)
go

-- Add keys for table Нагрузка

ALTER TABLE [Нагрузка] ADD CONSTRAINT [PK_Нагрузка] PRIMARY KEY ([Код_дисциплина],[Код_преподавателя])
go

-- Table Дисциплина

CREATE TABLE [Дисциплина]
(
 [Код_дисциплина] Int NOT NULL,
 [Название] Nvarchar(20) NOT NULL,
 [Описание] Nvarchar(1000) NOT NULL,
 [Год_введения_по_стандарту] Int NOT NULL
)
go

-- Add keys for table Дисциплина

ALTER TABLE [Дисциплина] ADD CONSTRAINT [PK_Дисциплина] PRIMARY KEY ([Код_дисциплина])
go

-- Create foreign keys (relationships) section ------------------------------------------------- 


ALTER TABLE [Расписание] ADD CONSTRAINT [Relationship1] FOREIGN KEY ([Номер_группы]) REFERENCES [Группа] ([Номер_группы]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Расписание] ADD CONSTRAINT [Relationship2] FOREIGN KEY ([Код_дисциплина], [Код_преподавателя]) REFERENCES [Нагрузка] ([Код_дисциплина], [Код_преподавателя]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Нагрузка] ADD CONSTRAINT [Relationship3] FOREIGN KEY ([Код_дисциплина]) REFERENCES [Дисциплина] ([Код_дисциплина]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Нагрузка] ADD CONSTRAINT [Relationship4] FOREIGN KEY ([Код_преподавателя]) REFERENCES [Преподаватель] ([Код_преподавателя]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Расписание] ADD CONSTRAINT [Relationship5] FOREIGN KEY ([Номер_лаборатории]) REFERENCES [Лаборатория] ([Номер_лаборатории]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Студент] ADD CONSTRAINT [Relationship6] FOREIGN KEY ([Номер_группы]) REFERENCES [Группа] ([Номер_группы]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Группа] ADD CONSTRAINT [Relationship7] FOREIGN KEY ([Код_преподавателя]) REFERENCES [Преподаватель] ([Код_преподавателя]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Группа] ADD CONSTRAINT [Relationship8] FOREIGN KEY ([Код_факультета]) REFERENCES [Факультет] ([Код_факультета]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Кафедра] ADD CONSTRAINT [Relationship9] FOREIGN KEY ([Код_факультета]) REFERENCES [Факультет] ([Код_факультета]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Преподаватель] ADD CONSTRAINT [Relationship10] FOREIGN KEY ([Код_кафедры]) REFERENCES [Кафедра] ([Код_кафедры]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Кафедра] ADD CONSTRAINT [Relationship11] FOREIGN KEY ([Зав_кафедрой]) REFERENCES [Преподаватель] ([Код_преподавателя]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Лаборатория] ADD CONSTRAINT [Relationship12] FOREIGN KEY ([Код_кафедры]) REFERENCES [Кафедра] ([Код_кафедры]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Лаборатория] ADD CONSTRAINT [Relationship13] FOREIGN KEY ([Код_преподавателя]) REFERENCES [Преподаватель] ([Код_преподавателя]) ON UPDATE NO ACTION ON DELETE NO ACTION
go





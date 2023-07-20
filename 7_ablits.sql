CREATE TABLE [���������]
(
 [���_����������] Int NOT NULL,
 [��������_����������] Nvarchar(50) NOT NULL,
 [����_���������] Date NOT NULL,
 [���_������������] Nvarchar(50) NOT NULL,
 [����_���_��_���������] Int NOT NULL
)
go

-- Add keys for table ���������

ALTER TABLE [���������] ADD CONSTRAINT [PK_���������] PRIMARY KEY ([���_����������])
go

-- Table �������

CREATE TABLE [�������]
(
 [���_�������] Int NOT NULL,
 [��������_�������] Nvarchar(50) NOT NULL,
 [�����������_�������] Nvarchar(50) NOT NULL,
 [����] Nvarchar(50) NOT NULL,
 [�������] Nchar(11) NOT NULL,
 [���_����������] Int NOT NULL,
 [���_��������] Int NOT NULL
)
go

-- Create indexes for table �������

CREATE INDEX [IX_Relationship9] ON [�������] ([���_����������])
go

CREATE INDEX [IX_Relationship11] ON [�������] ([���_��������])
go

-- Add keys for table �������

ALTER TABLE [�������] ADD CONSTRAINT [PK_�������] PRIMARY KEY ([���_�������])
go

-- Table ������

CREATE TABLE [������]
(
 [�����_������] Nchar(14) NOT NULL,
 [����_���_��_�������] Int NOT NULL,
 [���_�������������] Int NULL,
 [���_����������] Int NULL
)
go

-- Create indexes for table ������

CREATE INDEX [IX_Relationship7] ON [������] ([���_�������������])
go

CREATE INDEX [IX_Relationship8] ON [������] ([���_����������])
go

-- Add keys for table ������

ALTER TABLE [������] ADD CONSTRAINT [PK_������] PRIMARY KEY ([�����_������])
go

-- Table �������������

CREATE TABLE [�������������]
(
 [���_�������������] Int NOT NULL,
 [�������] Nvarchar(20) NOT NULL,
 [���] Nvarchar(20) NOT NULL,
 [��������] Nvarchar(20) NOT NULL,
 [�����������] Nvarchar(20) NOT NULL,
 [����] Int NOT NULL,
 [����������_�������] Nchar(11) NOT NULL,
 [���_�������] Int NOT NULL
)
go

-- Create indexes for table �������������

CREATE INDEX [IX_Relationship10] ON [�������������] ([���_�������])
go

-- Add keys for table �������������

ALTER TABLE [�������������] ADD CONSTRAINT [PK_�������������] PRIMARY KEY ([���_�������������])
go

-- Table �������

CREATE TABLE [�������]
(
 [���_��������] Int NOT NULL,
 [�������] Nvarchar(20) NOT NULL,
 [���] Nvarchar(20) NOT NULL,
 [��������] Nvarchar(20) NOT NULL,
 [����_��������] Date NOT NULL,
 [�����] Nvarchar(100) NOT NULL,
 [�������] Nchar(11) NOT NULL,
 [�����_������] Nchar(14) NULL
)
go

-- Create indexes for table �������

CREATE INDEX [IX_Relationship6] ON [�������] ([�����_������])
go

-- Add keys for table �������

ALTER TABLE [�������] ADD CONSTRAINT [PK_�������] PRIMARY KEY ([���_��������])
go

-- Table ����������

CREATE TABLE [����������]
(
 [����_������] Int NOT NULL,
 [�����_����] Int NOT NULL,
 [�����_������] Nchar(14) NOT NULL,
 [���_����������] Int NOT NULL,
 [����������] Nvarchar(100) NOT NULL,
 [���_�������������] Int NOT NULL,
 [�����_�����������] Int NOT NULL
)
go

-- Create indexes for table ����������

CREATE INDEX [IX_Relationship5] ON [����������] ([�����_�����������])
go

-- Add keys for table ����������

ALTER TABLE [����������] ADD CONSTRAINT [PK_����������] PRIMARY KEY ([����_������],[�����_����],[�����_������],[���_����������],[���_�������������])
go

-- Table �����������

CREATE TABLE [�����������]
(
 [�����_�����������] Int NOT NULL,
 [��������] Nvarchar(50) NOT NULL,
 [���_������������] Nvarchar(20) NOT NULL,
 [����������_�������_����] Int NOT NULL,
 [�������_����������_������������] Bit NOT NULL,
 [���_�������] Int NULL,
 [���_�������������] Int NULL
)
go

-- Create indexes for table �����������

CREATE INDEX [IX_Relationship12] ON [�����������] ([���_�������])
go

CREATE INDEX [IX_Relationship13] ON [�����������] ([���_�������������])
go

-- Add keys for table �����������

ALTER TABLE [�����������] ADD CONSTRAINT [PK_�����������] PRIMARY KEY ([�����_�����������])
go

-- Table ��������

CREATE TABLE [��������]
(
 [���������_����] Int NOT NULL,
 [���������_������] Int NOT NULL,
 [���_����������] Int NOT NULL,
 [���_�������������] Int NOT NULL
)
go

-- Add keys for table ��������

ALTER TABLE [��������] ADD CONSTRAINT [PK_��������] PRIMARY KEY ([���_����������],[���_�������������])
go

-- Table ����������

CREATE TABLE [����������]
(
 [���_����������] Int NOT NULL,
 [��������] Nvarchar(20) NOT NULL,
 [��������] Nvarchar(1000) NOT NULL,
 [���_��������_��_���������] Int NOT NULL
)
go

-- Add keys for table ����������

ALTER TABLE [����������] ADD CONSTRAINT [PK_����������] PRIMARY KEY ([���_����������])
go

-- Create foreign keys (relationships) section ------------------------------------------------- 


ALTER TABLE [����������] ADD CONSTRAINT [Relationship1] FOREIGN KEY ([�����_������]) REFERENCES [������] ([�����_������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [����������] ADD CONSTRAINT [Relationship2] FOREIGN KEY ([���_����������], [���_�������������]) REFERENCES [��������] ([���_����������], [���_�������������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [��������] ADD CONSTRAINT [Relationship3] FOREIGN KEY ([���_����������]) REFERENCES [����������] ([���_����������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [��������] ADD CONSTRAINT [Relationship4] FOREIGN KEY ([���_�������������]) REFERENCES [�������������] ([���_�������������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [����������] ADD CONSTRAINT [Relationship5] FOREIGN KEY ([�����_�����������]) REFERENCES [�����������] ([�����_�����������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�������] ADD CONSTRAINT [Relationship6] FOREIGN KEY ([�����_������]) REFERENCES [������] ([�����_������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [������] ADD CONSTRAINT [Relationship7] FOREIGN KEY ([���_�������������]) REFERENCES [�������������] ([���_�������������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [������] ADD CONSTRAINT [Relationship8] FOREIGN KEY ([���_����������]) REFERENCES [���������] ([���_����������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�������] ADD CONSTRAINT [Relationship9] FOREIGN KEY ([���_����������]) REFERENCES [���������] ([���_����������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�������������] ADD CONSTRAINT [Relationship10] FOREIGN KEY ([���_�������]) REFERENCES [�������] ([���_�������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�������] ADD CONSTRAINT [Relationship11] FOREIGN KEY ([���_��������]) REFERENCES [�������������] ([���_�������������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�����������] ADD CONSTRAINT [Relationship12] FOREIGN KEY ([���_�������]) REFERENCES [�������] ([���_�������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [�����������] ADD CONSTRAINT [Relationship13] FOREIGN KEY ([���_�������������]) REFERENCES [�������������] ([���_�������������]) ON UPDATE NO ACTION ON DELETE NO ACTION
go





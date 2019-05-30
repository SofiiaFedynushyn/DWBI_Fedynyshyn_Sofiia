CREATE DATABASE S_Fedynyshyn_modul_2;
go
USE S_Fedynyshyn_modul_2;

-- Create parent table dbo.client
 CREATE TABLE dbo.Client
 (
 id_Client INT NOT NULL,
 first_name NVARCHAR (100) NOT NULL,
 last_name NVARCHAR (150) NOT NULL,
 gender NCHAR (1) NULL,
 birthday DATE NOT NULL,
 state NVARCHAR (150) NOT NULL,
 city NVARCHAR (150) NOT NULL,
 fone_namber NVARCHAR (50) NULL,
 email NVARCHAR (100) NULL,
 inserted_date DATETIME NULL,
 updated_date DATETIME NULL
 );
-- Create constraints
ALTER TABLE [dbo].[Client]
ADD CONSTRAINT pk_client PRIMARY KEY ([id_Client]);

ALTER TABLE [dbo].[Client] 
ADD CONSTRAINT uq_fone_client UNIQUE ([fone_namber]);

ALTER TABLE [dbo].[Client]
ADD CONSTRAINT ck_birthday CHECK ([birthday] <= '20010101');

-- Create childe table
CREATE TABLE dbo.Sale
(
id_Sale INT NOT NULL,
id_Client INT NOT NULL,
car_number NVARCHAR (50) NOT NULL,
model NVARCHAR (100) NOT NULL,
color NVARCHAR (100) NULL,
car_year INT NOT NULL,
price DECIMAL (15,2) NOT NULL,
mileage DECIMAL (20,2) NOT NULL,
inserted_date DATETIME NULL,
updated_date DATETIME NULL
 );

 --Create constraints

 ALTER TABLE [dbo].[Sale]
 ADD CONSTRAINT pk_sale PRIMARY KEY ([id_Sale]);

 ALTER TABLE [dbo].[Sale]
 ADD CONSTRAINT fk_sale_client FOREIGN KEY ([id_Client]) REFERENCES [dbo].[Client] ([id_Client]);

 ALTER TABLE [dbo].[Sale]
 ADD CONSTRAINT uq_car_number UNIQUE ([car_number]);
 go

 -- Create view for parent table
CREATE VIEW Client_view
WITH SCHEMABINDING 
AS 
SELECT
[id_Client], 
[first_name],
[last_name], 
[birthday], 
[state], 
[city], 
[fone_namber], 
[email]
FROM [dbo].[Client];
go

--Create view for child table

CREATE VIEW Sale_view 
AS
SELECT 
[id_Sale], 
[id_Client], 
[car_number], 
[model], 
[color], 
[car_year], 
[price], 
[mileage] 
FROM [dbo].[Sale]
WITH CHECK OPTION;
go

 --Insert data in the table [dbo].[Client] 
 INSERT INTO [dbo].[Client]
([id_Client], [first_name], [last_name], [gender], [birthday], [state], [city], [fone_namber], [email])
VALUES
(1, 'Джилиан', 'Андерсон', 'Ж', '19800509', 'СА', 'Пало-Альто', 892775750063, 'jill_anderson@breakneckpizza.com');

 --Insert data in the table [dbo].[Client] to check if the all constraint will work
INSERT INTO [dbo].[Client]
([id_Client], [first_name], [last_name], [gender], [birthday], [state], [city], [fone_namber], [email])
VALUES                --CHECK constraint "ck_birthday"
(2, 'Пет', 'Гек', 'М', '2001-06-11', 'NJ', 'Принстон', 161968374323, 'patpost@breakneckpizza.com');

INSERT INTO [dbo].[Client]
([id_Client], [first_name], [last_name], [gender], [birthday], [state], [city], [fone_namber], [email])
VALUES  -- CHECK PRIMARY KEY constraint 'pk_client'
(1, 'Пет', 'Гек', 'М', '1089-06-11', 'NJ', 'Принстон', 161968374323, 'patpost@breakneckpizza.com');

INSERT INTO [dbo].[Client]
([id_Client], [first_name], [last_name], [gender], [birthday], [state], [city], [fone_namber], [email])
VALUES  -- CHECK UNIQUE KEY constraint 'uq_fone_client'
(2, 'Пет', 'Гек', 'М', '1089-06-11', 'NJ', 'Принстон', 892775750063, 'patpost@breakneckpizza.com');

--just  interesting to insert data by view
INSERT INTO [dbo].[Client_view]
VALUES 
(2, 'Пет', 'Гек', '1089-06-11', 'NJ', 'Принстон', 161968374323, 'patpost@breakneckpizza.com');
go


 --Insert data in the table [dbo].[Sale]
INSERT INTO [dbo].[Sale]
([id_Sale], [id_Client], [car_number], [model], [color], [car_year], [price], [mileage])
VALUES 
(1, 1, 'California 4BJE103', 'Mercedes E320 W211', 'silver', 2003, '29000', '97000'),
(2, 2, 'New Jersey E56 BTX Garden State', 'Jaguar', 'blue', 1997, '15000', '120000');
go

-- Insert just for fun
INSERT INTO [dbo].[Sale]
([id_Sale], [id_Client], [car_number], [model], [color], [car_year], [price], [mileage])
VALUES 
(2, 1, 'ВС 3700 ТР', 'Москвич 2140	', 'silver', 1981, '600', '250000');

INSERT INTO [dbo].[Sale]
([id_Sale], [id_Client], [car_number], [model], [color], [car_year], [price], [mileage])
VALUES 
(3, 4, 'ВС 3700 ТР', 'Москвич 2140	', 'silver', 1981, '600', '250000');

INSERT INTO [dbo].[Sale]
([id_Sale], [id_Client], [car_number], [model], [color], [car_year], [price], [mileage])
VALUES 
(3, 2, 'ВС 3700 ТР', 'Москвич 2140	', 'silver', 1981, '600', '250000');
go


--Creating trigger for [dbo].[Client] and [dbo].[Sale] table
-- AFTER UPDATE for [dbo].TR_Client 
CREATE TRIGGER [dbo].TR_Client ON [dbo].[Client]
AFTER UPDATE
AS
BEGIN
IF @@ROWCOUNT=0 RETURN;

IF EXISTS(
SELECT C.[id_Client] 
FROM [dbo].[Client] AS C
INNER JOIN INSERTED AS INS ON C.id_Client = INS.id_Client
INNER JOIN DELETED AS DEL ON C.id_Client = DEL.id_Client)

	
UPDATE [dbo].[Client]
SET [updated_date] = GETDATE()
FROM [dbo].[Client] AS C
INNER JOIN INSERTED AS INS ON C.id_Client = INS.id_Client

END
go

-- record for verification
DELETE FROM [dbo].[Client] WHERE [id_Client] = 4;

INSERT INTO [dbo].[Client]
([id_Client], [first_name], [last_name], [gender], [birthday], [state], [city], [fone_namber], [email])
VALUES               
(4, 'Пет', 'Гек', 'М', '1985-06-11', 'IV', 'Принстон', 161968374377, 'patpost@breakneckpizza.com');

UPDATE [dbo].[Client]
SET [birthday] = '2015-06-11'
WHERE [id_Client] = 4

SELECT * FROM [dbo].[Client]
WHERE [id_Client] = 4
go

-- AFTER INSERT for [dbo].[Sale]
CREATE TRIGGER [dbo].Sale_trigger ON [dbo].[Sale]
AFTER INSERT
AS
BEGIN
IF @@ROWCOUNT = 0 RETURN;
IF EXISTS (
SELECT S.[id_Sale] FROM [dbo].[Sale] S
INNER JOIN INSERTED I ON S.[id_Sale]=I.[id_Sale])

UPDATE [dbo].[Sale]
SET [inserted_date]=GETDATE ()
FROM [dbo].[Sale] AS S
INNER JOIN INSERTED I ON S.[id_Sale]=I.[id_Sale]
END
go
-- record for verification
INSERT INTO [dbo].[Sale]
([id_Sale], [id_Client], [car_number], [model], [color], [car_year], [price], [mileage])
VALUES 
(4, 2, 'New Jersey 000 BTX Garden State', 'Jaguar', 'blue', 1997, '15000', '120000');

SELECT * FROM [dbo].[Sale]
go

--AFTER UPDATE for [dbo].[Sale] UPDATE
CREATE TRIGGER [dbo].Sale_trig2 ON [dbo].[Sale]
AFTER UPDATE
AS 
BEGIN
IF @@ROWCOUNT=0 RETURN;
IF EXISTS (

SELECT S.[id_Sale] FROM [dbo].[Sale] S
INNER JOIN DELETED D ON S.[id_Sale]=D.[id_Sale]
INNER JOIN INSERTED I ON S.[id_Sale]=I.[id_Sale])

UPDATE [dbo].[Sale]
SET [updated_date]=GETDATE ()
FROM [dbo].[Sale] AS S
INNER JOIN INSERTED I ON S.[id_Sale]=I.[id_Sale]
END
go

-- record for verification
UPDATE [dbo].[Sale]
SET [color] = 'RED'
WHERE [id_Sale] = 4;

SELECT * FROM [dbo].[Sale]
go


-- Сreate a table of 15 columns
CREATE TABLE dbo.world_country 
(
id_Country INT PRIMARY KEY  NOT NULL, 
Code CHAR (3) NOT NULL,
Name NVARCHAR (60) NOT NULL,
Continent NVARCHAR (80) NOT NULL,
Region NVARCHAR (50) NOT NULL,
SurfaceArea DECIMAL (10,2) NOT NULL DEFAULT '0,00',
IndepYear INT NULL,
Population INT NOT NULL DEFAULT '0',
LifeExpectancy DECIMAL (3,1) NULL,
GNP DECIMAL (10,2) NULL,
GNPOld DECIMAL (10,2) NULL,
LocalName NVARCHAR (60) NOT NULL,
GovernmentForm NVARCHAR (60) NOT NULL,
HeadOfState NVARCHAR (60) NULL,
Capital INT NULL
);

--Create 2nd table the same structure with audit columns
CREATE TABLE dbo.world_country_audit
(
id_Country INT  NOT NULL, 
Code CHAR (3) NOT NULL,
Name NVARCHAR (60) NOT NULL,
Continent NVARCHAR (80) NOT NULL,
Region NVARCHAR (50) NOT NULL,
SurfaceArea DECIMAL (10,2) NOT NULL DEFAULT '0,00',
IndepYear INT NULL,
Population INT NOT NULL DEFAULT '0',
LifeExpectancy DECIMAL (3,1) NULL,
GNP DECIMAL (10,2) NULL,
GNPOld DECIMAL (10,2) NULL,
LocalName NVARCHAR (60) NOT NULL,
GovernmentForm NVARCHAR (60) NOT NULL,
HeadOfState NVARCHAR (60) NULL,
Capital INT NULL,
Type_operation VARCHAR (10) NULL,
Date_operation DATETIME NULL,
);
go


--Creating AFTER INSERT, DELETE, UPDATE trigger for [dbo].[world_country] with the filling of the [dbo].[world_country_audit] table
CREATE TRIGGER [dbo].TR_world_country_audit ON [dbo].[world_country]
AFTER INSERT,DELETE, UPDATE
AS
BEGIN

IF @@ROWCOUNT=0 RETURN
DECLARE @Type_operation CHAR (1)
DECLARE @ins INT= (SELECT COUNT (*) FROM INSERTED)
DECLARE @del INT= (SELECT COUNT (*) FROM DELETED)

SET @Type_operation =
CASE
WHEN @ins > 0 AND @del > 0 THEN 'U'
WHEN @ins = 0 AND @del > 0 THEN 'D'
WHEN @ins > 0 AND @del = 0 THEN 'I'
END

--INSERT
IF @Type_operation = 'I'
BEGIN
INSERT INTO [dbo].[world_country_audit]
(id_Country, Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, 
GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, Type_operation, Date_operation)

SELECT W.id_Country, W.Code, W.Name, W.Continent, W.Region, W.SurfaceArea, W.IndepYear, W.Population, W.LifeExpectancy, 
W.GNP, W.GNPOld, W.LocalName, W.GovernmentForm, W.HeadOfState, W.Capital, @Type_operation, GETDATE ()
FROM [dbo].[world_country] W
INNER JOIN INSERTED I ON W.[id_Country]=I.[id_Country] 
END

-- DELETED
IF @Type_operation = 'D'
BEGIN
INSERT INTO [dbo].[world_country_audit]
(id_Country, Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, 
GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, Type_operation, Date_operation)

SELECT id_Country, Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, 
GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, @Type_operation, GETDATE ()
FROM DELETED
END

--UPDATE
IF @Type_operation = 'U'
BEGIN
INSERT INTO [dbo].[world_country_audit]
(id_Country, Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, 
GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, Type_operation, Date_operation)

SELECT W.id_Country, W.Code, W.Name, W.Continent, W.Region, W.SurfaceArea, W.IndepYear, W.Population, W.LifeExpectancy, 
W.GNP, W.GNPOld, W.LocalName, W.GovernmentForm, W.HeadOfState, W.Capital, @Type_operation, GETDATE ()
FROM [dbo].[world_country] W
INNER JOIN DELETED D ON W.[id_Country] = D.[id_Country]
INNER JOIN INSERTED I ON W.[id_Country] = I.[id_Country]
END
END
GO

-- record for verification
INSERT INTO [dbo].[world_country]
(id_Country, Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, 
GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital)
VALUES
(1, 'ABW', 'Aruba', 'North America', 'Caribbean', 193.00, 1919, 103000, 78.4,	828.00,	793.00,	'Aruba', 
'Nonmetropolitan Territory of The Netherlands',	'Beatrix', 129),
(2,	'AGO', 'Angola', 'Africa', 'Central Africa', 1246700.00, 1975, 12878000, 38.3, 6648.00,	7984.00,
'Angola', 'Republic', 'JosÃ© Eduardo dos Santos', 56)


UPDATE [dbo].[world_country]
SET [Continent]= 'South America'
WHERE [Continent] = 'North America';

DELETE from [dbo].[world_country]
where [id_Country] = 1

select * from [dbo].[world_country]
select * from [dbo].[world_country_audit]

go
 
--CREATE SYNONYM and SCHEMA
CREATE SCHEMA S_Fedynyshyn;
go

CREATE SYNONYM S_Fedynyshyn.[Client] FOR [dbo].[Client];
CREATE SYNONYM S_Fedynyshyn.[Sale] FOR [dbo].[Sale];
CREATE SYNONYM S_Fedynyshyn.[world_country] FOR [dbo].[world_country];
CREATE SYNONYM S_Fedynyshyn.[world_country_audit] FOR [dbo].[world_country_audit];
go

SELECT * FROM [S_Fedynyshyn].[Client];
SELECT * FROM [S_Fedynyshyn].[Sale];
SELECT * FROM [S_Fedynyshyn].[world_country];
SELECT * FROM [S_Fedynyshyn].[world_country_audit];
go
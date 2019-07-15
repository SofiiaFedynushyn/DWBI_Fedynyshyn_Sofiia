-- Create database and table
CREATE DATABASE S_Fedynyshyn_modul_6;
GO
USE S_Fedynyshyn_modul_6;
GO

DROP TABLE IF EXISTS [dbo].[Supplies];
DROP TABLE IF EXISTS [dbo].[Suppliers];
DROP TABLE IF EXISTS [dbo].[Details];
DROP TABLE IF EXISTS [dbo].[Products];

CREATE TABLE dbo.Suppliers
(
supplier_id INT PRIMARY KEY NOT NULL,
name NVARCHAR (20) NOT NULL,
rating INT NULL,
city NVARCHAR (20) NULL 
);

CREATE TABLE dbo.Details
(
detail_id INT NOT NULL PRIMARY KEY,
name NVARCHAR (20) NOT NULL,
color NVARCHAR (20) NOT NULL,
weight INT NOT NULL,
city NVARCHAR (20) NOT NULL
);

CREATE TABLE dbo.Products
(
product_id INT PRIMARY KEY NOT NULL,
name NVARCHAR (20) NOT NULL,
city NVARCHAR (20) NOT NULL
);

CREATE TABLE dbo.Supplies
(
supplies_id INT NOT NULL PRIMARY KEY IDENTITY,
supplier_id INT NOT NULL CONSTRAINT  FK_Supplies_Supplier  FOREIGN KEY REFERENCES dbo.Suppliers  ([supplier_id]),
detail_id INT NOT NULL CONSTRAINT FK_Supplies_Details FOREIGN KEY REFERENCES [dbo].[Details] ([detail_id]),
product_id INT NOT NULL CONSTRAINT FK_Supplies_Products FOREIGN KEY REFERENCES [dbo].[Products] ([product_id]),
quantity INT NOT NULL 
);
go

INSERT INTO dbo.Details  
VALUES
(1, 'Screw', 'Red', 12, 'London'),
(2, 'Bolt', 'Green', 17, 'Paris'),
(3, 'Male-screw', 'Blue', 17, 'Roma'),
(4, 'Male-screw', 'Red', 14, 'London'),
(5, 'Whell', 'Blue', 12, 'Paris'),
(6, 'Bloom', 'Red', 19, 'London');

INSERT INTO [dbo].[Suppliers]
VALUES 
(1, 'Smith', 20, 'London'),
(2, 'Jonth', 10, 'Paris'),
(3, 'Blacke', 30, 'Paris'),
(4, 'Clarck', 20, 'London'),
(5, 'Adams', 30, 'Athens');

INSERT INTO [dbo].[Products]
VALUES
(1, 'HDD', 'Paris'),
(2, 'Perforator', 'Roma'),
(3, 'Reader', 'Athens'),
(4, 'Printer', 'Athens'),
(5, 'FDD', 'London'),
(6, 'Terminal', 'Oslo'),
(7, 'Ribbon', 'London');

INSERT INTO  [dbo].[Supplies]
VALUES
(1,	1,	1,	200),
(1,	1,	4,	700),
(2,	3,	1,	400),
(2,	3,	2,	200),
(2,	3,	3,	200),
(2,	3,	4,	500),
(2,	3,	5,	600),
(2,	3,	6,	400),
(2,	3,	7,	800),
(2,	5,	2,	100),
(3,	3,	1,	200),
(3,	4,	2,	500),
(4,	6,	3,	300),
(4,	6,	7,	300),
(5,	2,	2,	200),
(5,	2,	4,	100),
(5,	5,	5,	500),
(5,	5,	7,	100),
(5,	6,	2,	200),
(5,	1,	4,	100),
(5,	3,	4,	200),
(5,	4,	4,	800),
(5,	5,	4,	400),
(5,	6,	4,	500);
go

--writing tasks
--1
SELECT [product_id], [name], [city], ROW_NUMBER () OVER (ORDER BY [city]) AS порядковий_номер
FROM [dbo].[Products];
go

--2
SELECT [product_id], [name], [city], ROW_NUMBER () OVER
	               (PARTITION BY [city] ORDER BY [name]) AS порядковий_номер
FROM [dbo].[Products];
go

--3
SELECT [product_id], [name], [city], [порядковий_номер_в_межах_міста]
FROM
	(SELECT [product_id], [name], [city], ROW_NUMBER () OVER
	               (PARTITION BY [city] ORDER BY [name]) AS порядковий_номер_в_межах_міста
FROM [dbo].[Products]) AS CTE
WHERE порядковий_номер_в_межах_міста = 1;
go

--4
SELECT [product_id], [detail_id], [quantity],
     SUM([quantity]) OVER (PARTITION BY [product_id]) AS all_quantity_per_prod,
	 SUM([quantity]) OVER (PARTITION BY [detail_id]) AS all_quantity_per_det
FROM [dbo].[Supplies];
go

--5
SELECT  [supplies_id], [detail_id], [product_id], [quantity], [RN], [TOT]
FROM
	(SELECT [supplies_id], [detail_id], [product_id], [quantity],
	 ROW_NUMBER () OVER (ORDER BY [supplier_id]) AS RN,
	 COUNT ([supplier_id]) OVER () AS TOT
FROM [dbo].[Supplies] ) AS CTE
WHERE RN BETWEEN 10 AND 15;
go

--6
SELECT [supplies_id], [detail_id], [product_id], [quantity], [avg_qty]
FROM
	(SELECT [supplies_id], [detail_id], [product_id], [quantity], AVG ([quantity]) OVER () AS avg_qty
FROM [dbo].[Supplies]) AS CTE_avg
WHERE [quantity] < [avg_qty];
go
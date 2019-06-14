CREATE DATABASE S_Fedynyshyn_modul_3;
GO
USE S_Fedynyshyn_modul_3;
GO

DROP TABLE IF EXISTS [dbo].[Supplies];
DROP TABLE IF EXISTS [dbo].[Suppliers];
DROP TABLE IF EXISTS [dbo].[Details];
DROP TABLE IF EXISTS [dbo].[Products];
DROP TABLE IF EXISTS [dbo].[New_Details];
DROP TABLE IF EXISTS [dbo].[New_Product];
DROP TABLE IF EXISTS [dbo].[New_Suppliers];
DROP TABLE IF EXISTS [dbo].[tmp_Details];
GO

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
GO
  
--- 1
UPDATE [dbo].[Suppliers] 
SET [rating] = R.[rating]+10
FROM [dbo].[Suppliers] R
WHERE [rating] < 
(SELECT [rating] FROM [dbo].[Suppliers]
WHERE [supplier_id] =4)
GO
-- SELECT * FROM [dbo].[Suppliers]
-- WHERE [rating] < 
-- (SELECT [rating] FROM [dbo].[Suppliers]
-- WHERE [suppliersid] =4)


--2
SELECT T.[product_id], T.city
INTO #TEMP_TABLE
FROM
	(SELECT [product_id],city  FROM [dbo].[Products]
	WHERE city = 'london'
		UNION
	SELECT P.[product_id], SR.city 
	FROM [dbo].[Products] P
	INNER join [dbo].[Supplies] S ON P.[product_id]= S.[product_id]
	INNER JOIN [dbo].[Details] D ON  S.[detail_id]=D.[detail_id]
	INNER JOIN [dbo].[Suppliers] SR ON S.supplier_id = SR.supplier_id
	WHERE SR.city = 'london') T

-- SELECT * FROM #TEMP_TABLE
go

--3
DELETE FROM [dbo].[Products]
WHERE [product_id] =
    (SELECT P.[product_id]
	FROM [dbo].[Products] P
	INNER JOIN [dbo].[Supplies] S ON P.[product_id]= S.[product_id]
	INNER JOIN [dbo].[Details] D ON   D.[detail_id] = S.[detail_id]
	WHERE  D.[detail_id] NOT IN 
							(SELECT DISTINCT [detail_id] FROM [dbo].[Supplies])
	);
	GO


-- 4 I can not accomplish this task because I do not understand what the end result should be
-- if possible I will send it later in a separate file

--5
	UPDATE [dbo].[Supplies]
	SET [quantity]=[quantity]*1.1
	FROM [dbo].[Supplies] 
	WHERE exists
	(select  D.[detail_id], D.color, S.[quantity] 
	from [dbo].[Details] as D
	inner join [dbo].[Supplies] AS S on D.detail_id=S.product_id
	inner join [dbo].[Suppliers] AS SR on SR.supplier_id=S.supplier_id
	where D.color='Red');
	go

--6
SELECT DISTINCT  N.[detail_id], N.[name], N.[color_city], N.[weight]
INTO dbo.New_Details 
FROM
(SELECT 
[detail_id], 
[name], 
[color]+[city]AS [color_city],
[weight]
FROM [dbo].[Details]) AS N;

 --SELECT * FROM dbo.New_Details 
 GO

--7
SELECT DE.Detail_id
INTO #TEMP_TABLE_DETAIL
FROM
(SELECT DISTINCT [detail_id] FROM [dbo].[Details] 
WHERE EXISTS
(SELECT SR.[supplier_id] FROM [dbo].[Suppliers] AS SR
INNER JOIN [dbo].[Supplies] AS S ON SR.[supplier_id]=S.[supplier_id]
INNER JOIN [dbo].[Products] AS P ON P.[product_id]=S.[product_id]
WHERE P.[city]='London' OR SR.[city] = 'London')) DE;

--SELECT * FROM #TEMP_TABLE_DETAIL
GO

--8
INSERT INTO [dbo].[Suppliers]
([supplier_id], [name], [city])
VALUES
(10, '”айт', 'Ќью-…орк');

--SELECT * FROM [dbo].[Suppliers]
GO

--9
ALTER TABLE [dbo].[Supplies]  
drop  CONSTRAINT FK_Supplies_Products 

ALTER TABLE [dbo].[Supplies]
ADD CONSTRAINT FK_Supplies_Products FOREIGN KEY ([product_id])
REFERENCES [dbo].[Products] ([product_id])
ON DELETE CASCADE 
 
DELETE FROM [dbo].[Products]
WHERE city='Roma';
go

--10
SELECT  C.[detail_id], C.[city] INTO dbo.city_detail
FROM
(SELECT [detail_id], [city] FROM [dbo].[Details]
UNION
SELECT [product_id], [city] FROM [dbo].[Products]
UNION
SELECT [supplier_id], [city] FROM [dbo].[Suppliers]) AS C
ORDER BY C.[city];

--SELECT * FROM  [dbo].[city_detail]
GO

--11
UPDATE [dbo].[Details]
SET [color]='Yellow'
WHERE [color]='Red' AND [weight]<15;

-- SELECT * FROM [dbo].[Details]
--WHERE color='Yellow'
GO

--12
SELECT NP.[product_id], NP.[city] INTO dbo.New_Product
FROM
(SELECT [product_id], [city] FROM [dbo].[Products]
WHERE [city] LIKE '_o%') AS NP;

-- SELECT * FROM [dbo].[New_Product]
go

--13
UPDATE [dbo].[Suppliers]
SET [rating]= SR.[rating]+10 FROM [dbo].[Suppliers] SR
  INNER JOIN [dbo].[Supplies] S ON S.[supplies_id]=SR.[supplier_id]
  WHERE   [quantity] <
 (select avg ([quantity]) from [dbo].[Supplies]);
go

--14
SELECT SUP.[supplier_id], SUP.[name] INTO dbo.New_Suppliers
FROM
(SELECT SR.[supplier_id], SR.[name] FROM [dbo].[Suppliers] SR
INNER JOIN [dbo].[Supplies] S ON SR.[supplier_id]=S.[supplies_id]
INNER JOIN [dbo].[Details] D ON S.[supplies_id]=D.[detail_id]
WHERE [product_id]=1) AS SUP
ORDER BY SUP.[supplier_id];	  

-- SELECT * FROM [dbo].[New_Suppliers]
go

--15
INSERT INTO [dbo].[Suppliers]
VALUES
(6, 'JON', '', 'Athens'),
(7, 'BRAIN', '', 'London');
go

-- MERGE TASK
CREATE TABLE dbo.tmp_Details 
(
detail_id INT NOT NULL PRIMARY KEY,
name NVARCHAR (20) NOT NULL,
color NVARCHAR (20) NOT NULL,
weight INT NOT NULL,
city NVARCHAR (20) NOT NULL
);

INSERT INTO tmp_Details (detail_id, name, color, weight, city) 
VALUES 
(1, 'Screw', 'Blue', 13, 'Osaka'),
(2, 'Bolt', 'Pink', 12, 'Tokio'),
(18, 'Whell-24', 'Red', 14, 'Lviv'),
(19, 'Whell-28', 'Pink', 15, 'London');
go

-- We have constraint in the table. So that we have the ability to perform the necessary actions, 
--we need to change the constraint using the Alter

ALTER TABLE [dbo].[Supplies]  
DROP  CONSTRAINT [FK_Supplies_Details]

ALTER TABLE [dbo].[Supplies]
ADD CONSTRAINT [FK_Supplies_Details] FOREIGN KEY ([detail_id])
REFERENCES [dbo].[Details] ([detail_id])
ON UPDATE CASCADE;
GO


--Now we can accomplish the task
MERGE [dbo].[Details] AS D
USING
        (SELECT [detail_id], [name], [color], [weight], [city] 
         FROM [dbo].[tmp_Details]) AS TD ([detail_id], [name], [color], [weight], [city])
	ON (D.[detail_id]=TD.[detail_id])
WHEN MATCHED THEN 
UPDATE SET D.[detail_id]=TD.[detail_id],
           D.[name]=TD.[name],
		   D.[color]=TD.[color],
		   D.[weight]=TD.[weight],
		   D.[city]=TD.[city]
WHEN NOT MATCHED THEN 
          INSERT ([detail_id], [name], [color], [weight], [city])
		  VALUES (TD.[detail_id], TD.[name], TD.[color], TD.[weight], TD.[city]);
 
 --select * from [dbo].[Details]
 GO
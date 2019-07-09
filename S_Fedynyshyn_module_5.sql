CREATE DATABASE S_Fedynyshyn_modul_5;
GO
USE S_Fedynyshyn_modul_5;
GO

DROP TABLE IF EXISTS [dbo].[Supplies];
DROP TABLE IF EXISTS [dbo].[Suppliers];
DROP TABLE IF EXISTS [dbo].[Details];
DROP TABLE IF EXISTS [dbo].[Products];
DROP TABLE IF EXISTS [dbo].[geography];

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

--Writing queries using sub-queries

--1
SELECT Pr.[product_id] FROM 
(SELECT P.[product_id] FROM [dbo].[Products] AS P
   INNER JOIN [dbo].[Supplies] AS S ON P.[product_id]=S.product_id
   INNER JOIN [dbo].[Suppliers] SR ON S.[supplier_id]=SR.[supplier_id]
   INNER JOIN [dbo].[Details] AS D ON S.[detail_id]=D.[detail_id]
WHERE SR.[supplier_id]=3) AS PR;
go


--2
SELECT SR.[supplier_id], SR.[name] FROM [dbo].[Suppliers] AS SR
WHERE SR.[supplier_id] 
   IN (SELECT DISTINCT S.[supplier_id] FROM [dbo].[Supplies] AS S WHERE [detail_id]= 1 
   AND S.[quantity] > 
         (SELECT AVG([quantity]) FROM [dbo].[Supplies] 
		  WHERE [product_id]=S.[product_id]));
go

--3
SELECT  DT.[detail_id] FROM 
(SELECT DISTINCT D.[detail_id] FROM [dbo].[Details] AS D
   INNER JOIN [dbo].[Supplies] AS S ON D.[detail_id]=S.[detail_id]
   INNER JOIN [dbo].[Products] AS P ON S.[product_id]=P.[product_id]
WHERE P.[city]= 'London') AS DT;
go

--4
SELECT DISTINCT SR.[supplier_id], SR.[name] FROM [dbo].[Suppliers] AS SR
WHERE SR.[supplier_id] IN 
    (SELECT S.[supplier_id] FROM [dbo].[Supplies] AS S
     INNER JOIN [dbo].[Details] AS D ON D.[detail_id] = S.[detail_id]
     AND D.[color] = 'Red')
go

--5	made by two selection that output different data
SELECT DISTINCT S.detail_id FROM [dbo].[Supplies] AS S
WHERE S.[product_id] IN 
     (SELECT SP.[product_id] FROM [dbo].[Supplies] AS SP
      WHERE SP.[supplier_id] = 2)
go
--Or the second option, because the task is not completely understood. 
SELECT DISTINCT D2.[detail_id] FROM 
   (SELECT D.[detail_id]  FROM [dbo].[Details] AS D
   INNER JOIN [dbo].[Supplies] AS S ON D.[detail_id]=S.[detail_id]
   INNER JOIN [dbo].[Suppliers] SR ON S.[supplier_id]=SR.[supplier_id]
   INNER JOIN [dbo].[Products] AS P ON S.[product_id]=P.[product_id]
WHERE S.[supplier_id]=2) AS D2;
go

--6
SELECT S.[detail_id] FROM [dbo].[Supplies] AS S
GROUP BY S.[detail_id]
HAVING AVG(S.[quantity]) > (SELECT MAX(SP.[quantity]) FROM [dbo].[Supplies] AS SP
WHERE SP.[product_id] = 1)
GO


--7
SELECT P.[product_id] FROM [dbo].[Products] P
   INNER JOIN [dbo].[Supplies] S ON P.[product_id]= S.[product_id]
WHERE  P.[product_id] NOT IN 
   (SELECT [product_id] FROM [dbo].[Supplies]);
go

--Write queries using CTE or Hierarchical queries

--1
;WITH CTE1 AS 
  (SELECT D.[detail_id], D.[name], D.[city] FROM [dbo].[Details] AS D
   UNION ALL
SELECT P.[product_id], P.[name], P.[city] FROM [dbo].[Products] AS P),

CTE2 AS(SELECT CTE1.[detail_id], CTE1.[name] FROM CTE1)
     SELECT DISTINCT CTE2.[detail_id], CTE2.[name], S.[quantity] FROM CTE2 
     LEFT JOIN [dbo].[Supplies] S ON CTE2.[detail_id]=S.detail_id
ORDER BY S.[quantity];
go

--2
;WITH CTE AS
   (SELECT 1 AS N, CAST(1 AS BIGINT) AS Factorial
   UNION ALL
   SELECT N + 1, (N + 1) * Factorial FROM CTE
   WHERE N < 10)
SELECT TOP 1 N AS Position, Factorial AS Value FROM CTE
ORDER BY Position DESC;
go

--3
;WITH FibonacciNumbers (RecursionLevel, FibonacciNumber, NextNumber) 
AS (SELECT 1  AS RecursionLevel, --Anchor member definition
           1  AS FibonacciNumber,
           1  AS NextNumber
   UNION ALL -- Recursive member definition
   SELECT  a.RecursionLevel + 1             AS RecursionLevel,
           a.NextNumber                     AS FibonacciNumber,
           a.FibonacciNumber + a.NextNumber AS NextNumber
   FROM FibonacciNumbers a
   WHERE a.RecursionLevel < 20)
-- Statement that executes the CTE
SELECT  '' + CAST( fn.RecursionLevel AS VARCHAR) AS Position, 
fn.FibonacciNumber AS Value FROM FibonacciNumbers fn; 
go

--4
DECLARE @StartDate DATE, @EndDate DATE
SET @StartDate = '20131125'
SET @EndDate = '20140305'
;WITH CTE (StartDate, EndDate)
AS
(SELECT @StartDate AS StartDate, EOMONTH(@StartDate) AS EndDate
   UNION ALL
SELECT DATEADD(DAY, 1, EndDate ) AS StartDate, 
		IIF(EOMONTH(DATEADD(MONTH, 1, StartDate )) > @EndDate, 
@EndDate, EOMONTH(DATEADD(MONTH, 1, StartDate )))   AS EndDate FROM CTE 
WHERE EndDate < @EndDate)
SELECT * FROM CTE;
go

--5 This task is done in two ways.
--The first option is cumbersome, but works, beautifully displays data and quite understandable. Done using google
-- Function to return the First Date for month
CREATE FUNCTION [dbo].[f_FirstDayOfMonth]
(@Date DATE) RETURNS DATE
AS
BEGIN
DECLARE @Answer DATE, @Month VARCHAR(2), @Year CHAR(4)
SET @Month = CASE WHEN DATEPART(MONTH,@Date) < 10 THEN '0' ELSE '' END + CONVERT(VARCHAR(2), DATEPART(MONTH,@Date))
SET @Year = CONVERT(CHAR(4),DATEPART(YEAR,@Date))
SET @Answer = CONVERT(DATE,@Month + '/01/' + @Year) 
RETURN @Answer
END
go
-- Function to return the Last Date for month
CREATE FUNCTION [dbo].[f_LastdayOfMonth]
(@Date DATE) RETURNS DATE
AS
BEGIN
DECLARE @Answer DATE, @Month VARCHAR(2), @Year CHAR(4)
SET @Month =  CASE WHEN DATEPART(MONTH,@Date) < 10 THEN '0' ELSE '' END + CONVERT(VARCHAR(2), DATEPART(MONTH,@Date))
SET @year = CONVERT(CHAR(4),DATEPART(YEAR,@Date))
SET @Answer = CONVERT(DATE,@Month + '/01/' + @Year)
SET @Answer = DATEADD(MONTH,1,@Answer)
SET @Answer = DATEADD(DAY,-1,@answer) 
RETURN @Answer
END
go

CREATE PROCEDURE [dbo].[Calender]
(@Month TINYINT,
 @Year INT)
AS
BEGIN
-- Declare Valiables
DECLARE @Date1 DATE, @Enddate DATE, @Day1 VARCHAR(10), @Weekid TINYINT, @Currdate DATE
SELECT @Currdate= CONVERT(DATE,(CAST(@Year AS CHAR(4))+'-'+CAST(@Month AS VARCHAR(2))+'-15'))
SELECT @Date1=CONVERT(DATE,dbo.[f_FirstDayOfMonth](@Currdate)), @Enddate=CONVERT(DATE,dbo.[f_LastdayOfMonth](@Currdate))
SELECT @Day1= DATENAME(WEEKDAY, @Date1) 
-- Recursive CTE to get Days and Dates for the month
;WITH CTE_CAL ([Date], [Day], [Weekid])
AS
(SELECT @Date1, @Day1, CASE WHEN DATEPART(WEEKDAY,@Date1)=1 THEN CAST(DATEPART(WW,@Date1)  AS TINYINT)-1
                            ELSE DATEPART(WW,@Date1) END AS Weekid
 UNION ALL
 SELECT DATEADD(DD,1,[Date]), CAST(DATENAME(WEEKDAY, DATEADD(DD,1,[Date])) AS VARCHAR(10)),  
                              CASE WHEN DATEPART(WEEKDAY,DATEADD(DD,1,[Date]))=1 THEN
                              CAST(DATEPART(WW,DATEADD(DD,1,[Date]))  AS TINYINT)-1
	                              ELSE DATEPART(WW,DATEADD(DD,1,[Date])) END AS weekid
 FROM CTE_CAL
 WHERE [Date] < @Enddate )
-- Use Pivot to display the result in calender format
SELECT  [Weekid], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday] 
FROM
(SELECT [Weekid], [Date], [DAY] FROM CTE_CAL) PVT
PIVOT
(MAX([Date]) FOR [Day] IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday] ))
PVTTAB
End;
go
[dbo].[Calender] 07,2019

--Second option, my own thoughts. The appearance does not meet the requirements
--Can not flip with Pivot
DECLARE @START_DATE DATETIME = '20190701'
DECLARE @ENDDATE DATETIME = '20190731'
;WITH CTE_DATES AS
(SELECT @START_DATE AS DateValue   
	  UNION ALL 
SELECt DateValue + 1 FROM CTE_DATES
WHERE DateValue + 1 <= @ENDDATE)
      SELECT
		     YEAR(DateValue) as C_YEAR,
			 DATENAME(MONTH,DateValue) AS NAME_MONTH,
			 DATENAME(WEEKDAY,DateValue ) AS WEEK_DAY,
			 day(DateValue) as C_DAY		 
	   FROM CTE_DATES
	   OPTION (MAXRECURSION 0);
go

--6 Create a geography table and enter data into it
create table [geography]
(id int not null primary key, name varchar(20), region_id int);
ALTER TABLE [geography]
       ADD CONSTRAINT R_GB
	   FOREIGN KEY (region_id)
       REFERENCES [geography]  (id);
insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);

--Write a request that returns the first-level regions
;WITH CTE AS 
(SELECT [region_id], [id] AS Place_ID, [name], 1 AS PlaceLevel FROM [dbo].[geography]
WHERE [region_id] = 1)
SELECT * from CTE;
go

--7
;WITH Frnk_reg AS
(SELECT [region_id], [id] AS Place_ID, [name], 0 AS PlaceLevel 
 FROM [dbo].[geography]
 WHERE [region_id] = 4
    UNION ALL
SELECT G.[region_id], G.[id], G.[name], PlaceLevel +1 FROM Frnk_reg  AS F
    INNER JOIN [dbo].[geography]  AS G
ON F.Place_ID =G.[region_id])
SELECT [region_id], Place_ID, [name], PlaceLevel FROM Frnk_reg;
go

--8 done using this site as a template https://stevestedman.com/2012/02/generating-a-tree-path-with-a-cte/
;WITH CTE_Ukr AS
(SELECT [name], [id], [region_id], 0 AS [level], CAST([name] AS VARCHAR(255)) AS Treepath
FROM [dbo].[geography]
WHERE [region_id] IS NULL
     UNION ALL
SELECT G.[name], G.[id], G.[region_id], [level] + 1, CAST(Treepath + '.' + CAST(G.[id] AS VARCHAR(255)) AS VARCHAR(255))
FROM [dbo].[geography] AS G
     INNER JOIN CTE_Ukr AS U 
ON U.[id] = G.[region_id])
SELECT [name], [id], [region_id], [level] FROM CTE_Ukr 
ORDER BY Treepath;
go

--9
;WITH CTE_LV AS
(SELECT [name], [id], [region_id], 1 AS [level], CAST([name] AS VARCHAR(255)) AS Treepath
FROM [dbo].[geography]
WHERE [id]=2
     UNION ALL
SELECT G.[name], G.[id], G.[region_id], [level] + 1, CAST(Treepath + '.' + CAST(G.[id] AS VARCHAR(255)) AS VARCHAR(255))
FROM [dbo].[geography] AS G
     INNER JOIN CTE_LV AS L
ON L.[id] = G.[region_id])
SELECT [name], [id], [region_id], [level] FROM CTE_LV;
go

--10
;WITH CTE_LV AS
(SELECT [name], [id], [region_id], 1 AS [level], CAST([name] AS VARCHAR(255)) AS Treepath
FROM [dbo].[geography]
WHERE [id]=2
     UNION ALL
SELECT G.[name], G.[id], G.[region_id], [level] + 1, CAST(Treepath + '/' + CAST(G.[name] AS VARCHAR(255)) AS VARCHAR(255))
FROM [dbo].[geography] AS G
     INNER JOIN CTE_LV AS L
ON L.[id] = G.[region_id])
SELECT [name], [id], ('/' + Treepath) AS Treepath FROM CTE_LV;
go

--11
;WITH CTE_LV AS
(SELECT [name], [id], [region_id], 1 AS [PathLen], CAST([name] AS VARCHAR(255)) AS Treepath
FROM [dbo].[geography]
WHERE [id]=2 
     UNION ALL
SELECT G.[name], G.[id], G.[region_id], [PathLen] + 1, CAST(Treepath + '/' + CAST(G.[name] AS VARCHAR(255)) AS VARCHAR(255))
FROM [dbo].[geography] AS G
     INNER JOIN CTE_LV AS L
ON L.[id] = G.[region_id])
SELECT [name], 'Lviv' AS center, [PathLen],  ('/Lviv/' + Treepath) AS Treepath FROM CTE_LV;
go

--Write queries using UNION, UNION ALL, EXCEPT, INTERSECT
--1
SELECT [supplier_id]  FROM [dbo].[Suppliers]
WHERE [city]='London' 
    UNION 
SELECT [supplier_id]  FROM [dbo].[Suppliers]
 WHERE [city]='Paris';
go

--2
SELECT  [city] FROM [dbo].[Suppliers]
   UNION ALL
SELECT  [city] FROM [dbo].[Details]
ORDER BY [city];

SELECT [city] FROM [dbo].[Suppliers]
    INTERSECT
SELECT  [city] FROM [dbo].[Details]
ORDER BY [city];
go

--3
SELECT [supplier_id] FROM [dbo].[Suppliers]
    EXCEPT
SELECT [supplier_id] FROM [dbo].[Supplies]
WHERE [detail_id] IN 
     (SELECT [detail_id] FROM [dbo].[Details] 
	   WHERE [city] = 'London');
go

--4
(SELECT [product_id], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'London')
     EXCEPT
SELECT[product_id], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'Roma'))
     UNION ALL
(SELECT [product_id], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'Roma')
     EXCEPT
SELECT [product_id], [name], [city] FROM [dbo].[Products]
WHERE [city] IN ('Paris', 'London'));
go

--5
SELECT [supplies_id],[supplier_id], [detail_id], [product_id] FROM [dbo].[Supplies]
WHERE [supplies_id] IN 
          (SELECT [supplies_id] FROM [dbo].[Suppliers] 
		   WHERE [city] = 'London')
      UNION
(SELECT [supplies_id], [supplier_id], [detail_id], [product_id] FROM [dbo].[Supplies]
WHERE [detail_id] IN 
         (SELECT[detail_id] FROM [dbo].[Details] 
		  WHERE [color] = 'Green')
      EXCEPT 
SELECT [supplies_id], [supplier_id], [detail_id], [product_id] FROM [dbo].[Supplies]
WHERE [product_id] IN 
        (SELECT [product_id] FROM [dbo].[Products] 
		 WHERE [city] = 'Paris'));
go
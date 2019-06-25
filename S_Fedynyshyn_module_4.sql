USE [SalesOrders]
go

--1
SELECT  [CustCity] FROM [dbo].[Customers]
GROUP BY [CustCity];
go

--2
SELECT [EmpFirstName], [EmpLastName], [EmpPhoneNumber] FROM [dbo].[Employees];
go

--3 
SELECT DISTINCT C.[CategoryDescription] FROM [dbo].[Categories] AS C
INNER JOIN [dbo].[Products] AS P 
ON C.[CategoryID]=P.[CategoryID]
WHERE P.[QuantityOnHand] > 0; --As I understood "avaliable at the moment products" means that "QuantityOnHand" value must be > 0
go
 
--4
SELECT P.[ProductName], P.[RetailPrice], C.[CategoryDescription] FROM [dbo].[Products] AS P
INNER JOIN [dbo].[Product_Vendors] AS VP 
ON P.[ProductNumber]=VP.[ProductNumber]
INNER JOIN [dbo].[Categories] AS C 
ON P.[CategoryID]=C.[CategoryID];
go

--5
SELECT [VendName] FROM [dbo].[Vendors]
ORDER BY [VendZipCode];
go

--6
SELECT [EmpFirstName], [EmpLastName], [EmpAreaCode] FROM [dbo].[Employees]
ORDER BY [EmpLastName], [EmpFirstName];
go

--7
SELECT [VendName] FROM [dbo].[Vendors];
go

--8
SELECT DISTINCT [CustState] FROM [dbo].[Customers];
go

--9
SELECT P.[ProductName], O.[QuotedPrice] FROM [dbo].[Products] AS P
INNER JOIN [dbo].[Order_Details] AS O
ON P.[ProductNumber]=O.[ProductNumber];
go

--10
SELECT [EmployeeID],
       [EmpFirstName],
       [EmpLastName],
       [EmpStreetAddress],
       [EmpCity],
       [EmpState],
       [EmpZipCode],
       [EmpAreaCode],
       [EmpPhoneNumber]
FROM [dbo].[Employees];
go

--11
SELECT [VendCity], [VendName] FROM [dbo].[Vendors]
ORDER BY [VendCity] ASC;
go

--12
SELECT O.[OrderNumber], MAX (P.[DaysToDeliver]) AS Days FROM [dbo].[Product_Vendors] AS P
INNER JOIN [dbo].[Order_Details] AS O
ON P.[ProductNumber]=O.[ProductNumber]
GROUP BY O.[OrderNumber]
ORDER BY  O.[OrderNumber];
go

--13
SELECT  [ProductNumber], [QuantityOnHand], ([QuantityOnHand]*[RetailPrice]) AS COST
FROM [dbo].[Products];
go

--14
;WITH CTE1 AS
(SELECT [OrderNumber], DATEDIFF(day, [OrderDate], [ShipDate]) AS Duration  
    FROM [dbo].[Orders]
  UNION
SELECT O.[OrderNumber], MAX (P.[DaysToDeliver]) AS 'Duration' FROM [dbo].[Product_Vendors] AS P
INNER JOIN [dbo].[Order_Details] AS O
ON P.[ProductNumber]=O.[ProductNumber]
GROUP BY O.[OrderNumber])
select [OrderNumber], sum (CTE1.Duration) AS Duration FROM CTE1
GROUP BY [OrderNumber]
ORDER BY [OrderNumber];
go

--additional tasks
--1 Output with one query a list of natural numbers from 1 to 10 000
DECLARE @n INT = 0;
WHILE @n < 10000
BEGIN
SET @n = @n +1	
print @n	
END;
go

--2 Count on how many Sabbaths and Sundays this year
;WITH rs(D, name) AS
(SELECT CAST ('20190101' AS DATE) AS D, DATENAME (WEEKDAY, '20190101')
UNION ALL
SELECT DATEADD (DAY, 1, D), DATENAME(WEEKDAY, dateadd(day, 1, D)) from rs
WHERE D<'20191231'),
rs1 AS
(SELECT D, name FROM rs
WHERE name in('Saturday', 'Sunday'))
SELECT COUNT (*) FROM rs1
OPTION (maxrecursion 366);
go
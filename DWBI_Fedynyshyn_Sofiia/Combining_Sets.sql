--завдання № 1
;WITH CTE1 AS
(SELECT pc.model, pc.price FROM dbo.pc pc 
UNION ALL
SELECT pr.model,pr.price FROM dbo.printer pr)
SELECT MAX (CTE1.price) FROM CTE1;
go

--завдання № 2
 ;WITH CTE1 AS
(SELECT pc.code, pc.model, pc.hd FROM dbo.pc pc 
UNION ALL
SELECT lp.code, lp.model, lp.hd FROM dbo.laptop lp),

CTE2 AS(SELECT CTE1.model, COUNT(CTE1.code) as count_ FROM CTE1
GROUP BY CTE1.model)
SELECT CTE2.model, pr.type, CTE2.count_ FROM CTE2 
LEFT JOIN dbo.product pr 
ON CTE2.model = pr.model
ORDER BY pr.type;
go
   
--завдання № 5
DECLARE @n INT = 0;
WHILE @n < 10000
BEGIN
SET @n = @n +1	
print @n	
END;
go

--завдання № 6
DECLARE @n INT = 0;
WHILE @n < 100000
BEGIN SET @n = @n +1	
print @n	
END;
go

--завдання № 8
SELECT DISTINCT maker, type FROM dbo.product 
WHERE type = 'pc' AND maker NOT IN(SELECT maker  FROM dbo.product WHERE type='Laptop');
go

--завдання № 9
SELECT DISTINCT maker FROM dbo.product
WHERE type = 'pc' AND maker != ALL(SELECT maker  FROM dbo.product WHERE type='Laptop');
go

--завдання № 10
SELECT DISTINCT maker FROM dbo.product 
WHERE type= 'pc' AND NOT maker=ANY (SELECT maker  FROM dbo.product WHERE type= 'Laptop');
go

--завдання № 11
SELECT DISTINCT maker FROM dbo.product 
WHERE type= 'pc' AND maker IN(SELECT maker FROM Product WHERE type='laptop');
go

--завдання № 12 ----перебрала різні варіанти, але ніяк неможу позбутись в результаті 'Е'
SELECT DISTINCT maker FROM Product 
WHERE type= 'pc' AND maker=ALL (SELECT maker FROM dbo.product WHERE  type='laptop' AND type= 'pc' AND not type='printer');
go

--завдання № 13
SELECT DISTINCT maker FROM dbo.product 
WHERE type= 'pc' AND maker =any (SELECT maker FROM dbo.product WHERE type='laptop');
go

--завдання № 14
SELECT distinct maker FROM dbo.product p
WHERE p.model IN(SELECT pc.model from dbo.pc pc WHERE type='pc')
           UNION ALL
SELECT maker FROM dbo.product p
WHERE p.model=ANY(SELECT pc.model from dbo.pc pc WHERE type='pc')
GROUP BY (maker)
ORDER BY (maker);
go

--завдання № 15
declare @uk INT
SET @uk = (select count ('country') from dbo.classes where country='Ukraine')
if (@uk=0)
SELECT class, country FROM dbo.classes
UNION ALL
SELECT class, country FROM dbo.classes
else 
select class, country  from dbo.classes where country='Ukraine';
go



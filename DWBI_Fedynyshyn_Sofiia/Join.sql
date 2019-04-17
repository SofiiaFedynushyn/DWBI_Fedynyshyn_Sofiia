-- JOIN

--завдання № 1
SELECT PR.maker, PR.type, pc.speed, pc.hd
FROM dbo.pc pc LEFT JOIN dbo.product PR 
ON pc.model = PR.model
WHERE hd > 8;
go
 
 --завдання № 2
SELECT PR.maker FROM dbo.pc pc 
LEFT JOIN dbo.product PR
ON pc.model = PR.model
WHERE speed <600;
go

 --завдання № 3
SELECT PR.maker FROM dbo.laptop lp 
LEFT JOIN dbo.product PR
ON lp.model = PR.model
WHERE speed <=500;
go

 --завдання № 4
SELECT  DISTINCT L1.model,L2.model, L1.hd, L2.ram FROM dbo.laptop L1 
INNER JOIN dbo.laptop L2 
ON L1.hd=L2.hd AND L1.ram=L2.ram 
AND L1.code>L2.code;
go

 --завдання № 5
SELECT DISTINCT C1.country, C1.type, C2.type FROM dbo.classes C1, dbo.classes C2
WHERE  C2.type = 'bb' AND C1.type = 'bc';
go

--завдання № 6
SELECT pr.maker, pc.model, pc.price FROM dbo.pc pc
LEFT JOIN dbo.product pr
ON pr.model = pc.model
WHERE pc.price < 600;
go 

--завдання № 7
SELECT pr.model, p.maker FROM dbo.printer pr
LEFT JOIN dbo.product p
ON p.model = pr.model
WHERE pr.price > 300;
go

--завдання № 8 
SELECT pr.maker, pc.model, pc.price FROM dbo.product pr
RIGHT JOIN dbo.pc pc
ON pr.model = pc.model
UNION 
SELECT pr.maker, l.model, l.price FROM dbo.product pr
RIGHT JOIN dbo.laptop l 
ON pr.model = l.model;
go

--завдання № 9
SELECT pr.maker, pc.model, pc.price FROM dbo.product pr
LEFT JOIN dbo.pc pc
ON pr.model = pc.model;
go

--завдання № 10
SELECT pr.maker, pr.type, pl.model, pl.speed FROM dbo.laptop pl
LEFT JOIN dbo.product pr
ON pr.model=pl.model
WHERE pl.speed > 600;
go

--завдання № 11
SELECT s.name, s.class, s.launched, c.displacement FROM dbo.classes c
INNER JOIN  dbo.ships s
ON  c.class=s.class;
go

--завдання № 12
SELECT o.ship, o.result, b.name, b.date FROM dbo.outcomes o 
LEFT JOIN dbo.battles b
ON b.name=o.battle
WHERE o.result='ok' OR o.result='damaged';
go

--завдання № 13
SELECT s.name, s.class, s.launched, c.country FROM dbo.classes c
INNER JOIN dbo.ships s
ON s.class=c.class;
go

--завдання № 14
SELECT c.id_comp, t.plane, c.name FROM dbo.trip t
LEFT JOIN dbo.company c
ON t.id_comp=c.id_comp
WHERE plane='Boeing';
go

--завдання № 15 
SELECT p.id_psg, p.name, t.time_out FROM dbo.passenger p, dbo.pass_in_trip pt, dbo.trip t
WHERE (p.id_psg=pt.id_psg AND pt.trip_no=t.trip_no )
ORDER BY (name);
--or
SELECT p.id_psg, p.name, t.time_out 
FROM dbo.passenger p INNER JOIN dbo.pass_in_trip pt on p.id_psg=pt.id_psg
					 INNER JOIN dbo.trip t on pt.trip_no=t.trip_no 
ORDER BY (name);
go


--завдання № 16
SELECT pc.model, pc.speed,pc.hd FROM dbo.product p
INNER JOIN dbo.pc pc
ON pc.model=p.model
WHERE p.maker='A' AND (pc.ram=10 OR pc.ram=20)
union
SELECT lp.model, lp.speed,lp.hd FROM dbo.product p
INNER JOIN dbo.laptop lp
ON p.model=lp.model
WHERE p.maker='A' AND (lp.ram=10 OR lp.ram=20)
ORDER BY (speed);
go

--завдання № 17
SELECT maker, pc, laptop, printer FROM dbo.product 
PIVOT (COUNT (model) FOR type IN (pc, laptop, printer))pvt;
go

--завдання № 18
SELECT avg_, [11], [12], [14], [15] 
FROM (SELECT 'average price' AS 'avg_', screen, price FROM dbo.laptop)x
PIVOT (AVG (price) FOR screen IN([11], [12], [14], [15])) pvt;
go	

--завдання № 19	
SELECT p.maker, l.code, l.model, l.speed, l.ram, l.hd, l.price, l.screen FROM dbo.product p
CROSS APPLY
(SELECT l.code, l.model, l.speed, l.ram, l.hd, l.price, l.screen FROM dbo.laptop l 
WHERE p.model=l.model)l;
go

--завдання № 20
SELECT l.code, l.model, l.speed, l.ram, l.hd, l.price, l.screen, max_price FROM dbo.laptop l
CROSS APPLY
(SELECT MAX(price) max_price FROM dbo.laptop l2
LEFT JOIN  dbo.product p
ON l2.model=p.model 
WHERE maker = (SELECT maker FROM dbo.product p WHERE p.model= l.model)) x;
go

--завдання № 21
SELECT * FROM laptop l
CROSS APPLY
(SELECT TOP 1 * FROM Laptop l2 
WHERE l.model < l2.model OR (l.model = l2.model AND l.code < l2.code) 
ORDER BY model, code) x
ORDER BY l.model;
go

--завдання № 22
SELECT * FROM laptop l
OUTER APPLY
(SELECT TOP 1 * FROM Laptop l2 
WHERE l.model < l2.model OR (l.model = l2.model AND l.code < l2.code) 
ORDER BY model, code) x
ORDER BY l.model;
go

--завдання № 23
SELECT X.* FROM 
(SELECT DISTINCT type FROM product) Pr1 
CROSS APPLY 
(SELECT TOP 3 * FROM product Pr2 WHERE  Pr1.type=Pr2.type ORDER BY pr2.model) x;
GO

--завдання № 24
SELECT code, name, value FROM Laptop
CROSS APPLY
(VALUES('speed', speed),('ram', ram),('hd', hd),('screen', screen)) spec(name, value)
ORDER BY code, name, value;
go
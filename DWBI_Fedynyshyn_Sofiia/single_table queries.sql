--�������� � 1 
SELECT maker, type FROM dbo.product
WHERE type = 'laptop'
ORDER BY maker;
go

--�������� � 2
SELECT model, ram, screen, price FROM dbo.laptop
WHERE price > 1000
ORDER BY ram ASC,price DESC;
go

--�������� � 3
SELECT * FROM dbo.printer
WHERE color = 'y'
ORDER BY price DESC;
go 

--�������� � 4
SELECT model, speed, hd, cd, price FROM dbo.pc
WHERE cd='12x' OR cd='24x'
AND price < 600
ORDER BY speed DESC;
go

--�������� � 5
SELECT name, class  FROM ships
ORDER BY name;
go

--�������� � 6
SELECT * FROM pc
WHERE speed >= 500 AND price <800
ORDER BY price DESC;
go

--�������� � 7
SELECT * FROM printer
WHERE NOT type='Matrix' AND price <300
ORDER BY type DESC;
go

--�������� � 8
SELECT model, speed FROM dbo.pc
WHERE price BETWEEN '400' AND '600'
ORDER BY hd;
go

--�������� � 9
SELECT model, speed, hd, price FROM dbo.laptop
WHERE screen >= 12
ORDER BY price DESC;
go

--�������� � 10
SELECT model, type, price FROM dbo.printer
WHERE price <300
ORDER BY type DESC;
go

--�������� � 11
SELECT model, ram, price FROM dbo.laptop
WHERE  ram=64 
ORDER BY screen;
go

--�������� � 12
SELECT model, ram, price FROM dbo.pc
WHERE ram > 64 
ORDER BY hd;
go

--�������� � 13
SELECT model, speed, price FROM dbo.pc
WHERE speed BETWEEN '500' AND '750'
ORDER BY hd DESC;
go

--�������� � 14
SELECT * FROM dbo.outcome_o
WHERE out > 2000
ORDER BY date DESC;
go

--�������� � 15
SELECT * FROM dbo.income_o
WHERE inc BETWEEN '5000' AND '10000'
ORDER BY inc;
go

--�������� � 16
SELECT * FROM dbo.income
WHERE point=1
ORDER BY inc;
go

--�������� � 17
SELECT * FROM dbo.outcome
WHERE point=2
ORDER BY out;
go

--�������� � 18
SELECT * FROM dbo.classes
WHERE country='Japan'
ORDER BY type DESC;
go

--�������� � 19
SELECT name, launched FROM dbo.ships
WHERE launched BETWEEN '1920' AND '1942'
ORDER BY launched DESC;
go

--�������� � 20
SELECT * FROM dbo.outcomes
WHERE battle='Guadalcanal' AND NOT result='sunk'
ORDER BY ship DESC;
go

--�������� � 21
SELECT * FROM dbo.outcomes
WHERE result='sunk'
ORDER BY ship DESC;
go

--�������� � 22
SELECT class, displacement FROM dbo.classes
WHERE displacement >= 40000
ORDER BY type;
go

--�������� � 23
SELECT trip_no, town_from, town_to FROM dbo.trip
WHERE town_from='London' OR town_to='London'
ORDER BY time_out;
go

--�������� � 24
SELECT	trip_no, plane, town_from, town_to FROM dbo.trip
WHERE plane='TU-134'
ORDER BY time_out DESC;
go

--�������� � 25
SELECT	trip_no, plane, town_from, town_to FROM dbo.trip
WHERE NOT plane='IL-86'
ORDER BY plane;
go

--�������� � 26
SELECT	trip_no, town_from, town_to FROM dbo.trip
WHERE NOT town_from='Rostov' 
AND NOT town_to='Rostov'
ORDER BY plane;
go

--�������� � 27
SELECT * FROM dbo.pc
WHERE model LIKE '%1%1%';
go

--�������� � 28
SELECT * FROM dbo.outcome
WHERE DATEPART (mm, date) = 03;
go

--�������� � 29
SELECT * FROM dbo.outcome_o
WHERE DATEPART (dd, date) = 14;
go

--�������� � 30
SELECT name FROM dbo.ships
WHERE name LIKE 'W%n';
go

--�������� � 31
SELECT name FROM dbo.ships
WHERE name LIKE '%e%e%';
go

--�������� � 32
SELECT name, launched FROM dbo.ships
WHERE NOT name LIKE '%a';
go

--�������� � 33
SELECT name FROM dbo.battles
WHERE name LIKE '% %'AND NOT name LIKE '% %c';
go

--�������� � 34
SELECT trip_no, id_comp, plane, town_from, 
FORMAT(CAST(time_out as time), N'hh\.mm') as time_t FROM dbo.trip
WHERE FORMAT(CAST(time_out as time), N'hh\.mm') BETWEEN 12.00 AND 17.00;
go

--�������� � 35
SELECT trip_no, id_comp, plane, town_to, 
FORMAT(CAST(time_in as time), N'hh\.mm') as time_in FROM dbo.trip
WHERE FORMAT(CAST(time_in as time), N'hh\.mm') BETWEEN 17.00 AND 23.00;
go

--�������� � 36
SELECT trip_no, id_comp, plane, town_to, 
FORMAT(CAST(time_in as time), N'hh\.mm') as time_in FROM dbo.trip
WHERE FORMAT(CAST(time_in as time), N'hh\.mm') BETWEEN 21.00 AND 10.00;
go

--�������� � 37
SELECT date FROM dbo.pass_in_trip
WHERE place LIKE '1%';
go

--�������� � 38
SELECT date FROM dbo.pass_in_trip
WHERE place LIKE '%c';
go

--�������� � 39
SELECT SUBSTRING (name, charindex (' ',name,1),10) AS name FROM dbo.passenger 
WHERE name LIKE '% C%';
go

--�������� � 40
SELECT SUBSTRING (name, charindex (' ',name,1),10) AS name FROM dbo.passenger 
WHERE name NOT LIKE '% J%';
go

--�������� � 41
SELECT '������� ���� = ', AVG (price) FROM dbo.laptop;
go
 --���
SELECT '������� ���� = '+ CAST(AVG (price) AS NVARCHAR(15)) FROM dbo.laptop;
go

--�������� � 42
SELECT code, '������: '+ model, '��������: '+ CAST (speed AS NVARCHAR(15)),
'��''�� ���''��: '+ CAST (ram AS NVARCHAR(15)), 
'����� �����: ' + CAST (hd AS NVARCHAR(15)), 
'�������� CD-�������: ' + CAST (cd AS NVARCHAR(15)), 
'����: '+ CAST (price AS NVARCHAR(15)) FROM dbo.pc;
go

--�������� � 43
SELECT code, point, DATEFROMPARTS( YEAR(date), MONTH(date),DAY(date)), inc
FROM dbo.income;
go

--�������� � 44
SELECT ship, battle, CASE result
WHEN 'sunk' THEN '�������'
WHEN 'damaged' THEN '����������'
WHEN 'OK' THEN '������'
END AS '���������'   
FROM dbo.outcomes;
go

--�������� � 45
SELECT trip_no, date, id_psg, '���: '+ LEFT(place,1),  '����: '+RIGHT(place,9)  --�o ��� ������� char(10)
FROM dbo.pass_in_trip
ORDER BY place;
go

--�������� � 46
SELECT trip_no, id_comp, plane, town_from + town_to, 
'from '+ RTRIM(town_from) + ' to '+ LTRIM (town_to) AS coment,
time_out, time_in FROM dbo.trip;
go

--�������� � 47 
SELECT plane, town_from, town_to, time_out, time_in,
LEFT(plane,1) + RIGHT(TRIM (plane), 1)+
LEFT(town_from,1) + RIGHT(TRIM (town_from), 1)+
LEFT(town_to, 1) + RIGHT(TRIM (town_to), 1) 
FROM dbo.trip;
go
   
--�������� � 48
SELECT maker, COUNT(DISTINCT(model)) AS count FROM  dbo.product
WHERE type = 'pc'
GROUP BY (maker)
HAVING COUNT(DISTINCT(model))>=2;
go

--�������� � 49
SELECT tt.town_from, COUNT(tt.town_from)
FROM
(SELECT town_from FROM dbo.trip
UNION ALL
SELECT town_to FROM dbo.trip)AS tt 
GROUP BY (tt.town_from);
go

--�������� � 50
SELECT type, COUNT(model) FROM dbo.printer
GROUP BY (type);
go
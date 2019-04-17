--завдання № 1 
SELECT maker, type FROM dbo.product
WHERE type = 'laptop'
ORDER BY maker;
go

--завдання № 2
SELECT model, ram, screen, price FROM dbo.laptop
WHERE price > 1000
ORDER BY ram ASC,price DESC;
go

--завдання № 3
SELECT * FROM dbo.printer
WHERE color = 'y'
ORDER BY price DESC;
go 

--завдання № 4
SELECT model, speed, hd, cd, price FROM dbo.pc
WHERE cd='12x' OR cd='24x'
AND price < 600
ORDER BY speed DESC;
go

--завдання № 5
SELECT name, class  FROM ships
ORDER BY name;
go

--завдання № 6
SELECT * FROM pc
WHERE speed >= 500 AND price <800
ORDER BY price DESC;
go

--завдання № 7
SELECT * FROM printer
WHERE NOT type='Matrix' AND price <300
ORDER BY type DESC;
go

--завдання № 8
SELECT model, speed FROM dbo.pc
WHERE price BETWEEN '400' AND '600'
ORDER BY hd;
go

--завдання № 9
SELECT model, speed, hd, price FROM dbo.laptop
WHERE screen >= 12
ORDER BY price DESC;
go

--завдання № 10
SELECT model, type, price FROM dbo.printer
WHERE price <300
ORDER BY type DESC;
go

--завдання № 11
SELECT model, ram, price FROM dbo.laptop
WHERE  ram=64 
ORDER BY screen;
go

--завдання № 12
SELECT model, ram, price FROM dbo.pc
WHERE ram > 64 
ORDER BY hd;
go

--завдання № 13
SELECT model, speed, price FROM dbo.pc
WHERE speed BETWEEN '500' AND '750'
ORDER BY hd DESC;
go

--завдання № 14
SELECT * FROM dbo.outcome_o
WHERE out > 2000
ORDER BY date DESC;
go

--завдання № 15
SELECT * FROM dbo.income_o
WHERE inc BETWEEN '5000' AND '10000'
ORDER BY inc;
go

--завдання № 16
SELECT * FROM dbo.income
WHERE point=1
ORDER BY inc;
go

--завдання № 17
SELECT * FROM dbo.outcome
WHERE point=2
ORDER BY out;
go

--завдання № 18
SELECT * FROM dbo.classes
WHERE country='Japan'
ORDER BY type DESC;
go

--завдання № 19
SELECT name, launched FROM dbo.ships
WHERE launched BETWEEN '1920' AND '1942'
ORDER BY launched DESC;
go

--завдання № 20
SELECT * FROM dbo.outcomes
WHERE battle='Guadalcanal' AND NOT result='sunk'
ORDER BY ship DESC;
go

--завдання № 21
SELECT * FROM dbo.outcomes
WHERE result='sunk'
ORDER BY ship DESC;
go

--завдання № 22
SELECT class, displacement FROM dbo.classes
WHERE displacement >= 40000
ORDER BY type;
go

--завдання № 23
SELECT trip_no, town_from, town_to FROM dbo.trip
WHERE town_from='London' OR town_to='London'
ORDER BY time_out;
go

--завдання № 24
SELECT	trip_no, plane, town_from, town_to FROM dbo.trip
WHERE plane='TU-134'
ORDER BY time_out DESC;
go

--завдання № 25
SELECT	trip_no, plane, town_from, town_to FROM dbo.trip
WHERE NOT plane='IL-86'
ORDER BY plane;
go

--завдання № 26
SELECT	trip_no, town_from, town_to FROM dbo.trip
WHERE NOT town_from='Rostov' 
AND NOT town_to='Rostov'
ORDER BY plane;
go

--завдання № 27
SELECT * FROM dbo.pc
WHERE model LIKE '%1%1%';
go

--завдання № 28
SELECT * FROM dbo.outcome
WHERE DATEPART (mm, date) = 03;
go

--завдання № 29
SELECT * FROM dbo.outcome_o
WHERE DATEPART (dd, date) = 14;
go

--завдання № 30
SELECT name FROM dbo.ships
WHERE name LIKE 'W%n';
go

--завдання № 31
SELECT name FROM dbo.ships
WHERE name LIKE '%e%e%';
go

--завдання № 32
SELECT name, launched FROM dbo.ships
WHERE NOT name LIKE '%a';
go

--завдання № 33
SELECT name FROM dbo.battles
WHERE name LIKE '% %'AND NOT name LIKE '% %c';
go

--завдання № 34
SELECT trip_no, id_comp, plane, town_from, 
FORMAT(CAST(time_out as time), N'hh\.mm') as time_t FROM dbo.trip
WHERE FORMAT(CAST(time_out as time), N'hh\.mm') BETWEEN 12.00 AND 17.00;
go

--завдання № 35
SELECT trip_no, id_comp, plane, town_to, 
FORMAT(CAST(time_in as time), N'hh\.mm') as time_in FROM dbo.trip
WHERE FORMAT(CAST(time_in as time), N'hh\.mm') BETWEEN 17.00 AND 23.00;
go

--завдання № 36
SELECT trip_no, id_comp, plane, town_to, 
FORMAT(CAST(time_in as time), N'hh\.mm') as time_in FROM dbo.trip
WHERE FORMAT(CAST(time_in as time), N'hh\.mm') BETWEEN 21.00 AND 10.00;
go

--завдання № 37
SELECT date FROM dbo.pass_in_trip
WHERE place LIKE '1%';
go

--завдання № 38
SELECT date FROM dbo.pass_in_trip
WHERE place LIKE '%c';
go

--завдання № 39
SELECT SUBSTRING (name, charindex (' ',name,1),10) AS name FROM dbo.passenger 
WHERE name LIKE '% C%';
go

--завдання № 40
SELECT SUBSTRING (name, charindex (' ',name,1),10) AS name FROM dbo.passenger 
WHERE name NOT LIKE '% J%';
go

--завдання № 41
SELECT 'середня ціна = ', AVG (price) FROM dbo.laptop;
go
 --або
SELECT 'середня ціна = '+ CAST(AVG (price) AS NVARCHAR(15)) FROM dbo.laptop;
go

--завдання № 42
SELECT code, 'модель: '+ model, 'швидкість: '+ CAST (speed AS NVARCHAR(15)),
'об''єм пам''яті: '+ CAST (ram AS NVARCHAR(15)), 
'розмір диску: ' + CAST (hd AS NVARCHAR(15)), 
'швидкість CD-приводу: ' + CAST (cd AS NVARCHAR(15)), 
'ціна: '+ CAST (price AS NVARCHAR(15)) FROM dbo.pc;
go

--завдання № 43
SELECT code, point, DATEFROMPARTS( YEAR(date), MONTH(date),DAY(date)), inc
FROM dbo.income;
go

--завдання № 44
SELECT ship, battle, CASE result
WHEN 'sunk' THEN 'потонув'
WHEN 'damaged' THEN 'пошкоджено'
WHEN 'OK' THEN 'працює'
END AS 'результат'   
FROM dbo.outcomes;
go

--завдання № 45
SELECT trip_no, date, id_psg, 'ряд: '+ LEFT(place,1),  'місце: '+RIGHT(place,9)  --бo тип колонки char(10)
FROM dbo.pass_in_trip
ORDER BY place;
go

--завдання № 46
SELECT trip_no, id_comp, plane, town_from + town_to, 
'from '+ RTRIM(town_from) + ' to '+ LTRIM (town_to) AS coment,
time_out, time_in FROM dbo.trip;
go

--завдання № 47 
SELECT plane, town_from, town_to, time_out, time_in,
LEFT(plane,1) + RIGHT(TRIM (plane), 1)+
LEFT(town_from,1) + RIGHT(TRIM (town_from), 1)+
LEFT(town_to, 1) + RIGHT(TRIM (town_to), 1) 
FROM dbo.trip;
go
   
--завдання № 48
SELECT maker, COUNT(DISTINCT(model)) AS count FROM  dbo.product
WHERE type = 'pc'
GROUP BY (maker)
HAVING COUNT(DISTINCT(model))>=2;
go

--завдання № 49
SELECT tt.town_from, COUNT(tt.town_from)
FROM
(SELECT town_from FROM dbo.trip
UNION ALL
SELECT town_to FROM dbo.trip)AS tt 
GROUP BY (tt.town_from);
go

--завдання № 50
SELECT type, COUNT(model) FROM dbo.printer
GROUP BY (type);
go
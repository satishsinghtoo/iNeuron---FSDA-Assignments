CREATE DATABASE IF NOT EXISTS Assignment;

-- TASK 01--
CREATE TABLE IF NOT EXISTS Shopping_History ( 
	Product VARCHAR(20) NOT NULL,
	Quantity INT NOT NULL,
	Unit_Price INT NOT NULL );
    
INSERT INTO Shopping_History (Product, Quantity, Unit_Price) VALUES 
('Milk', 3, 10),
('Bread', 7, 3),
('Bread', 5, 2);

TRUNCATE Shopping_History;
SELECT * FROM Shopping_History;

SELECT Product, SUM(Unit_Price*Quantity) AS Total_Price FROM Shopping_History
GROUP BY Product ORDER BY Products;

INSERT INTO Shopping_History (Product, Quantity, Unit_Price) VALUES 
('Cake', 2, 5),
('Cake', 1, 3);

-- TASK 02--

CREATE TABLE Phones(
	Ph_Name VARCHAR(20) NOT NULL UNIQUE,
    Ph_Number INT NOT NULL UNIQUE); 

CREATE TABLE Calls(
	Id INT NOT NULL UNIQUE,
    Caller INT NOT NULL,
    Callee INT NOT NULL,
    Duration INT NOT NULL );
    
INSERT INTO Phones VALUES
('Jack', 1234),
('Lena', 3333),
('Mark', 9999),
('Anna', 7582);

SELECT * FROM Phones;

INSERT INTO Calls VALUES
(25, 1234, 7582, 8),
(7, 9999, 7582, 1),
(18, 9999, 3333, 4),
(2, 7582, 3333, 3),
(3, 3333, 1234, 1),
(21, 3333, 1234, 1);

SELECT * FROM Calls;

-- works
SELECT Ph_Name
FROM phones p
WHERE (
SELECT SUM(c.Duration) FROM Calls c 
WHERE c.Caller = p.Ph_Number OR c.Callee = p.Ph_Number) >= 10
ORDER BY Ph_Name ASC;

SELECT  SUM(c.Duration) FROM Calls c 
LEFT JOIN Phones p
ON c.Caller = p.Ph_Number OR c.Callee = p.Ph_Number 
group by Ph_Name order by Ph_Name ASC;
-- WHERE c.Caller = p.Ph_Number OR c.Callee = p.Ph_Number;

WITH duration_by_client AS (
  SELECT p.name, SUM(c.duration) AS total_duration
  FROM phones p
  JOIN calls c 
  ON p.phone_number = c.caller OR p.phone_number = c.callee
  GROUP BY p.name
)
SELECT name
FROM duration_by_client
WHERE total_duration >= 10
ORDER BY name ASC;

WITH Cte as (
SELECT p.Ph_Name, SUM(c.Duration) as dur FROM  Phones p
LEFT JOIN Calls c
ON p.Ph_Number=c.Caller   OR p.Ph_Number=c.Callee 
group by Ph_Name 
)
SELECT Ph_Name
FROM Cte
where dur>=10 order by Ph_Name ;

SELECT p.Ph_Name, SUM(c.Duration) as dur FROM  Phones p
LEFT JOIN Calls c
ON p.Ph_Number=c.Caller   OR p.Ph_Number=c.Callee 
group by Ph_Name ;

-- Task 03 --

CREATE TABLE IF NOT EXISTS Trans(
	Amount INT NOT NULL,
    Tr_Date DATE NOT NULL );
    
    
INSERT INTO Trans VALUES 
(1000, '2020-01-06'),
(-10, '2020-01-14'),
(-75, '2020-01-20'),
(-5, '2020-01-25'),
(-4, '2020-01-29'),
(2000, '2020-03-10'),
(-75, '2020-03-12'),
(-20, '2020-03-15'),
(40, '2020-03-15'),
(-50, '2020-03-17'),
(-200, '2020-10-10'),
(200, '2020-10-10');

SELECT * FROM Trans;

SELECT SUM(Amount) as balance
FROM (
  SELECT Amount
  FROM trans
  WHERE MONTH(Tr_Date) NOT IN (
    SELECT MONTH(Tr_Date) FROM Trans
    WHERE Amount < 0
    GROUP BY MONTH(Tr_Date)
    HAVING SUM(Amount) < -100
  )
  UNION ALL
  SELECT Amount - 5
  FROM Trans
  WHERE Amount < 0 AND MONTH(Tr_Date) IN (
    SELECT MONTH(Tr_Date) FROM Trans
	WHERE Amount < 0
    GROUP BY MONTH(Tr_Date)
     HAVING SUM(Amount) < -100
  )
) as t;

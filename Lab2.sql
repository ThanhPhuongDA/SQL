---- Create database DBLab2
CREATE DATABASE DBLab2;
USE DBLab2
GO;
CREATE TABLE Student(
RN INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(20),
Age TINYINT);

CREATE TABLE Test(
TestID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(20));

CREATE TABLE StudentTest(
RN INT NOT NULL FOREIGN KEY REFERENCES Student(RN),
TestID INT NOT NULL FOREIGN KEY REFERENCES Test(TestID),
Date DATE,
Mark FLOAT);

--- Insert values into the tables just created above

INSERT INTO Student(Name, Age)
VALUES
('Nguyen Hong Ha',20),
('Truong Ngoc Anh',30),
('Tuan Minh',25),
('Dan Truong',22);

INSERT INTO Test(Name)
VALUES
('EPC'),
('DWMX'),
('SQL1'),
('SQL2');

INSERT INTO StudentTest(RN,TestID,Date,Mark)
VALUES
(1,1,'2006-07-17',8),
(1,2,'2006-07-18',5),
(1,3,'2006-07-19',7),
(2,1,'2006-07-17',7),
(2,2,'2006-07-18',4),
(2,3,'2006-07-19',2),
(3,1,'2006-07-17',10),
(3,3,'2006-07-18',1);

---1. Give the student marks in the form of numbers with 2 digits
 SELECT 
	RN, 
	TestID, 
	convert(numeric(4,2), Mark)
 FROM StudentTest;
 ---2. Show students > 25 years old
 SELECT 
	Name,
	Age
FROM Student
WHERE Age > 25;

---3. Show students who are 30 or 20 years old
SELECT 
	Name,
	Age
FROM Student
WHERE Age IN (20,30);

--- Show the subjects that contain 's'

SELECT 
	Name
FROM Test
WHERE 
	Name LIKE '%s%';

--- Show the data with Mark > 5 in the StudentTest table
SELECT *
FROM StudentTest
WHERE 
	Mark > 5;

--- Show the students whose first names have 4 characters

SELECT 
	Name
FROM Student
WHERE Name LIKE '% ____';

---- Show the students whose last names have 6 characters

SELECT 
	Name
FROM Student
WHERE Name LIKE '______ %';

---- Show the students whose last names have 6 characters but not contain 'r'
SELECT 
	Name
FROM Student
WHERE Name LIKE '[^r][^r][^r][^r][^r][^r] %';

---Add more column named Status VARCHAR(10), DEFAULT('Young') into Student table
ALTER TABLE Student ADD
    Status varchar(10) NULL
        CONSTRAINT Status DEFAULT 'Young'
        WITH VALUES;

--- Show the average age of students
SELECT
	AVG(Age) AS Average_age
FROM Student;
--- Show the oldest student
SELECT
	Name,
	Age
FROM Student
WHERE Age = (SELECT MAX(Age) FROM Student);

SELECT TOP(1) with ties * 
FROM Student
ORDER BY Age DESC;


--- Show the youngest student
SELECT
	Name,
	Age
FROM Student
WHERE Age = (SELECT MIN(Age) FROM Student);

SELECT TOP(1) with ties *
FROM Student
ORDER BY Age ASC;
---Show the test whose highest mark
			  
SELECT TOP(1) with ties
	b.Name,
	a.Mark
FROM StudentTest a
JOIN Test b
ON a.TestID = b.TestID
ORDER BY a.Mark DESC;

---Show the test whose lowest mark
SELECT TOP(1) with ties
	b.Name,
	a.Mark
FROM StudentTest a
JOIN Test b
ON a.TestID = b.TestID
ORDER BY a.Mark;
---Show the students who took the most recent test
SELECT TOP(1) with ties
	a.Name,
	b.Date
FROM Student a
JOIN StudentTest b
ON a.RN = b.RN
ORDER BY b.Date DESC;

---Show the students who took the first test
SELECT TOP(1) with ties
	a.Name,
	b.Date
FROM Student a
JOIN StudentTest b
ON a.RN = b.RN
ORDER BY b.Date;

---Calculate the sum of students'ages
SELECT sum(Age) as Sum_Age
FROM Student;

---How many days passes since the test date?
SELECT 
	DISTINCT a.Name,
	DATEDIFF(DY,b.date,getdate()) as day_passed
FROM Test a
JOIN StudentTest b
ON a.TestID =b.TestID;

--- Show students obtaining the highest marks
SELECT TOP(1) with ties
	a.Name,
	b.Mark
FROM Student a
JOIN StudentTest b
ON a.RN = b.RN
ORDER BY b.Mark DESC; 

--- Show students obtaining the lowest marks
SELECT TOP(1) with ties
	a.Name,
	b.Mark
FROM Student a
JOIN StudentTest b
ON a.RN = b.RN
ORDER BY b.Mark; 
--- Show the average marks for each students, in the form of 2 digit numbers

SELECT 
	b.Name,
	CONVERT(NUMERIC(4,2),AVG(a.Mark)) AS Student_AvgMark
FROM StudentTest a
JOIN Student b
ON a.RN = b.RN
GROUP BY b.Name;

---Show the list of students and the tests they took
SELECT
	c.Name AS Student_names,
	a.Name AS Tests_taken
FROM Test a
JOIN StudentTest b
ON a.TestID = b.TestID
JOIN Student c
ON b.RN = c.RN;

---Show the list of students who did not take any tests
SELECT
	Name AS Student_name
FROM Student 
WHERE RN NOT IN (SELECT RN
                 FROM StudentTest);

---Show the list of students who need to retake tests because they received marks lower than 5
SELECT
	c.Name AS Student_names,
	b.Mark,
	a.Name AS Tests_to_retake
FROM Test a
JOIN StudentTest b
ON a.TestID = b.TestID
JOIN Student c
ON b.RN = c.RN
WHERE b.Mark <5;
---Show the name and average mark of the student having the highest average mark
SELECT TOP(1) with ties
	b.Name,
	CONVERT(NUMERIC(4,2),AVG(a.Mark)) AS Student_AvgMark
FROM StudentTest a
JOIN Student b
ON a.RN = b.RN
GROUP BY b.Name
ORDER BY Student_AvgMark DESC;
---Show the name and average mark of the student having the lowest average mark
SELECT TOP(1) with ties
	b.Name,
	CONVERT(NUMERIC(4,2),AVG(a.Mark)) AS Student_AvgMark
FROM StudentTest a
JOIN Student b
ON a.RN = b.RN
GROUP BY b.Name
ORDER BY Student_AvgMark;

--- Show the highest mark of each subject
SELECT 
	b.Name, 
	Max(Mark) as highest_mark
FROM StudentTest a
JOIN Test b
ON a.TestID = b.TestID
GROUP BY a.TestID,b.Name;

---Show the list of students who took tests, if anyone did not take the test, show Null valuesc
SELECT
	c.Name AS Student_names,
	a.Name AS Tests_taken
FROM Test a
JOIN StudentTest b
ON a.TestID = b.TestID
RIGHT JOIN Student c
ON b.RN = c.RN;

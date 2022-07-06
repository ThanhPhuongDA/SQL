---- Create database DBLab1
CREATE DATABASE DBLab1;
USE DBLab1
GO;

--- Create tables: Students, Classes, ClassStudent, Subjects
CREATE TABLE Students(
StudentID int NOT NULL PRIMARY KEY IDENTITY (1, 1),
StudentName NVARCHAR(50),
Age int,
Email VARCHAR(100));

USE DBLab1;
CREATE TABLE Classes(
ClassID int NOT NULL PRIMARY KEY IDENTITY (1, 1),
ClassName NVARCHAR(50));

USE DBLab1;
CREATE TABLE ClassStudent(
StudentID int,
ClassID int);

USE DBLab1;
CREATE TABLE Subjects(
SubjectID int NOT NULL PRIMARY KEY IDENTITY (1, 1),
SubjectName nvarchar(50));

USE DBLab1;
CREATE TABLE Marks(
Mark int,
SubjectID int,
StudentID int);

---- Insert values into the tables just created before
INSERT INTO Students(StudentName,Age,Email)
VALUES
('Nguyen Quang An',18,'an@yahoo.com'),
('Nguyen Cong Vinh',20,'vinh@gmail.com'),
('Nguyen Van Quyen',19,'quyen'),
('Pham thanh Binh',25,'binh@com'),
('Nguyen Van Tai Em',30,'taiem@sport.vn');

INSERT INTO Classes(ClassName)
VALUES
('C0706L'),
('C0708G');

INSERT INTO ClassStudent(StudentID,ClassID)
VALUES
(1,1),
(2,1),
(3,2),
(4,2),
(5,2);

INSERT INTO Subjects(SubjectName)
VALUES
('SQL'),
('Java'),
('C'),
('Visual Basic');

INSERT INTO Marks(Mark,SubjectID,StudentID)
VALUES
(8,1,1),
(4,2,1),
(9,1,1),
(7,1,3),
(3,1,4),
(5,2,5),
(8,3,3),
(1,3,5),
(3,2,4);

ALTER TABLE Students ADD CHECK(Age between 15 and 50);
ALTER TABLE Students ADD Status bit NOT NULL Default(1);
---- Add Foreign Keys to connect tables together to create database schema
ALTER TABLE Marks ADD FOREIGN KEY(StudentID) REFERENCES Students(StudentID);
ALTER TABLE Marks ADD FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID);

ALTER TABLE ClassStudent ADD FOREIGN KEY(StudentID) REFERENCES Students(StudentID);
ALTER TABLE ClassStudent ADD FOREIGN KEY(ClassID) REFERENCES Classes(ClassID);



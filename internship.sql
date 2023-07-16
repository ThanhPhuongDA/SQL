--- Create database and 3 tables with relationship./

CREATE DATABASE internship;
USE internship;
CREATE TABLE dean (dean_id char(10) PRIMARY KEY, 
                   names char(30),
                   phone char(10));

CREATE TABLE professor (professor_id int PRIMARY KEY,
                       full_name char(30), 
					   salary decimal(5,2), 
					   dean_id char(10) REFERENCES dean);
CREATE TABLE student (student_id int PRIMARY KEY,
                       full_name char(30), 
					   dean_id char(10) FOREIGN KEY REFERENCES dean,
					   birth_year int,
					   place_birth char(30));
CREATE TABLE intern_report (report_id char(10) PRIMARY KEY, 
					  report_name char(30),
					  expense int,
					  intern_place char(30));

CREATE TABLE report_result(student_id int PRIMARY KEY,
						report_id char(10) FOREIGN KEY REFERENCES intern_report, 
						professor_id int FOREIGN KEY REFERENCES professor, 
						result decimal(5,2));

---Insert values into 3 tables
INSERT INTO dean VALUES
('Geo','Geography',3855413),
('Math','Mathematics',3855411),
('Lit','Literature',3855410),
('IT','Informatics Technology',3855408),
('Engine','Engineer',3855409),
('Bio','Biotechnology',3855412);


INSERT INTO professor VALUES
(1,'Thanh Binh',708.50,'Geo'),    
(2,'Thu Huong',600.00,'Math'),
(3,'Chu Vinh',650.00,'Geo'),
(4,'Le Thi Ly',780.00,'Bio'),
(5,'Tran Van',890.00,'IT'),
(6,'Nguyen Hoa',800.00,'Lit'),
(7,'Vo Xuan',900.00,'Math'),
(8,'Trieu Lan',950.00,'Engine'),
(9,'Ly Binh',950.00,'IT'),
(10,'Phuong Lan',850.00,'Engine')
;
INSERT INTO student VALUES
(1,'Le Van Son','Bio',2000,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1999,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1998,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1999,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1997,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',2000,'Nghe An'),
(9,'Tran Van Quang','Engine',2001,'Hue'),
(10,'Vo Thi Phap','IT',null,'null'),
(11,'Ly Van Duc','Lit',2002,'Ha Noi'),
(12,'Nguyen Van Dat','IT',2001,'Ha Noi');

INSERT INTO intern_report VALUES
('rp01','GIS',100,'Nghe An'),
('rp02','ARC GIS',500,'Nam Dinh'),
('rp03','Spatial DB',100, 'Ha Tinh'),
('rp04','MAP',300,'Quang Binh' ),
('rp05','Big Data',400,'Ha Noi' ),
('rp06','Green energy',350,'Nam Dinh'),
('rp07','War and Peace',300,'Ha Tinh' ),
('rp08','Blockchain system',320,'Thanh Hoa' ),
('rp09','IT system',400,'Ho  Chi Minh' ),
('rp10','Fibonaci',360,'Hue' )
;
INSERT INTO report_result VALUES
(1,'rp01',3,8.00),
(2,'rp03',4,8.50),
(3,'rp03',2,10.00),
(5,'rp04',4,7.00),
(6,'rp01',3,Null),
(7,'rp04',1,10.00),
(8,'rp05',10,6.50),
(9,'rp06',5,7.50),
(10,'rp07',9,8.50),
(11,'rp08',7,9.50),
(12,'rp09',8,9.00);


---1.Return all of the professor details and deans that the professors are working in./
SELECT professor_id, 
	full_name as professor_name,
	dean.names as dean
FROM professor 
JOIN dean
ON professor.dean_id = dean.dean_id
;

---2.Return all of the professor details and deans that the professors are teaching in ‘Geography' and 'Mathematics'./
SELECT professor_id, 
	full_name as professor_name,
	dean.names as dean
FROM professor 
JOIN dean
ON professor.dean_id = dean.dean_id
WHERE dean.names IN ('Geography','Mathematics')
;

---3.How many students in Biotechnology dean?./
SELECT DISTINCT COUNT (student_id)
FROM student s 
JOIN dean d
ON s.dean_id = d.dean_id
WHERE d.names= 'Biotechnology' 
;

----4.Extract student_id, Name and Age of students in Maths dean./
SELECT student_id, 
	full_name as Student_Name, 
	(year( getdate())- birth_year) as Age
FROM student s 
JOIN dean d
ON s.dean_id = d.dean_id
WHERE d.names= 'Mathematics'
; 

----5.How many professors in Biotechnology dean./
SELECT DISTINCT COUNT(professor_id)
FROM professor p
JOIN dean d
ON p.dean_id = d.dean_id
WHERE d.names = 'Biotechnology';

----6.Students who did not hand in their internship report./
SELECT st.student_id,
	   st.full_name
FROM student st 
WHERE NOT EXISTS(
SELECT rr.student_id 
FROM report_result rr 
WHERE st.student_id = rr.student_id)
;

---7.Return dean_id, dean_names no. of professors in each dean./
SELECT d.dean_id, 	
	   d.names as dean,
	   COUNT(p.professor_id) as no_professor
FROM professor p
JOIN dean d
ON p.dean_id = d.dean_id
GROUP BY d.dean_id,	d.names
;

---8.Return the telephone no. of the dean where student named‘Le Van Son’ is studying./
SELECT d.phone
FROM dean d
JOIN student st
ON d.dean_id = st.dean_id
WHERE st.full_name LIKE '%Le Van Son%'


----9.Return report_id and report names which professor ‘Trieu Lan’ is in charge
SELECT ir.report_id, 
	   ir.report_name
FROM intern_report ir
JOIN report_result rr
ON rr.report_id = ir.report_id
JOIN professor p 
ON rr.professor_id = p.professor_id
WHERE p.full_name LIKE'%Trieu Lan%';

---10.The intern report that's not been completed and who's not accomplised it./
SELECT rr.student_id,
	   rr.report_id, 
	   ir.report_name
FROM intern_report ir
JOIN report_result rr
ON ir.report_id=rr.report_id
WHERE rr.result is null
;

---11. Return the id, intern_report that is most costly./
SELECT report_id, report_name
FROM intern_report
WHERE expense = (SELECT MAX(expense) 
                 FROM intern_report)
;

---12. Return report id and report name that more than 2 students are working in./
SELECT ir.report_id, ir.report_name
FROM intern_report ir
JOIN report_result rr
ON ir.report_id = rr.report_id
JOIN student st
ON rr.student_id = st.student_id
GROUP BY ir.report_id, ir.report_name
HAVING COUNT(st.student_id)>=2
;

---13.  Return the professor id, professor name and dean name who have instructed more than 2 students./

SELECT rr.professor_id, 
	p.full_name as Professor_name, 
	d.names as dean_name
FROM report_result rr
JOIN professor p
ON p.professor_id = rr.professor_id
JOIN dean d
ON d.dean_id = p.dean_id
GROUP BY rr.professor_id, p.full_name, d.names
HAVING COUNT(rr.student_id)>=2
;

---14.Extract student id, students' names và and final results of the students in ‘Engine' and 'IT'./
SELECT st.student_id,
	st.full_name as Student_name,
	rr.result 
FROM student st
JOIN report_result rr
ON st.student_id = rr.student_id
WHERE st.dean_id IN ('IT','Engine')
;
---15. Extract the information of students who study in their home city
SELECT st.student_id,
	st.full_name as Student_name
FROM student st
JOIN report_result rr
ON rr.student_id = st.student_id
JOIN intern_report ir
ON rr.student_id = st.student_id
WHERE st.place_birth = ir.intern_place
;

---16. Return the students whose results are missing./
SELECT st.student_id,
	st.full_name as Student_name,
	st.birth_year,
	st.place_birth
FROM student st
JOIN report_result rr
ON rr.student_id = st.student_id
WHERE rr.result IS NULL;

---17. Return the students who have HIGHEST report's result
SELECT st.student_id,
	st.full_name as Student_name,
	st.birth_year,
	st.place_birth,
	rr.result
FROM student st
JOIN report_result rr
ON rr.student_id = st.student_id
WHERE rr.result =(SELECT MAX(result) FROM report_result)
;

---18. Return the students who have LOWEST report's result
SELECT st.student_id,
	st.full_name as Student_name,
	st.birth_year,
	st.place_birth,
	rr.result
FROM student st
JOIN report_result rr
ON rr.student_id = st.student_id
WHERE rr.result =(SELECT MIN(result) FROM report_result)
;
CREATE DATABASE exercise;
USE exercise;

CREATE TABLE department(
	dname char(15), 
	dnumber int PRIMARY KEY,
    mgrssn char(15), 
    mgrstartssn char(15));

CREATE TABLE deft_locations(
	dnumber int ,
    FOREIGN KEY(dnumber) REFERENCES department(dnumber),
	dlocation char(20), 
    PRIMARY KEY(dnumber,dlocation));

CREATE TABLE project(
	pname char(15),
    pnumber int PRIMARY KEY,
	plocation char(15),
    dnumber int,
    FOREIGN KEY(dnumber) REFERENCES department(dnumber));

CREATE TABLE employee(
	fname char(15),
	minit char(5),
    lname char(15),
    ssn char(15) PRIMARY KEY,
	bdate char(12),
    addres char(50),
    sex char(5),
    salary int, 
    supperssn char(20),
	dnumber int,
    FOREIGN KEY(dnumber) REFERENCES department(dnumber));

CREATE TABLE work_on(
	ssn char(15),
	FOREIGN KEY(ssn) REFERENCES employee(ssn),
	pnumber int,
    FOREIGN KEY(pnumber) REFERENCES project(pnumber),
    hours float(1),
    PRIMARY KEY(ssn,pnumber));

CREATE TABLE dependen(
	ssn char(15),
    FOREIGN KEY(ssn) REFERENCES employee(ssn),
    dependen_name char(10),
	sex char(5), 
    bdate char(15),
    relationship char(20), 
    PRIMARY KEY(ssn,dependen_name));

INSERT INTO department VALUES
('reserch',5,'333445555','1988-05-22'),
('administration',4,'987654321','1995-01-01'),
('headquarters',1,'888665555','1981-06-19');

INSERT INTO deft_locations VALUES
(1,'houston'),
(4,'stafford'),
(5,'bellaire'),
(5,'sugarland'),
(5,'houston');

INSERT INTO project VALUES
('productx',1,'bellaire',5),
('producty',2,'sugarland',5),
('productz',3,'houston',5),
('computerization',10,'stafford',4),
('reorganizaton',20,'houston',1),
('newbenefits',30,'stafford',4);

INSERT INTO employee VALUES
('john','b','smith','123456789','1965-01-09','731 fondren, houston,tx','m',30000,'333445555',5),
('franklin','t','wong','333445555','1955-12-08','638 voss,houston,tx','m',40000,'888665555',5),
('alicia','j','zelaya','999887777','1968-07-19','3321 castle,spring,tx','f',25000,'987654321',4),
('jennifer','s','wallace','987654321','1941-06-20','291 berry,bellaire,tx','f',43000,'888665555',4),
('ramesh','k','narayan','666884444','1962-09-15','975 fire oak,humble,tx','m',38000,'453453453',5),
('joyce','a','english','453453453','1972-07-31','5631 rice,houston,tx','f',25000,'333445555',5),
('ahmad','v','jabbar','987987987','1969-03-29','980 dallas,houston,tx','m',25000,'987654321',4),
('james','e','borg','888665555','1937-11-10','450 stone, houston,tx','m',55000,'null',1);

INSERT INTO work_on VALUES
('123456789',1,32.5),
('123456789',2,7.5),
('666884444',3,40.0),
('453453453',1,20.0),
('453453453',2,20.0),
('333445555',2,10.0),
('333445555',3,10.0),
('333445555',10,10.0),
('333445555',20,10.0),
('999887777',30,30.0),
('999887777',10,10.0),
('987987987',10,35.0),
('987987987',30,5.0),
('987654321',30,20.0),
('987654321',20,15.0),
('888665555',20,null);

SELECT *
FROM project
;

INSERT INTO dependen VALUES
('333445555','alice','f','1986-04-05','daughter'),
('333445555','theodore','m','1983-10-25','son'),
('333445555','joy','f','1958-05-03','spouse'),
('987654321','abner','m','1942-02-28','spouse'),
('123456789','michael','m','1988-01-04','son'),
('123456789','alice','f','1988-12-30','daughter'),
('123456789','elizbeth','f','1967-05-05','spouse');

SELECT 
    *
FROM
    employee;
    
SELECT 
    *
FROM
    project;   
SELECT 
    *
FROM
    work_on;

### 1.Employees in department 4 & 5 working for project ProductX more than 10 hours a week./
SELECT 
    e.fname AS Fist_name,
    e.lname AS Last_name,
    e.minit,
    p.pname,
    d.dnumber,
    w.hours
FROM
    employee e
JOIN
    department d ON e.dnumber = d.dnumber
JOIN
    work_on w ON w.ssn = e.ssn
JOIN
    project p ON p.dnumber = d.dnumber
WHERE
    d.dnumber IN (4 , 5) 
    AND w.hours > 10
	AND p.pname = 'productx';

###2. List all employees whose cousins have the first names the same as theirs./

SELECT DISTINCT
    *
FROM
    employee e
JOIN
    dependen d 
ON e.ssn = d.ssn
WHERE
    e.fname = d.dependen_name
;

###3. Find all employees under the direct management of Joyce A.Englih./

SELECT 
    *
FROM
    employee e
JOIN
    employee f ON e.supperssn = f.ssn
WHERE
    f.fname = 'joyce' 
    AND f.minit = 'a'
	AND f.lname = 'english'
;
    
### 4. List all projects and number of working hours all employees who spend on these projects each week./
SELECT 
    p.pname, p.pnumber, SUM(hours) as "hours/week"
FROM
    project p
JOIN
    work_on w ON w.pnumber = p.pnumber
JOIN
    employee e ON w.ssn = e.ssn
GROUP BY   p.pname, p.pnumber
;

### 5. List the projects and all employees working on these projects
SELECT 
    p.pname, p.pnumber, e.fname,e.minit,e.lname
FROM
    project p
JOIN
    work_on w ON w.pnumber = p.pnumber
JOIN
    employee e ON w.ssn = e.ssn
;

### 6. List all employee names who do not take part in any projects./
SELECT 
     e.fname,e.minit,e.lname
FROM employee e
WHERE e.ssn NOT IN (SELECT ssn FROM work_on );

###7. List employee name and the average salary of each department./

WITH temp AS (
		SELECT 
		d.dname, d.dnumber,AVG(e.salary) as average_salary
		FROM employee e
		JOIN department d
		ON e.dnumber = d.dnumber
		GROUP BY d.dname,d.dnumber
        ) 
SELECT 
    e.fname as First_name, 
    e.minit as Middle_name, 
    e.lname as Last_name, 
    temp.dname as Department,
    temp.average_salary as Average_salary
FROM
    employee e
JOIN
    temp ON e.dnumber = temp.dnumber
;

### 8.Show average salary of female employees./
SELECT 
		AVG(salary) as average_salary
FROM employee 
WHERE sex='f'
;

###9. Name and address of employees who work on at least 1 project in Houston but their departments are not based there./
SELECT 
    DISTINCT e.fname AS First_name,
      e.minit AS Middle_name,
      e.lname AS Last_name,
      e.addres AS Home_address
FROM
    employee e
JOIN
    department d 
	ON d.dnumber = e.dnumber AND e.ssn in(select ssn from work_on where pnumber in (select pnumber from project where plocation='houston'))
JOIN
    deft_locations dl 
	ON d.dnumber = dl.dnumber AND dl.dlocation <>'houston';
 
###10. List all department managers who do not have dependents./
SELECT 
    DISTINCT e.fname,e.minit,e.lname
FROM
    employee e
JOIN
    department d ON e.ssn = d.mgrssn
WHERE e.ssn NOT IN(SELECT ssn from dependen);
    
###11.Change the address of the employee whose ssn '123456789' into '92 London, UK'
UPDATE employee 
SET 
    addres = '92 London, UK'
WHERE
    ssn = '123456789';

SELECT 
    *
FROM
    employee;
    
    
###12. Change the relationship between Flanklin with the dependen Joy into 'friend'./
UPDATE dependen
SET relationship ='friend'
WHERE 
	ssn = (SELECT ssn FROM employee WHERE fname='franklin') 
AND dependen_name ='joy'
;

SELECT 
    *
FROM
    dependen d
;

### 13. Double salary of 'headquarters' department./
UPDATE employee
SET salary = salary*2
WHERE dnumber=(SELECT dnumber from department WHERE dname ='headquarters');

SELECT *
FROM employee e
JOIN department d
ON e.dnumber = d.dnumber 
WHERE d.dname = 'headquarters';

### 14. Delete project  'product z' from the database./
DELETE FROM project 
WHERE
    pname = 'productx';
    
###Comment: cannot do because it affects the foreign key
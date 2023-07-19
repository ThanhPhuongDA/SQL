USE health;
CREATE TABLE patient (
    patient_nbr INT PRIMARY KEY,
    race VARCHAR(255),
    gender VARCHAR(255),
    age VARCHAR(255)
);


CREATE TABLE health (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    FOREIGN KEY (patient_nbr)
        REFERENCES patient (patient_nbr),
    admission_type_id INT,
    discharge_disposition_id INT,
    time_in_hospital INT,
    medical_specialty VARCHAR(25),
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    number_diagnoses INT,
    diabetesMed VARCHAR(255),
    readmitted VARCHAR(255)
);

Show variables like 'local_infile';
set global local_infile = 1;

load data local infile 'C:/portfolio/dataset/patient.csv'
INTO table health.patient
fields terminated by ','
ignore 1 rows;

load data local infile 'C:/portfolio/dataset/health.csv'
INTO table health.health
fields terminated by ','
ignore 1 rows;


SELECT 
    COUNT(*)
FROM
    health
;

SELECT 
    COUNT(*)
FROM
    patient
;

SELECT 
    *
FROM
    patient
LIMIT 4;

SELECT 
    AVG(time_in_hospital)
FROM
    health
;
SELECT 
    p.race, 
    AVG(h.time_in_hospital) AS times_spent_in_hospital
FROM
    health h
JOIN
    patient p ON h.patient_nbr = p.patient_nbr
GROUP BY p.race
ORDER BY times_spent_in_hospital DESC
;


SELECT 
    p.race, AVG(h.num_lab_procedures) AS no_lab_procedure
FROM
    patient p
JOIN
    health h ON h.patient_nbr = p.patient_nbr
GROUP BY p.race
ORDER BY no_lab_procedure DESC
;
SELECT 
    medical_specialty,
    ROUND(AVG(num_procedures), 1) AS avg_procedures,
    COUNT(*) AS count
FROM
    health
GROUP BY medical_specialty
ORDER BY avg_procedures DESC
;

SELECT 
    medical_specialty, 
    SUM(num_procedures) AS sum_procedures
FROM
    health
GROUP BY medical_specialty
HAVING medical_specialty <> '?'
ORDER BY sum_procedures DESC

;
SELECT 
    medical_specialty, 
    SUM(num_procedures) AS sum_procedures
FROM
    health
GROUP BY medical_specialty
HAVING medical_specialty <> '?'
ORDER BY sum_procedures;

SELECT 
    medical_specialty,
    ROUND(AVG(num_procedures), 1) AS avg_procedures
FROM
    health
GROUP BY medical_specialty
HAVING avg_procedures > 2.5
ORDER BY avg_procedures DESC;

SELECT 
    MIN(num_lab_procedures),
    AVG(num_lab_procedures),
    MAX(num_lab_procedures)
FROM
    health;

SELECT 
    num_lab_procedures,
    CASE
        WHEN
            num_lab_procedures >= 0
			AND num_lab_procedures < 25
        THEN
            'few'
        WHEN
            num_lab_procedures >= 25
            AND num_lab_procedures < 55
        THEN
            'average'
        ELSE 'many'
    END AS procedure_frequency
FROM
    health;

SELECT 
    AVG(time_in_hospital) AS avg_time,
    CASE
        WHEN
            num_lab_procedures >= 0
                AND num_lab_procedures < 25
        THEN
            'few'
        WHEN
            num_lab_procedures >= 25
                AND num_lab_procedures < 55
        THEN
            'average'
        ELSE 'many'
    END AS procedure_frequency
FROM
    health
GROUP BY procedure_frequency
ORDER BY avg_time DESC;

SELECT 
    h.patient_nbr
FROM
    health h
JOIN
    patient p ON h.patient_nbr = p.patient_nbr
WHERE
    p.race = 'African American'
    OR h.diabetesMed = 'Yes'
ORDER BY h.patient_nbr;

SELECT 
    COUNT(readmitted) / (SELECT 
							COUNT(readmitted)
						FROM
							health) AS readmission_ratio
FROM
    health
WHERE
    readmitted LIKE '%<30%';
### 11% of patient discharged reamitted in less than 30 days

WITH avg_time AS(
SELECT AVG(time_in_hospital) 
FROM health)
SELECT * FROM health
WHERE admission_type_id=1
AND time_in_hospital < (SELECT * from avg_time)
;
SELECT 
    h.patient_nbr,
    p.race,
    h.num_medications,
    h.num_lab_procedures
FROM
    health h
JOIN
    patient p ON h.patient_nbr = p.patient_nbr
ORDER BY h.num_medications DESC , num_lab_procedures DESC
LIMIT 50;
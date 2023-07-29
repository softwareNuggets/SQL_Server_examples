--drop table #Patients;
--drop table #MedicalProcedures

--GitHub
--https://github.com/softwareNuggets
-- /SQL_Server_examples
-- /use_CTE_to_get_1_from_many_then_join.sql

CREATE TABLE #Patients (
    id			INT PRIMARY KEY,
    patient_id	INT,
	first_name	nvarchar(30),
	last_name	nvarchar(30)
);

CREATE TABLE #MedicalProcedures (
    patient_id				INT,
    dateof_procedure		DATE,
    med_procedure_name		VARCHAR(50),
    PRIMARY KEY (patient_id, dateof_procedure)
);


INSERT INTO #Patients(id, patient_id, first_name, last_name) 
VALUES
(1, 1001, N'Ricky',		N'Thomas'),
(2, 1002, N'Chloé',		N'Monet'),
(3, 1003, N'César',		N'Torres'),
(4, 1004, N'Fred',		N'Sanford'),
(5, 1005, N'Nicole',	N'Johnson');

select *
from #Patients

INSERT INTO #MedicalProcedures 	(patient_id, dateof_procedure, 	med_procedure_name) 
VALUES
(1001, '2023-07-25', 'Procedure A'),
(1001, '2023-07-26', 'Procedure B'),
(1002, '2023-07-25', 'Procedure C'),
(1002, '2023-07-26', 'Procedure D'),
(1002, '2023-07-27', 'Procedure E'),
(1003, '2023-07-26', 'Procedure F1'),
(1003, '2023-08-26', 'Procedure F2'),
(1003, '2023-09-26', 'Procedure F3'),
(1005, '2023-07-26', 'Procedure A') ;



--output
1	Ricky	Thomas	1001	2023-07-26	Procedure B
2	Chloé	Monet	1002	2023-07-27	Procedure E
3	César	Torres	1003	2023-09-26	Procedure F3
5	Nicole	Johnson	1005	2023-07-26	Procedure A




WITH MaxProcedureDatesCTE(patient_id, max_date) 
AS 
(
    SELECT patient_id, MAX(dateof_procedure) AS max_date
    FROM #MedicalProcedures
    GROUP BY patient_id
)
SELECT	p.id, 
		p.first_name,
		p.last_name,
		cte.patient_id, 
		cte.max_date, 
		mp.med_procedure_name
FROM #Patients p
JOIN #MedicalProcedures mp 
	ON (p.patient_id = mp.patient_id)
JOIN MaxProcedureDatesCTE cte 
	ON (mp.patient_id = cte.patient_id 
		AND mp.dateof_procedure = cte.max_date)
order by p.id



















--solution #2

SELECT	p.id, 
		p.patient_id, 
		mp.dateof_procedure, 
		mp.med_procedure_name
FROM #Patients p
	JOIN #MedicalProcedures mp 
		ON (p.patient_id = mp.patient_id)
WHERE NOT EXISTS (
    SELECT 1
    FROM #MedicalProcedures mp2
    WHERE mp.patient_id = mp2.patient_id
    AND mp.dateof_procedure < mp2.dateof_procedure
);









--solution #3

SELECT	p.id, 
		p.patient_id, 
		mp.dateof_procedure, 
		mp.med_procedure_name
FROM #Patients p
JOIN #MedicalProcedures mp 
	ON (p.patient_id = mp.patient_id)
JOIN (
    SELECT	
			patient_id, 
			MAX(dateof_procedure) AS max_date
    FROM #MedicalProcedures
    GROUP BY patient_id
) as mpd 
ON (mp.patient_id = mpd.patient_id 
	AND mp.dateof_procedure = mpd.max_date)
order by p.id




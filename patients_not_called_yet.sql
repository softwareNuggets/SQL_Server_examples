--GitHub
--https://github.com/softwareNuggets
--       /SQL_Server_examples
--       /patients_not_called_yet.sql

--drop table #Patients;
--drop table #Appointments;

CREATE TABLE #Patients (
    PatientID			INT PRIMARY KEY,
    first_name			NVARCHAR(30),
	last_name			nvarchar(30),
    DateOfBirth			DATE,
	CellPhoneNumber		VARCHAR(15)
);

CREATE TABLE #Appointments (
    AppointmentID	INT PRIMARY KEY,
    PatientID		INT,
    appt_date		datetime,
    FOREIGN KEY (PatientID) REFERENCES #Patients(PatientID)
);


INSERT INTO #Patients (PatientID, first_name, last_name, DateOfBirth, CellPhoneNumber)
VALUES
    (1, 'Alice', 'Smith', '1990-03-15', '555-123-4567'),
    (2, 'Bob', 'Johnson', '1985-08-22', '555-987-6543'),
    (3, 'Charlie', 'Brown', '1992-11-10', '555-555-5555'),
    (4, 'David', 'Miller', '1988-06-04', '555-111-2222'),
    (5, 'Emma', 'Davis', '1995-01-29', '555-444-3333'),
    (6, 'Frank', 'Wilson', '1993-09-18', '555-666-7777'),
    (7, 'Grace', 'Jones', '1989-12-07', '555-888-9999'),
    (8, 'Henry', 'Martinez', '1997-04-03', '555-222-1111'),
    (9, 'Isabella', 'Lee', '1991-07-12', '555-777-8888'),
    (10, 'Jack', 'Taylor', '2000-02-14', '555-000-5555');


INSERT INTO #Appointments (AppointmentID, PatientID, appt_date)
VALUES
    (101, 1, '2023-08-05 09:00:00'),
    (102, 2, '2023-08-06 14:30:00'),
    (103, 1, '2023-08-07 11:15:00'),
    (104, 3, '2023-08-08 10:45:00'),
    (105, 4, '2023-08-09 16:00:00'),
    (106, 1, '2023-08-10 13:45:00'),
    (107, 2, '2023-08-11 10:30:00'),
    (108, 5, '2023-08-12 15:20:00'),
    (109, 3, '2023-08-13 12:00:00'),
    (110, 4, '2023-08-14 17:30:00'),
    (111, 1, '2024-02-15 09:30:00'),
    (112, 2, '2024-03-20 11:45:00'),
    (113, 5, '2024-04-25 14:15:00'),
    (114, 6, '2024-05-30 16:30:00'),
    (115, 7, '2024-06-02 13:00:00');


SELECT p.PatientID, p.first_name + ' ' + p.last_name as Patient, p.DateOfBirth AS Birthday, p.CellPhoneNumber
FROM #Patients p
WHERE NOT EXISTS (
    SELECT a.PatientID
    FROM #Appointments a
    WHERE p.PatientID = a.PatientID
);



SELECT	p.PatientID, 
		p.first_name + ' ' + last_name as Patient, 
		p.DateOfBirth AS Birthday, 
		p.CellPhoneNumber
FROM #Patients p
WHERE  	(
			SELECT count(*)
			FROM #Appointments a
			WHERE p.PatientID = a.PatientID
		) = 0


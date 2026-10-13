/*
=====================================================================
Data Cleaning
=====================================================================
Purpose: To correct inaccurate, incomplete, inconsistent, or incorrectly
formatted data so that the dataset is reliable and ready for analysis.

SQL Functions used:
MIN, MAX, AVG, CAST, DATEDIFF

SQL Statements used:
UNION ALL, ALTER TABLE, ALTER COLUMN, ADD, UPDATE, SET, DELETE

*/

-- check how many rows have negative age values

SELECT *
FROM appointment
WHERE Age < 0;

-- Delete row with negative age values

DELETE FROM appointment
WHERE Age < 0;

-- Fix data type and format for dates
ALTER TABLE appointment
	ALTER COLUMN ScheduledDay DATETIME;

ALTER TABLE appointment
	ALTER COLUMN AppointmentDay DATE;

-- Add lead time column

ALTER TABLE appointment ADD Lead_Time_Days INT;

UPDATE appointment
SET Lead_Time_Days = DATEDIFF(DAY,CAST(ScheduledDay AS DATE),AppointmentDay);

SELECT
    MAX(Lead_Time_Days) AS Max_Lead_Time,
    MIN(Lead_Time_Days) As Min_Lead_Time
FROM appointment;

-- Fix negative lead time days

SELECT
    AppointmentID,
    PatientId,
    ScheduledDay,
    AppointmentDay
FROM appointment
WHERE Lead_Time_Days < 0;

DELETE FROM appointment
    WHERE Lead_Time_Days < 0;

-- Duplicates

SELECT
    AppointmentID,
    COUNT(*) AS Records
FROM appointment
GROUP BY AppointmentID
HAVING COUNT(*) > 1;

SELECT
    PatientID,
    COUNT(*) AS Records
FROM appointment
GROUP BY PatientID
HAVING COUNT(*) > 1;

-- Missing values

SELECT 'PatientId' AS ColumnName, COUNT(*) AS MissingValues
FROM appointment
WHERE PatientId IS NULL

UNION ALL

SELECT 'AppointmentID', COUNT(*)
FROM appointment
WHERE AppointmentID IS NULL

UNION ALL

SELECT 'Gender', COUNT(*)
FROM appointment
WHERE Gender IS NULL

UNION ALL

SELECT 'ScheduledDay', COUNT(*)
FROM appointment
WHERE ScheduledDay IS NULL

UNION ALL

SELECT 'AppointmentDay', COUNT(*)
FROM appointment
WHERE AppointmentDay IS NULL

UNION ALL

SELECT 'Age', COUNT(*)
FROM appointment
WHERE Age IS NULL

UNION ALL

SELECT 'Neighbourhood', COUNT(*)
FROM appointment
WHERE Neighbourhood IS NULL

UNION ALL

SELECT 'Scholarship', COUNT(*)
FROM appointment
WHERE Scholarship IS NULL

UNION ALL

SELECT 'Hipertension', COUNT(*)
FROM appointment
WHERE Hipertension IS NULL

UNION ALL

SELECT 'Diabetes', COUNT(*)
FROM appointment
WHERE Diabetes IS NULL

UNION ALL

SELECT 'Alcoholism', COUNT(*)
FROM appointment
WHERE Alcoholism IS NULL

UNION ALL

SELECT 'Handcap', COUNT(*)
FROM appointment
WHERE Handcap IS NULL

UNION ALL

SELECT 'SMS_received', COUNT(*)
FROM appointment
WHERE SMS_received IS NULL

UNION ALL

SELECT 'No_show', COUNT(*)
FROM appointment
WHERE No_show IS NULL;






    

    

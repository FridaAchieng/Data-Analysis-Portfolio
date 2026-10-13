
/* =====================================================================================
   Data Exploration
   =====================================================================================

   Purpose: To understand the structure, contents, patterns, and potential data-quality 
   issues in the dataset before cleaning and analysis.
   
   SQL functions used:
   WHERE, GROUP BY, ORDER BY, TOP, COUNT,DISTINCT, MIN, MAX,AVG
   ======================================================================================
   */

USE Appointment;
-- view data 

SELECT TOP 10 *
FROM dbo.appointment;

-- Row count

SELECT COUNT(*) as TotalRows
FROM appointment;

-- Columns count

SELECT COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'appointment';

-- Data types

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'appointment';

-- Dimension(categories) Exploration

SELECT Gender, COUNT(*) AS Records
FROM appointment
GROUP BY Gender;

SELECT No_Show, COUNT(*) AS Records
FROM appointment
GROUP BY No_Show;

SELECT Handcap, COUNT(*) AS Records
FROM appointment
GROUP BY Handcap
ORDER BY Handcap;

SELECT Neighbourhood, COUNT(*) AS Records
FROM appointment
GROUP BY Neighbourhood
ORDER BY Records DESC;

SELECT Scholarship,
    COUNT(*) AS Records
FROM appointment
GROUP BY Scholarship;

-- Age distribution

SELECT
    MIN(Age) AS MinimumAge,
    MAX(Age) AS MaximumAge,
    AVG(Age) AS AverageAge
FROM appointment;

-- Date range
SELECT
    MIN(ScheduledDay) AS FirstScheduledDate,
    MAX(ScheduledDay) AS LastScheduledDate,
    MIN(AppointmentDay) AS FirstAppointmentDate,
    MAX(AppointmentDay) AS LastAppointmentDate
FROM appointment;






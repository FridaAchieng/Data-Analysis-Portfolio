/*
=================================================================================
Data Analysis
=================================================================================
*/


USE Appointment

-- Overall no_ show rate
SELECT
	No_Show,
	COUNT(*) AS total_appointments,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM appointment),2) AS pct_of_total
FROM appointment
GROUP BY No_Show

-- Does day of week matter?

SELECT 
	DATENAME(WEEKDAY,AppointmentDay),
	COUNT(*) AS total_apointments,
	SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) AS No_Shows,
	ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS No_Show_Rate
FROM appointment
GROUP BY DATENAME(WEEKDAY,AppointmentDay)
ORDER BY No_Show_Rate DESC

-- Does lead time matter

SELECT
    CASE 
        WHEN Lead_Time_days = 0 THEN 'Same day'
        WHEN Lead_Time_days BETWEEN 1 AND 3 THEN 'Short (1-3 days)'
        WHEN Lead_Time_days BETWEEN 4 AND 7 THEN 'Within a Week (4-7 days)'
        ELSE 'Long lead (8+ days)'
    END AS lead_time_buckets,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS No_show_Rate
FROM appointment
GROUP BY
    CASE 
        WHEN Lead_Time_Days = 0 THEN 'Same day'
        WHEN Lead_Time_Days BETWEEN 1 AND 3 THEN 'Short (1-3 days)'
        WHEN Lead_Time_Days BETWEEN 4 AND 7 THEN 'Within a Week (4-7 days)'
        ELSE 'Long lead (8+ days)'
    END
ORDER BY No_show_Rate DESC;
	
-- What about age groups

SELECT 
    CASE
        WHEN Age BETWEEN 0 AND 12 THEN 'Child'
        WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
        WHEN Age BETWEEN 20 AND 39 THEN 'Young Adult'
        WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END AS Age_Group,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS No_show_Rate
FROM appointment
GROUP BY
    CASE
        WHEN Age BETWEEN 0 AND 12 THEN 'Child'
        WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
        WHEN Age BETWEEN 20 AND 39 THEN 'Young Adult'
        WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END
ORDER BY No_show_Rate DESC

-- Does SMS reminders help?

SELECT
    CASE WHEN SMS_received = 1 THEN 'SMS received' ELSE 'No SMS'
    END AS SMS_status,
    COUNT(*) AS total_appointments,
    ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS No_show_Rate
FROM appointment
WHERE Lead_Time_Days > 0
GROUP BY
    CASE WHEN SMS_received = 1 THEN 'SMS received' ELSE 'No SMS'
    END 
ORDER BY No_show_Rate




--Which neighbourhood have the highest risk?

SELECT TOP 15
    Neighbourhood,
    COUNT(*) AS total_apointments,
	SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) AS No_Shows,
	ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS No_Show_Rate,
    RANK() OVER (ORDER BY ROUND(SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) DESC) 
    AS risk_rank
FROM appointment
GROUP BY Neighbourhood
HAVING COUNT(*) >= 100
ORDER BY No_Show_Rate DESC





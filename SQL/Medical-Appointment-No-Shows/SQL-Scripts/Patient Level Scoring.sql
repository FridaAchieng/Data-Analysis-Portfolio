
use Appointment

-- Patient level Scoring
SELECT 
    PatientID,
    AppointmentID,
    AppointmentDay,
    No_Show,
    COUNT(*) OVER
        (PARTITION BY PatientID 
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS prior_appointments,
    SUM(CASE WHEN No_Show = 'Yes' THEN 1 ELSE 0 END) OVER
        (PARTITION BY PatientID 
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS prior_no_shows
FROM appointment
ORDER BY PatientID, AppointmentDay;


--Risk scoring view

DROP VIEW IF EXISTS v_appointment_risk;
GO

CREATE VIEW v_appointment_risk AS
WITH patient_history AS (
    SELECT
        PatientId,
        AppointmentID,
        AppointmentDay,
        Neighbourhood,
        Lead_Time_Days,
        SMS_received,
        Scholarship,
        No_show,
        COUNT(*) OVER (
            PARTITION BY PatientId 
            ORDER BY AppointmentDay 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prior_appointments,
        SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) OVER (
            PARTITION BY PatientId 
            ORDER BY AppointmentDay 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prior_no_shows
    FROM appointment
)
SELECT
    PatientId,
    AppointmentID,
    AppointmentDay,
    Neighbourhood,
    Lead_Time_Days,
    prior_appointments,
    prior_no_shows,
    ROUND(prior_no_shows * 1.0/ NULLIF(prior_appointments, 0), 2) AS prior_no_show_rate,
    CASE
        WHEN prior_appointments = 0 THEN 'New Patient - Monitor'
        WHEN (prior_no_shows *1.0 / NULLIF(prior_appointments, 0)) >= 0.5 
             OR lead_time_days >= 8 THEN 'High Risk'
        WHEN (prior_no_shows  * 1.0/ NULLIF(prior_appointments, 0)) >= 0.2 
             OR lead_time_days BETWEEN 4 AND 7 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_tier
FROM patient_history;
GO

SELECT TOP 15
* 
FROM v_appointment_risk
WHERE risk_tier = 'High Risk'
ORDER BY AppointmentDay;

SELECT
    risk_tier,
    COUNT(*) AS total_appointments,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_appointments,
    ROUND(SUM(CASE WHEN a.No_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS No_show_Rate
FROM v_appointment_risk v
JOIN appointment a ON a.AppointmentID = v.AppointmentID

GROUP BY risk_tier
ORDER BY No_show_Rate DESC;

SELECT *
FROM v_appointment_risk;

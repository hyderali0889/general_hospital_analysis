-- CREATE table fact_admissions( 
--     admission_id  BIGSERIAL PRIMARY KEY,
--     Name VARCHAR(50) not null,
--     Arrival_date Text,
--     patient_id VARCHAR(50) CONSTRAINT fk_patient_id
--         REFERENCES patients(patient_id)


--     /* 

--     The Age and Services will be retrived from patients table via JOINS

--     */
-- )

-- Drop table fact_admissions


-- CREATE INDEX idx_fact_admission_patient ON fact_admission(patient_id);
-- CREATE INDEX idx_fact_admission_arrival ON fact_admission(arrival_date);


-- select * from patient_services



-- WITH monthly AS (
--     SELECT
--         month AS period,
--         COUNT(*) AS admissions,
--         AVG(los) AS avg_los,
--         SUM(los) AS total_bed_days   -- utilization proxy
--     FROM patient_services
--     GROUP BY 1
-- )
-- SELECT
--     period,
--     admissions,
--     Round(avg_los , 2) as avg_los,
--     total_bed_days,
    
--     -- Previous period
--     LAG(admissions) OVER (ORDER BY period) AS prev_admissions,
--     admissions - LAG(admissions) OVER (ORDER BY period) AS abs_change,
--     ROUND(100.0 * (admissions - LAG(admissions) OVER (ORDER BY period))
--           / NULLIF(LAG(admissions) OVER (ORDER BY period),0), 1) AS pct_change,
    
--     -- 3-month moving average
--     Round(AVG(admissions) OVER (
--         ORDER BY period 
--         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--     ), 2) AS ma_3m,

-- FROM monthly
-- ORDER BY period;
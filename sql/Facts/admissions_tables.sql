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
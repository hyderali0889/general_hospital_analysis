-- Create Table weekly_services ( 
--     week numeric(5),
--     month numeric(5),
--     service text,
--     available_beds numeric(5),
--     patients_request numeric(5),
--     patients_admitted numeric(5),
--     patients_refused numeric(5), 
--     patient_satisfaction numeric(5),
--     staff_morale numeric(5),
--     event text,
--     patient_id text CONSTRAINT fk_patient_id references patients(patient_id),
--     PRIMARY KEY(week, service)

-- )

-- drop table if exists weekly_services;
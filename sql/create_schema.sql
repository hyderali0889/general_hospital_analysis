
-- Create Table patients ( 
--     patient_id text not null primary key,
--     name text,
--     age numeric(5),
--     arrival_date date,
--     departure_date date,
--     service text,
--     satisfaction numeric(10)
-- )

-- Create Table staff( 
--     staff_id text not null primary key,
--     staff_name text    ,
--     role text,
--     service text
-- )


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

--     PRIMARY KEY(week, service)
-- )


-- Create Table staff_schedule( 
--     week numeric(5),
--     staff_id text not null,
--     present numeric(5),
--     PRIMARY KEY(staff_id, week),
--     CONSTRAINT fk_staff
--         FOREIGN KEY (staff_id)
--         REFERENCES staff (staff_id)


--     /*
--     We can get these via Join with staff Table using 
--         SELECT 
--         ss.week,
--         ss.staff_id,
--         s.staff_name,
--         s.role,
--         s.service,
--         ss.present
--         FROM staff_schedule ss
--         JOIN staff s ON ss.staff_id = s.staff_id;

--     staff_name text,                        
--     role text ,
--     service text, 

--     */
-- )


-- Drop table staff_schedule;

-- TRUNCATE table staff;
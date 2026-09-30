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
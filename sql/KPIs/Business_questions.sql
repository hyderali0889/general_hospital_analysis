-- Business Questions

-- Priority Questions

    -- 1. Capacity and access

        -- 1. Which services have the highest patient demand and refusal rates?


                -- select * from weekly_services limit 10;
                -- select service, SUM(patients_request) as Patient_Demands from weekly_services  group by service  order by Patient_Demands desc;

                -- select service, SUM(patients_refused) as Refusal_rates from weekly_services group by service order by Refusal_rates desc;

                -- Emergency has the highes patient Demand and Refusal Rates


        -- 2. On which weeks and months does demand exceed available bed capacity?
                -- select * from weekly_services limit 10;
                -- select week ,month, ( patients_request - available_beds) , service as patients_without_beds from weekly_services where (( patients_request - available_beds) > 0)  order by week desc ;

                -- out of the 209 weeks 148 ocurrances had over flowing patients with no beds

                

        -- 3. Which services experience the greatest gap between patient requests and patients admitted?

                -- select week ,month, (patients_request - patients_admitted) as Patients_not_admitted , service from weekly_services order by Patients_not_admitted desc ;

            -- emergency and general_medicine       
 
        -- 4. Is bed capacity being used efficiently by service and week?
                -- select SUM( patients_request - available_beds)  as patients_without_beds, service from weekly_services where (( patients_request - available_beds) > 0) group by service order by patients_without_beds   desc;
                -- select SUM(available_beds) from weekly_services 

                -- select SUM(patients_request) as all_patients,
                -- SUM(available_beds) as all_beds,
                -- CONCAT(  (ROUND (( SUM(available_beds) / SUM(patients_request))*100 , 2) - 100 ) , ' %' ) as efficiency,
                -- service
                -- from weekly_services group by service



        -- 5. Are some services consistently under capacity while others are capacity constrained?
            -- select SUM( patients_request - available_beds)  as patients_without_beds, service from weekly_services where (( patients_request - available_beds) > 0) group by service order by patients_without_beds   desc;

            -- Emergency is always under a lot of stress

        -- 6. How many additional beds would be needed in each service to reduce refusals to an acceptable target?
                --   select SUM(patients_request) as all_patients,
                -- SUM(available_beds) as all_beds,
                -- ( SUM(patients_request) -  SUM(available_beds)) as missing_beds,
                -- ROUND((SUM(patients_request) / 100) * 80 , 0) as min_beds_required,
                -- service
                -- from weekly_services group by service

        -- 7. Are capacity problems concentrated in particular events, months, or seasons?

        -- Capacity problems are overwhelming in emergency situations with less than 20 % getting a bed

            --    select SUM(patients_request) as all_patients,
            --     SUM(available_beds) as all_beds,
            --   CONCAT ( ROUND((  SUM(available_beds) / SUM(patients_request) ) *100) , ' %' )as percentage_of_patients_on_bed,
            --     service
            --     from weekly_services group by service
        -- 8. Which service should receive the next additional beds if the hospital can expand only one service?
                    --    select SUM(patients_request) as all_patients,
            --     SUM(available_beds) as all_beds,
            --   CONCAT ( ROUND((  SUM(available_beds) / SUM(patients_request) ) *100) , ' %' )as percentage_of_patients_on_bed,
            --     service
            --     from weekly_services group by service

            -- Emergency need more beds immedietly


    -- 2. Patient refusals

        -- 9. What is the overall refusal rate, and how does it vary by service, week, month, and event?
                -- select SUM(patients_request) as all_patients, SUM(patients_refused) as all_refused,
                -- CONCAT(ROUND(( (SUM(patients_refused) /SUM(patients_request)) ) *100) , ' %' )as refusal_rate , service,week,month,event
                --  from weekly_services group by service,week,month,event order by refusal_rate desc;

        -- 10. Are refusals driven primarily by insufficient beds, unusually high demand, or staffing constraints?
                -- select patients_request,SUM(patients_refused) as all_refused,available_beds from weekly_services where patients_refused > 0 group by available_beds,patients_request  order by available_beds desc;

                --  select patients_request,SUM(patients_refused) as all_refused,available_beds from weekly_services where patients_refused > 0 and (patients_request - patients_refused) > available_beds group by available_beds,patients_request  order by available_beds desc;

                -- Refusals are almost always driven by insufficient beds , none of the refusals were given when there were available beds and the patients_request was less than the available_beds

        -- 11. Do flu, strike, donation, or no-event weeks have materially different refusal rates?
                --     select SUM(patients_request) as all_patients, SUM(patients_refused) as all_refused,
                -- CONCAT(ROUND(( (SUM(patients_refused) /SUM(patients_request)) ) *100) , ' %' )as refusal_rate , event
               --  from weekly_services group by event order by refusal_rate desc;
                -- yes customers with FLU are refused the most with 78% refusal rate followed by donation with 53% and no event with 50% and strike with 48% refusal rate
        -- 12. Which services have the largest number of refusals even when their refusal rate is not the highest?
                -- select SUM(patients_request) as all_patients, SUM(patients_refused) as all_refused,CONCAT(ROUND(( (SUM(patients_refused) /SUM(patients_request)) ) *100) , ' %' )as refusal_rate,
                --  service
                -- -- from weekly_services group by service order by refusal_rate desc;
                -- general medicine has the largest number of refusals even when their refusal rate is not the highest

        -- 13. Can high-refusal weeks be identified early enough to trigger additional staffing or capacity actions?

            -- select SUM(patients_request) as all_patients, SUM(patients_refused) as all_refused,CONCAT(ROUND(( (SUM(patients_refused) /SUM(patients_request)) ) *100) , ' %' )as refusal_rate , week
            -- from weekly_services  group by week HAVING (SUM(patients_refused) /SUM(patients_request)) > 0.65 order by week ;

            -- after every 2 consecutive weeks the refusal rate goes above 65% so after every 2 weeks of normal operation the hospital should be able to identify the high refusal weeks and take immediate action to reduce refusals

        -- 14. What operational threshold should trigger escalation for a service with rising refusals?

                --     select SUM(patients_request) as all_patients, SUM(patients_refused) as all_refused,
                -- CONCAT(ROUND(( (SUM(patients_refused) /SUM(patients_request)) ) *100) , ' %' )as refusal_rate , service
               --  from weekly_services group by service order by refusal_rate desc;

                -- If a services has refusal rate of 80% or more for 2 consecutive weeks then it should trigger escalation for that service to take immediate action to reduce refusals



    -- 3. Patient experience and outcomes

        -- 15. Which services have the highest and lowest patient satisfaction?
                -- select service, ROUND(AVG(patient_satisfaction) , 2) as avg_satisfaction from weekly_services group by service order by avg_satisfaction desc;

                -- ICU has the highest patient satisfaction with 81.62% followed by General Medicine at 81.23%, Surgery at 79.27% and emergency at 77.88%

        -- 16. Does patient satisfaction change when a service is close to or above its bed capacity?
                -- select service, ROUND(AVG(patient_satisfaction) , 2) as avg_satisfaction,available_beds from weekly_services where available_beds < 30 and patient_satisfaction > 50 group by service,available_beds order by avg_satisfaction desc;

                -- No even when the available beds are less than 30 the Average patient satisfaction is still above 50% 

        -- 17. Is patient satisfaction associated with staff morale or staff attendance?
                -- select service, ROUND(AVG(patient_satisfaction) , 2) as avg_satisfaction,staff_morale from weekly_services where staff_morale < 50 group by service,staff_morale order by avg_satisfaction,staff_morale desc;

                -- No even when the staff morale is less than 50% the Average patient satisfaction is still above 80%

        -- 18. How does satisfaction vary by patient age group and service?
            

                -- Drop table if exists patient_services;
             
                -- select * from weekly_services limit 10;
                -- Create table patient_services as select p.patient_id , p.name,p.age, (p.departure_date :: Date - p.arrival_date ::Date) as LOS ,week,month,w.service,available_beds,patient_satisfaction,staff_morale,event from weekly_services w Join patients p on w.patient_id = p.patient_id;

                -- select * from weekly_services
           

                -- select p.patient_id , p.name,p.age, (p.departure_date :: Date - p.arrival_date ::Date) as LOS ,week,month,available_beds,patient_satisfaction,staff_morale,event,w.service  from weekly_services w Join patients p on w.patient_id = p.patient_id;

                -- select * from patient_services limit 10;

                -- select service, ROUND(AVG(patient_satisfaction) , 2) as avg_satisfaction,service from patient_services group by service
               
                -- ICU and General Medicine have the highest patient satisfaction with 81.62% and 81.23% respectively

                --  select age, ROUND(AVG(patient_satisfaction), 2) as avg_satisfaction from patient_services group by age order by age desc;

                --  age does not have a significant impact on patient satisfaction as the average patient satisfaction is above 80% for all age groups
                
        -- 19. Do patients with longer stays report different satisfaction levels than patients with shorter stays?
                -- select los, ROUND(AVG(patient_satisfaction), 2) as avg_satisfaction from patient_services group by los order by los desc;

                -- not a significant impact on patient satisfaction as the average patient satisfaction is above 80% for all length of stay groups

        -- 20. Are there weeks where admissions remain high but patient satisfaction falls, indicating operational strain?
                --   select p.patient_id ,week,available_beds,patient_satisfaction, w.patients_admitted  from weekly_services w Join patients p on w.patient_id = p.patient_id where patients_admitted >10 and patient_satisfaction < 90 order by patients_admitted desc;
                
    -- 4. Length of stay and patient flow

        -- 22. What is the average and median length of stay by service?
                -- select CONCAT(ROUND(AVG(los),2) , ' Days') as Avg_los, CONCAT( PERCENTILE_CONT(0.5) WITHIN GROUP (order by los) , ' Days') as median_los , service from patient_services group by service order by service desc;

                -- the average and median length of stay is highest in ICU with 7.5 days and 7 days respectively followed by General Medicine with 6.5 days and 6 days respectively
                

        -- 23. Which services have the longest stays, and how much variation exists within each service?
                --   select MAX(los), service from patient_services group by service order by service desc;


                -- No Variations in Length of Stay within each service

        -- 24. Does length of stay vary by patient age group or month of arrival?
                -- select los,age from patient_services group by los,age order by los desc;

                -- select los,month from patient_services group by los,month order by los desc;

                -- Not a log of variation by age or by month


        -- 25. Are longer stays associated with lower bed availability or higher refusal rates in the same period?
                --  select los,SUM(available_beds) from patient_services group by los order by los desc;


                -- select p.patient_id ,p.los ,w.patients_refused from weekly_services w Join patient_services p on w.patient_id = p.patient_id order by los desc;
                
                -- select los,SUM(patient_refusal) from weekly_services group by los order by los desc;

                -- select * from patient_services limit 10;
               

        -- 26. Which services could release the most capacity through a reduction in average length of stay?
                -- select p.patient_id ,p.los ,w.patients_refused,w.service from weekly_services w Join patient_services p on w.patient_id = p.patient_id order by los desc;


                -- Emergency could release the most capacity through a reduction in average length of stay as it has the highest number of patients with the longest length of stay

        -- 27. Are there unusual or potentially invalid stays, such as departure dates before arrival dates or extremely long stays?
                -- select p.patient_id ,p.los ,w.patients_refused,w.service from weekly_services w Join patient_services p on w.patient_id = p.patient_id where los< 0 order by los desc;

               -- Nope, All stays are valid and Los stays between 0 and 14 days


        -- 28. Patient refusal patterns and root causes
                -- select * from weekly_services where patients_refused > 0 order by patients_refused desc;

                -- Patients are usually refused due to insufficient beds 

        -- 29. Staff workload and presence patterns

                -- select * from staff_schedule order by present;



    -- 5. Workforce coverage and morale

        -- 27. What drives patient satisfaction and staff morale?

                -- select * from weekly_services order by patient_satisfaction desc;

                --   select * from weekly_services order by staff_morale;


                -- not a lot of connections between patient satisfaction and staff morale and other factors so nothing drives patient satisfaction and staff moral

        -- 28. What if we increase beds in ICU by 10%?

                -- select (available_beds * 1.1) as increased_beds , patients_request , (patients_admitted * 1.1) as patients_admitted,
                -- Round(( (available_beds * 1.1) - patients_request  ) / patients_admitted , 2) as patients_without_beds,
                -- service from weekly_services where service='ICU' order by patients_without_beds desc;

                -- A fixed-demand 10% bed increase models a 19.1% reduction in ICU refusals (141 to 114), not nearly zero; see the scenario query below.



                -- select s.staff_id , t.staff_name,s.week,t.role,t.service from staff_schedule s join staff t on s.staff_id = t.staff_id;

                

        -- 29. Which weeks show simultaneous high demand and low staff morale?
                -- select * from weekly_services;
                -- select week ,patients_request from weekly_services order by patients_request desc ;

                -- select week ,staff_morale from weekly_services order by staff_morale ;



        -- 30. Does staff morale fall during high-demand or event weeks, and how quickly does it recover afterward?

                -- select week , patients_request,staff_morale from weekly_services order by patients_request desc;

                -- staff morale doesn't fall during high demand

    -- 6. Events and operational resilience

        -- 31. How do flu weeks affect demand, admissions, refusals, satisfaction, morale, and staffing attendance?

                -- select week,patients_request,patients_admitted, patients_refused,
                -- Round((patients_refused * 100) / patients_request,2) as refusal_rate,
                -- patient_satisfaction,staff_morale from weekly_services where event='flu' order by week desc;

                -- Staff morale and patient satfisfactions are high even during flu weeks , The refusal rates are very high during the flu season dur to un available beds which is a point of concern

        -- 32. Which services are most sensitive to each event type?


        -- 33. What staffing and bed-capacity plan would best protect the hospital during future high-impact events?
                -- select (available_beds * 1.1) as increased_beds , patients_request , (patients_admitted * 1.1) as patients_admitted,
                -- Round(( (available_beds * 1.1) - patients_request  ) / patients_admitted , 2) as patients_without_beds,
                -- service from weekly_services order by patients_without_beds desc;

                -- A fixed-demand 10% bed increase does not nearly eliminate refusals; see the service-level scenario query below and size event capacity from the observed demand gap.


-- Decision-Oriented Questions

    -- These questions convert the analysis into recommendations for management:

        -- 1. Service priority, total refusal rate, satisfaction, and persistent high-refusal weeks
        WITH weekly_metrics AS (
        SELECT
        week,
        service,
        patients_request,
        patients_refused,
        available_beds,
        patient_satisfaction,
        staff_morale,
        100.0 * patients_refused / NULLIF(patients_request, 0) AS refusal_rate
        FROM weekly_services
        ), previous_week AS (
        SELECT
        *,
        LAG(week) OVER (PARTITION BY service ORDER BY week) AS prior_week,
        LAG(refusal_rate) OVER (PARTITION BY service ORDER BY week) AS prior_refusal_rate
        FROM weekly_metrics
        )
        SELECT
        service,
        COUNT(*) AS weeks_observed,
        SUM(patients_request) AS total_requests,
        SUM(patients_refused) AS total_refusals,
        ROUND(100.0 * SUM(patients_refused) / NULLIF(SUM(patients_request), 0), 1) AS overall_refusal_pct,
        COUNT(*) FILTER (WHERE refusal_rate >= 65) AS weeks_at_or_above_65_pct,
        COUNT(*) FILTER (
        WHERE refusal_rate >= 65
                AND prior_refusal_rate >= 65
                AND week = prior_week + 1
        ) AS weeks_in_consecutive_65_pct_streaks,
        ROUND(AVG(patient_satisfaction), 1) AS avg_patient_satisfaction,
        ROUND(AVG(staff_morale), 1) AS avg_staff_morale
        FROM previous_week
        GROUP BY service
        ORDER BY total_refusals DESC;

        -- 2. Weekly operating triggers: demand versus beds, refusal rate, attendance, and morale
        WITH staffing AS (
        SELECT
        ss.week,
        s.service,
        COUNT(*) AS scheduled_staff,
        COUNT(*) FILTER (WHERE ss.present = 1) AS present_staff
        FROM staff_schedule AS ss
        JOIN staff AS s ON s.staff_id = ss.staff_id
        GROUP BY ss.week, s.service
        )
        SELECT
        ws.week,
        ws.service,
        COALESCE(NULLIF(NULLIF(LOWER(TRIM(ws.event)), ''), 'none'), 'no event') AS event,
        ws.patients_request,
        ws.available_beds,
        GREATEST(ws.patients_request - ws.available_beds, 0) AS request_bed_gap,
        ws.patients_refused,
        ROUND(100.0 * ws.patients_refused / NULLIF(ws.patients_request, 0), 1) AS refusal_pct,
        staffing.scheduled_staff,
        staffing.present_staff,
        ROUND(100.0 * staffing.present_staff / NULLIF(staffing.scheduled_staff, 0), 1) AS attendance_pct,
        ws.staff_morale,
        (ws.patients_request > ws.available_beds) AS demand_exceeds_beds,
        (100.0 * ws.patients_refused / NULLIF(ws.patients_request, 0) >= 65) AS refusal_trigger,
        (100.0 * staffing.present_staff / NULLIF(staffing.scheduled_staff, 0) < 50) AS low_attendance_trigger,
        (ws.staff_morale < 60) AS low_morale_trigger
        FROM weekly_services AS ws
        LEFT JOIN staffing
        ON staffing.week = ws.week
        AND staffing.service = ws.service
        ORDER BY ws.week, ws.service;

        -- 3. Event impact by service, with request-weighted refusal and attendance rates
        WITH staffing AS (
        SELECT
        ss.week,
        s.service,
        COUNT(*) AS scheduled_staff,
        COUNT(*) FILTER (WHERE ss.present = 1) AS present_staff
        FROM staff_schedule AS ss
        JOIN staff AS s ON s.staff_id = ss.staff_id
        GROUP BY ss.week, s.service
        )
        SELECT
        COALESCE(NULLIF(NULLIF(LOWER(TRIM(ws.event)), ''), 'none'), 'no event') AS event,
        ws.service,
        COUNT(*) AS service_weeks,
        SUM(ws.patients_request) AS total_requests,
        SUM(ws.patients_refused) AS total_refusals,
        ROUND(100.0 * SUM(ws.patients_refused) / NULLIF(SUM(ws.patients_request), 0), 1) AS refusal_pct,
        ROUND(100.0 * SUM(staffing.present_staff) / NULLIF(SUM(staffing.scheduled_staff), 0), 1) AS attendance_pct,
        ROUND(AVG(ws.patient_satisfaction), 1) AS avg_patient_satisfaction,
        ROUND(AVG(ws.staff_morale), 1) AS avg_staff_morale
        FROM weekly_services AS ws
        LEFT JOIN staffing
        ON staffing.week = ws.week
        AND staffing.service = ws.service
        GROUP BY 1, 2
        ORDER BY event, ws.service;

        -- 4. Fixed-demand scenario: add 10% of beds per week and estimate attendance gains to an 80% target
        WITH bed_scenario AS (
        SELECT
        service,
        patients_refused,
        FLOOR(available_beds * 0.10) AS added_beds_this_week
        FROM weekly_services
        ), bed_totals AS (
        SELECT
        service,
        SUM(patients_refused) AS baseline_refusals,
        SUM(added_beds_this_week) AS added_bed_weeks,
        SUM(GREATEST(patients_refused - added_beds_this_week, 0)) AS modeled_refusals_after_addition
        FROM bed_scenario
        GROUP BY service
        ), attendance AS (
        SELECT
        s.service,
        COUNT(*) AS scheduled_shifts,
        COUNT(*) FILTER (WHERE ss.present = 1) AS attended_shifts
        FROM staff_schedule AS ss
        JOIN staff AS s ON s.staff_id = ss.staff_id
        GROUP BY s.service
        )
        SELECT
        bed_totals.service,
        bed_totals.baseline_refusals,
        bed_totals.added_bed_weeks,
        bed_totals.modeled_refusals_after_addition,
        ROUND(
        100.0 * (bed_totals.baseline_refusals - bed_totals.modeled_refusals_after_addition)
        / NULLIF(bed_totals.baseline_refusals, 0),
        1
        ) AS modeled_refusal_reduction_pct,
        ROUND(100.0 * attendance.attended_shifts / NULLIF(attendance.scheduled_shifts, 0), 1) AS current_attendance_pct,
        ROUND(
        GREATEST(
                0,
                (0.80 - attendance.attended_shifts::numeric / NULLIF(attendance.scheduled_shifts, 0)) * 100
        ),
        1
        ) AS additional_filled_shifts_per_100_to_reach_80_pct
        FROM bed_totals
        JOIN attendance USING (service)
        ORDER BY bed_totals.baseline_refusals DESC;

        -- 5. Length of stay by service and a one-day-reduction bed-day scenario
        SELECT
        service,
        COUNT(*) AS eligible_patient_records,
        ROUND(AVG((departure_date - arrival_date)::numeric), 2) AS avg_length_of_stay_days,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY departure_date - arrival_date) AS median_length_of_stay_days,
        MAX(departure_date - arrival_date) AS max_length_of_stay_days,
        COUNT(*) AS theoretical_bed_days_freed_if_each_stay_fell_by_one_day
        FROM patients
        WHERE arrival_date IS NOT NULL
        AND departure_date IS NOT NULL
        AND departure_date > arrival_date
        GROUP BY service
        ORDER BY avg_length_of_stay_days DESC;






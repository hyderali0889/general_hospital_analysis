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

        -- 28. What is the staff attendance rate by week, service, role, and individual?


        -- 29. Which services and roles have the largest staffing gaps or the most variable coverage?


        -- 30. Is lower staff presence associated with lower patient satisfaction, lower morale, or higher refusal rates?


        -- 31. Does the relationship between staffing and outcomes differ between doctors, nurses, and nursing assistants?


        -- 32. Which weeks show simultaneous high demand, low attendance, and low staff morale?


        -- 33. What minimum staffing level appears necessary to support demand without a deterioration in satisfaction or refusals?


        -- 34. Are particular services dependent on a small number of staff members, creating operational risk when they are absent?


        -- 35. Does staff morale fall during high-demand or event weeks, and how quickly does it recover afterward?



    -- 6. Events and operational resilience

        -- 36. How do flu weeks affect demand, admissions, refusals, satisfaction, morale, and staffing attendance?


        -- 37. Do strike weeks show evidence of reduced attendance, increased refusals, or lower satisfaction?


        -- 38. Do donation weeks produce measurable changes in capacity, demand, staffing, or patient outcomes?


        -- 39. Which services are most sensitive to each event type?


        -- 40. What staffing and bed-capacity plan would best protect the hospital during future high-impact events?



-- Decision-Oriented Questions

    -- These questions convert the analysis into recommendations for management:

        -- 1. Where should the hospital add beds first?


        -- 2. When should temporary staff or overtime be scheduled?


        -- 3. Which service needs a permanent staffing adjustment rather than short-term intervention?


        -- 4. What refusal-rate, attendance, or morale threshold should activate an operational response?


        -- 5. Which actions are likely to improve patient satisfaction without reducing access?


        -- 6. How should the hospital prepare for a repeat flu season or strike?


        -- 7. What are the expected benefits of adding beds, improving attendance, or reducing length of stay?






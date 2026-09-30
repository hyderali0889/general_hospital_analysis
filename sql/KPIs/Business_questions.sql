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


        -- 10. Are refusals driven primarily by insufficient beds, unusually high demand, or staffing constraints?


        -- 11. Do flu, strike, donation, or no-event weeks have materially different refusal rates?


        -- 12. Which services have the largest number of refusals even when their refusal rate is not the highest?


        -- 13. Can high-refusal weeks be identified early enough to trigger additional staffing or capacity actions?


        -- 14. What operational threshold should trigger escalation for a service with rising refusals?



    -- 3. Patient experience and outcomes

        -- 15. Which services have the highest and lowest patient satisfaction?


        -- 16. Does patient satisfaction change when a service is close to or above its bed capacity?


        -- 17. Is patient satisfaction associated with staff morale or staff attendance?


        -- 18. How does satisfaction vary by patient age group and service?


        -- 19. Do patients with longer stays report different satisfaction levels than patients with shorter stays?


        -- 20. Are there weeks where admissions remain high but patient satisfaction falls, indicating operational strain?


        -- 21. Which service and patient segments should be prioritized for satisfaction improvement?



    -- 4. Length of stay and patient flow

        -- 22. What is the average and median length of stay by service?


        -- 23. Which services have the longest stays, and how much variation exists within each service?


        -- 24. Does length of stay vary by patient age group or month of arrival?


        -- 25. Are longer stays associated with lower bed availability or higher refusal rates in the same period?


        -- 26. Which services could release the most capacity through a reduction in average length of stay?


        -- 27. Are there unusual or potentially invalid stays, such as departure dates before arrival dates or extremely long stays?



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






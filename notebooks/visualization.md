## Suggested Python Visualizations

Use `pandas` to prepare the measures, `seaborn` for statistical plots, and `matplotlib` for labels, layout, and annotations. These plots are prioritized to answer the capacity, refusal, patient-experience, and workforce questions above.

| Priority | Visualization | Suggested design | Data and measures |
|---|---|---|---|
| 1 | Demand versus capacity over time | Line plot of weekly requests and available beds, faceted by service; optionally overlay admissions | `services_weekly.csv`: `week`, `service`, `patients_request`, `available_beds`, `patients_admitted`. Shows when and where demand exceeds capacity. |
| 2 | Refusal rate by service | Sorted horizontal bar chart; show refusal count as labels or in a companion plot | `services_weekly.csv`: aggregate `patients_refused / patients_request` by service. Include refusal counts so a small service with a high rate is not confused with the largest operational burden. |
| 3 | Service pressure heatmap | Heatmap with service as rows and week (or month) as columns; color by refusal rate or demand-to-capacity ratio | `services_weekly.csv`: `patients_refused / patients_request` or `patients_request / available_beds`. Good for spotting persistent and seasonal pressure. |
| 4 | Event impact comparison | Box plot (or point plot with confidence intervals) of refusal rate by event; repeat for attendance or satisfaction | `services_weekly.csv` and `staff_schedule.csv`. Normalize missing event values to `no event` before grouping. Compare distributions, not just totals. |
| 5 | Capacity use versus patient satisfaction | Scatter plot with a regression trend; color by service and size points by requests | `services_weekly.csv`: utilization `patients_admitted / available_beds` against `patient_satisfaction`. Treat association as descriptive, not causal. |
| 6 | Length of stay by service | Box plot or violin plot, ordered by median stay; optionally facet by age group | `patients.csv`: derive stay days from `departure_date - arrival_date`; group by `service` and an explicitly defined age band. Check negative or implausibly long stays first. |
| 7 | Attendance by service, role, and week | Heatmap of attendance rate by week, faceted by role or service | `staff_schedule.csv`: average `present` by `week`, `service`, and `role`. A value of 1 represents present, so the mean is the attendance rate. |
| 8 | Satisfaction by service and patient group | Point plot of mean satisfaction with confidence intervals, grouped by service and age band | `patients.csv`: `satisfaction`, `service`, and `age`. Patient-level scores complement the weekly service-level satisfaction measure. |


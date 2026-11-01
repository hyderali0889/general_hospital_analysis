# Hospital Operations Analysis
## Full Report

**Prepared:** November 1, 2026 | **Audience:** Hospital operations leadership | **Source:** Synthetic project data in `data/`; analysis is descriptive and intended for planning discussion, not clinical staffing decisions.

## Executive Summary

Access pressure is concentrated in emergency and general medicine. Across 208 service-weeks, 13,493 patient requests resulted in 5,851 recorded admissions and 7,642 refusals, a request-weighted refusal rate of 56.6%. Emergency alone accounts for 5,008 refusals (80.9% of its requests) and had requests above available beds in all 52 observed weeks. General medicine is second by refusal volume, with 1,938 refusals (45.4%) and a bed-demand gap in 43 weeks.

The recommended sequence is to validate emergency staffed capacity and patient flow, then address general-medicine capacity, while improving attendance across all services. Flu-labeled service-weeks are the clearest surge signal: 78.2% pooled refusal and 51.2% attendance. A simple 10% bed-addition scenario is not enough for emergency. Staffing and capacity scenarios below are illustrative because the data do not include acuity, shift-level coverage, or validated safe-staffing ratios.

For a concise leadership version, see [Executive Summary](executive_summary.md).

## 1. Scope and Data

| Source | Records | Analysis grain |
|---|---:|---|
| `services_weekly.csv` | 208 | 52 weeks across four services |
| `patients.csv` | 1,000 | One synthetic patient record per row |
| `staff.csv` | 126 | Staff member and assigned service/role |
| `staff_schedule.csv` | 6,552 | Staff member-week attendance records |

### Method

- Refusal rate is total refusals divided by total requests, not the unweighted average of weekly percentages.
- Demand pressure is counted when a service-week's requests exceed `available_beds`.
- Attendance is present schedule records divided by all schedule records, summarized by matching week and service.
- Missing and blank event labels are grouped as **No event** for event comparisons. Confirm this interpretation with the data owner before using it operationally.
- The 10% bed scenario adds `floor(available_beds * 0.10)` to each service-week and subtracts that many beds from refusals, capped at zero. It assumes every added bed is immediately staffed and usable, demand is fixed, and the recorded bed shortfall translates directly to refusals.
- Length of stay (LOS) is departure date minus arrival date. All 1,000 patient records have valid positive stays from 1 to 14 days.

## 2. Capacity and Access

| Service | Requests | Admissions | Refusals | Refusal rate | Mean available beds/week | Weeks requests > beds | Mean weekly satisfaction |
|---|---:|---:|---:|---:|---:|---:|---:|
| Emergency | 6,193 | 1,185 | 5,008 | 80.9% | 22.8 | 52/52 | 77.9/100 |
| General medicine | 4,270 | 2,332 | 1,938 | 45.4% | 46.2 | 43/52 | 81.2/100 |
| Surgery | 2,241 | 1,686 | 555 | 24.8% | 37.5 | 29/52 | 79.3/100 |
| ICU | 789 | 648 | 141 | 17.9% | 14.8 | 24/52 | 81.6/100 |
| **All services** | **13,493** | **5,851** | **7,642** | **56.6%** | **30.3** | **148/208** | **80.0/100** |

### Interpretation

- **Emergency is the first capacity priority** by both refusal count and rate. Its mean weekly request volume was 119.1 against 22.8 mean available beds. The data indicate a large mismatch; they do not establish how many additional beds are feasible or whether every request represents an appropriate admission.
- **General medicine is the second priority**: 82.1 requests per week against 46.2 mean available beds and the second-largest refusal count.
- **Surgery and ICU still show recurring demand above recorded beds**, but their refusal rates are materially lower. Use event and week-level peaks to size any additional capacity rather than allocating beds from the annual total alone.

### Illustrative 10% bed scenario

| Service | Added bed-weeks | Current refusals | Modeled refusals | Modeled refusal reduction |
|---|---:|---:|---:|---:|
| Emergency | 95 | 5,008 | 4,913 | 1.9% |
| General medicine | 217 | 1,938 | 1,766 | 8.9% |
| Surgery | 173 | 555 | 479 | 13.7% |
| ICU | 57 | 141 | 114 | 19.1% |

This mechanical scenario suggests that a uniform 10% increase has limited effect where the gap is largest. It is not a forecast: it excludes changes in demand, length of stay, staff availability, transfers, and actual bed utilization. In particular, it does not support a claim that 10% more beds would nearly eliminate refusals.

## 3. Workforce Coverage

The scheduled roster totals 126 people per week across services. Overall attendance was 60.0%; service rates were tightly grouped between 59.0% and 60.4%. This common shortfall makes attendance, schedule reliability, and absence reasons a system-wide review area. It does not by itself prove that increasing headcount will reduce refusals.

| Service | Current roster/week | Average present/week | Attendance | Present/week at 80% fill | Role roster: doctors / nurses / assistants |
|---|---:|---:|---:|---:|---:|
| Emergency | 39 | 23.6 | 60.4% | 31.2 | 8 / 22 / 9 |
| General medicine | 28 | 16.5 | 59.0% | 22.4 | 5 / 16 / 7 |
| ICU | 34 | 20.4 | 60.1% | 27.2 | 6 / 19 / 9 |
| Surgery | 25 | 15.1 | 60.2% | 20.0 | 3 / 16 / 6 |

### Staffing recommendation

Treat the current scheduled roster as a **baseline to validate**, not a proven optimal level. First determine whether scheduled staff are absent, assigned elsewhere, or unavailable for particular shifts. An 80% attendance scenario would yield about 7.6 more present staff per week in emergency, 5.9 in general medicine, 6.8 in ICU, and 4.9 in surgery compared with observed averages. This is a fill-rate planning target only; it is not a patient-to-staff ratio or a safe-staffing standard.

Emergency warrants a permanent coverage review because its refusal rate was at least 65% in 46 of 52 weeks, while demand exceeded beds in all 52. Review physician, nursing, and assistant coverage by shift alongside staffed beds and patient flow before deciding whether permanent headcount, schedule redesign, or capacity changes are the appropriate remedy. General medicine is the next service for the same review.

## 4. Events and Surge Readiness

| Event group | Service-weeks | Requests | Refusals | Refusal rate | Attendance | Satisfaction | Morale |
|---|---:|---:|---:|---:|---:|---:|---:|
| No event | 164 | 9,217 | 4,654 | 50.5% | 61.5% | 79.7 | 73.1 |
| Flu | 19 | 3,064 | 2,397 | 78.2% | 51.2% | 78.7 | 72.9 |
| Strike | 11 | 446 | 183 | 41.0% | 55.8% | 82.8 | 53.7 |
| Donation | 14 | 766 | 408 | 53.3% | 56.2% | 82.7 | 80.1 |

Flu pressure is concentrated in emergency (89.3% refusals, 36.4% attendance) and general medicine (74.3% refusals, 57.7% attendance). Surgery's flu-labeled service-weeks also had a 67.8% refusal rate and 30.7% attendance. These small event subsets should be treated as warning signals, not stable causal estimates.

Strike results are mixed across the 11 service-weeks. Emergency recorded 69.1% refusals and 50.5 morale; general medicine recorded 9.7% refusals but only 28.6% attendance; surgery recorded no refusals in four service-weeks. ICU has no strike-labeled rows. Do not infer a single hospital-wide strike response from these small and uneven samples.

### Event-response plan

1. Before expected flu demand, confirm staffed-bed capacity, activate a cross-trained float/on-call roster, and prepare transfer and escalation pathways.
2. For strike risk, pre-identify essential coverage by role and service, verify mutual-aid arrangements, and monitor actual attendance by shift.
3. Trigger surge actions from forecast demand versus staffed beds and role-specific coverage, not from event labels alone.
4. Review event-week refusal, attendance, morale, and satisfaction after each activation and revise the playbook.

## 5. Patient Experience and Flow

Weekly service-level satisfaction averaged 80.0/100. ICU was highest at 81.6; general medicine averaged 81.2; surgery 79.3; emergency was lowest at 77.9. The difference is descriptive. These records do not show that adding beds, increasing attendance, or changing length of stay will cause satisfaction to improve.

| Service | Patient records | Mean LOS | Median LOS | Maximum LOS | Patient-level satisfaction average |
|---|---:|---:|---:|---:|---:|
| Surgery | 254 | 7.9 days | 8 days | 14 days | 80.3 |
| ICU | 241 | 7.6 days | 8 days | 14 days | 79.9 |
| Emergency | 263 | 7.2 days | 7 days | 14 days | 79.5 |
| General medicine | 242 | 7.0 days | 7 days | 14 days | 78.6 |

The patient-level satisfaction measure above is distinct from the weekly service-level score; do not combine their averages. A one-day reduction across all 1,000 recorded stays would represent 1,000 theoretical bed-days, but this is an upper-bound illustration, not a discharge target. Any LOS initiative should use clinically appropriate discharge planning and monitor readmissions, complications, access, and satisfaction.

### Patient-experience actions

- Pair any access intervention with satisfaction and refusal-rate guardrails.
- Test discharge coordination, handoff reliability, and communication improvements without setting premature-discharge targets.
- Provide predictable schedules, absence support, and staff debriefs after surge or strike periods; measure morale before and after rather than assuming a causal effect.
- Review emergency experience first because it has the lowest weekly satisfaction score and the highest access pressure.

## 6. Recommended Operating Plan

| Priority | Action | Initial measure of success |
|---|---|---|
| 1 | Validate emergency staffed-bed constraints, boarding, transfer delays, and role-by-shift coverage | Weekly requests above staffed beds; refusals and refusal rate |
| 2 | Run the same capacity and coverage review in general medicine | Refusals, demand-to-bed gap, service-week attendance |
| 3 | Pilot attendance recovery toward 80% of scheduled coverage; keep it explicitly provisional | Attendance by service, role, and shift; fill rate; overtime |
| 4 | Stage flu and strike playbooks with float coverage and transfer escalation | Time to activate; staffed-bed availability; event-week refusals |
| 5 | Pilot safe patient-flow and staff-support improvements | LOS, satisfaction, refusals, morale, and balancing safety outcomes |

### Proposed pilot escalation thresholds

- Refusal rate at or above 65% for two consecutive weeks: service-level escalation and capacity/coverage review.
- Attendance below 50% in a service-week: same-week coverage and absence review.
- Morale below 60/100: same-week manager check-in and workload review.
- Forecast demand above staffed-bed capacity: activate the surge plan.

These are analytical pilot thresholds, not externally validated clinical standards. Calibrate them against local policy and evaluate alert volume and outcomes before operational adoption.

## 7. Measurement and Limitations

### Core dashboard measures

- Request-weighted refusal rate: `sum(patients_refused) / sum(patients_request)`.
- Weekly demand gap: `max(patients_request - available_beds, 0)`.
- Attendance: present schedule records divided by scheduled records, by service, role, and week.
- Service-level satisfaction and morale, reported separately from patient-level satisfaction.
- LOS by service, with balancing measures for readmissions, complications, and patient experience when available.
- Event readiness: compare event service-weeks with no-event service-weeks while reporting sample counts.

### Limitations

- The dataset is synthetic, observational, and not a substitute for clinical or workforce policy.
- Weekly service data and patient-level records are at different grains: 5,851 summed admissions in the weekly table cannot be reconciled directly to 1,000 patient rows without a validated model and key relationship.
- `available_beds` does not provide occupancy by day, staffed/closed beds, or bed-days. A weekly request count compared with a bed count is a screening indicator, not a full capacity-utilization model.
- Attendance has no shift, absence reason, hours, overtime, acuity, or skill-mix requirement. The roster references above cannot establish optimal FTEs or safe staffing.
- Event categories are sparse and uneven by service. The 164 missing event labels were grouped as no event; verify that null means no event.
- Scenario calculations hold demand fixed and are not causal forecasts. Local operational pilots should record interventions and balancing outcomes.

## Appendix: Data and Formula Notes

- The weekly table contains 52 week indices for each of four services (208 service-weeks total).
- The roster includes 126 staff assignments, repeated for each of 52 weeks (6,552 schedule records).
- A 10% bed scenario adds `floor(available_beds × 0.10)` per service-week, then subtracts the added beds from the observed refusals, bounded at zero.
- Present staff at 80% attendance is `scheduled staff per week × 0.80`; it describes a roster fill-rate scenario, not a recommended staffing ratio.
- One illustrative bed-day per eligible patient record assumes each stay is safely shortened by one day; the data do not establish that this is feasible.
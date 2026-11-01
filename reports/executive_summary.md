# Hospital Operations Analytics
## Executive Summary

**Prepared:** November 1, 2026 | **Purpose:** Prioritize bed capacity, workforce coverage, and event readiness using the synthetic hospital operations dataset.

### The decision

Prioritize emergency, followed by general medicine. Emergency refusal was 80.9% (5,008/6,193), with demand above recorded beds in all 52 weeks. General medicine refusal was 45.4% (1,938/4,270), with demand above beds in 43 weeks. Across 208 service-weeks: 13,493 requests, 5,851 admissions, 7,642 refusals (56.6%), mean satisfaction 80.0/100, and morale 72.6/100.

### Service priorities

| Service | Requests | Refused | Refusal rate | Weeks demand > beds | Mean satisfaction |
|---|---:|---:|---:|---:|---:|
| Emergency | 6,193 | 5,008 | 80.9% | 52/52 | 77.9 |
| General medicine | 4,270 | 1,938 | 45.4% | 43/52 | 81.2 |
| Surgery | 2,241 | 555 | 24.8% | 29/52 | 79.3 |
| ICU | 789 | 141 | 17.9% | 24/52 | 81.6 |

### Workforce planning reference

Attendance averaged 60.0%. The 80% fill column is a planning scenario, not an optimal or safe-staffing standard.

| Service | Scheduled staff/week | Present on average | Present at 80% fill |
|---|---:|---:|---:|
| Emergency | 39 | 23.6 | 31.2 |
| General medicine | 28 | 16.5 | 22.4 |
| ICU | 34 | 20.4 | 27.2 |
| Surgery | 25 | 15.1 | 20.0 |

### Actions

1. **Capacity:** Validate emergency staffed beds and patient flow first; assess general medicine next. A fixed-demand 10% bed increase models only 1.9% fewer emergency refusals and 8.9% fewer in general medicine.
2. **Workforce:** Improve attendance and use a cross-trained float pool against forecast demand. Review role/shift coverage before changing permanent headcount.
3. **Peak events:** Pre-stage surge capacity and call-in/transfer plans. Flu service-weeks had 78.2% refusals and 51.2% attendance; emergency and general-medicine refusal rates were 89.3% and 74.3%.
4. **Escalation:** Pilot review triggers of refusal >=65% for two consecutive weeks, attendance <50%, or morale <60; validate against local safety standards.
5. **Experience:** Test safe discharge coordination and staff support; track satisfaction and refusals together to protect access.

**Limitation:** Synthetic observational data; shift acuity, safe staffing standards, and causal intervention effects are unavailable. Scenarios are illustrative. See the [full analysis report](full_analysis_report.md) for methods and caveats.
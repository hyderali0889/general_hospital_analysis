**14-Day Roadmap**  
**Project**: Hospital Beds Management  

### Tech Stack 
- **Database**: PostgreSQL
- **Analysis**: Python (pandas, seaborn, plotly) + SQL
- **BI Tools**: Power BI (main dashboard) 
- **Optional Advanced**: Kafka (simulate real-time admissions), Docker, GitHub, Streamlit
- **Documentation**: Notion / Markdown + GitHub README + PDF executive report

---

### Day 1–2: Project Setup + Data Understanding
**Goal**: Initial Data Collection.

- Download and explore all 4 CSVs.          Done
- Create a clear data dictionary and ERD (Entity Relationship Diagram).     Done
- Load data into PostgreSQL (create staging schema).      Done
- Document business context:  
  “A medium-sized hospital wants to optimize bed utilization, reduce patient refusals, improve staff morale, and increase patient satisfaction.”

**Deliverables**:
- Project GitHub repository structure
- Data dictionary + ERD
- Business questions list (e.g. Which service has highest refusal rate? How does staffing affect satisfaction? Impact of events like flu?)

### Day 3–4: Data Cleaning + Modeling
**Goal**: Build a clean analytical data model.

- Clean missing values, date formats, inconsistencies.      Done
- Create a proper star schema:                              Done
  - Fact tables: admissions, weekly performance, staff presence      Done   
  - Dimensions: staff, patients, services, weekly_schedule    Done
  - Answer Business Questions (part 1 & 2)    DOne


**Deliverables**:
- Cleaned tables in PostgreSQL      Done
- SQL scripts for transformations   Done
- Data quality report               Done 

### Day 5–7: Deep Exploratory Analysis (Core Insights)
Focus on high-value hospital operations questions:

- Bed utilization and capacity stress by service (ICU, General, etc.)           Done 
- Patient refusal patterns and root causes    Inside Business Questions ( Q-28 , part-4)
- Impact of special events (flu season, etc.)     Done
- Length of Stay analysis by service and age group      Done
- Staff workload and presence patterns        Inside Business Questions ( Q-29 , part-4)
- Answer Business Questions (part 3 & 4)       Done


Using both SQL and Python. Created publication-quality visualizations.      Visualization using Power BI and Metabase

**Deliverables**:
- Comprehensive EDA notebook                    Done
- Key findings document with charts             Done

### Day 8–9: Advanced Analysis & Modeling
Make the project stand out:

- Time series analysis of admissions and utilization    Done
- Correlation / regression: What drives patient satisfaction and staff morale?      Done Buisness question no 27
- Optional: Clustering of services or staff performance
- Scenario analysis (“What if we increase beds in ICU by 10%?”)           Done Buisness question no 28
- Answer Business Questions (part 5 & 6)      Done


### Day 10–11: Professional Dashboards (Most Important for Portfolio)

1. **Power BI Dashboard** (primary)  
   - Executive overview (KPIs)                  Done
   - Bed utilization & refusal deep-dive        Done
   - Patient satisfaction & morale              Done
   - Filters by service, week, event            Done
   - Answer Business Questions (Decision-Oriented Questions)   Done
  

Make the dashboards clean, interactive, and decision-oriented.

**Deliverables**:
- Power BI .pbix file + published link (if possible)  Done in the report
- Metabase dashboard screenshots or live link         Done in the website
- High-quality static visualizations for the report   Done in the report

### Day 12: Real-World Tools
- Simulate real-time data flow with **Kafka**    Done
- build a simple app for interactive exploration    Done
- Containerize the project with Docker      Done


### Day 13: Storytelling & Final Report
Create a professional portfolio package:

1. **Executive Summary** (1 page) – Key insights + recommendations    [Done](reports/executive_summary.md)
2. **Full Analysis Report** (PDF or Notion)    [Done](reports/full_analysis_report.md)
3. **GitHub Repository** with:
   - Clean code
   - SQL scripts
   - Dashboard files
   - Clear README (problem → approach → insights → recommendations)       Done

#### Recommendations to include:
- Optimal staffing levels by service
- Bed capacity adjustments
- Actions to reduce refusals during peak events
- Ways to improve staff morale and patient satisfaction

### Day 14: Polish, Review & Publish
- End-to-end testing of all code            Done
- Peer review / self-critique               Done
- Publish everything on GitHub             Done

---

### Final Deliverables Checklist
- Clean multi-table PostgreSQL data model           Done 
- Power BI interactive dashboard (main visual asset)          Done
- Professional PDF report with strong recommendations         Done  
- Well-documented GitHub repository                 Done
- Kafka simulation and Streamlit app                Done

### This project combines:
- Multi-table healthcare operations data
- Strong visual storytelling (Power BI)
- Professional tools (PostgreSQL +  Kafka)
- Clear business impact


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

- Download and explore all 4 CSVs.
- Create a clear data dictionary and ERD (Entity Relationship Diagram).
- Load data into PostgreSQL (create staging schema).
- Document business context:  
  “A medium-sized hospital wants to optimize bed utilization, reduce patient refusals, improve staff morale, and increase patient satisfaction.”

**Deliverables**:
- Project GitHub repository structure
- Data dictionary + ERD
- Business questions list (e.g. Which service has highest refusal rate? How does staffing affect satisfaction? Impact of events like flu?)

### Day 3–4: Data Cleaning + Modeling
**Goal**: Build a clean analytical data model.

- Clean missing values, date formats, inconsistencies.
- Create a proper star schema:
  - Fact tables: admissions, weekly performance, staff presence
  - Dimensions: staff, patients, services, date, events
- Calculate key metrics early:
  - Bed utilization rate
  - Refusal rate
  - Average Length of Stay (LOS)
  - Staffing levels vs demand
  - Satisfaction & morale trends

**Deliverables**:
- Cleaned tables in PostgreSQL
- SQL scripts for transformations
- Data quality report

### Day 5–7: Deep Exploratory Analysis (Core Insights)
Focus on high-value hospital operations questions:

- Bed utilization and capacity stress by service (ICU, General, etc.)
- Patient refusal patterns and root causes
- Relationship between staffing levels, morale, and patient satisfaction
- Impact of special events (flu season, etc.)
- Length of Stay analysis by service and age group
- Staff workload and presence patterns

Use both SQL and Python. Create publication-quality visualizations (Plotly preferred for interactivity).

**Deliverables**:
- Comprehensive EDA notebook
- Key findings document with charts

### Day 8–9: Advanced Analysis & Modeling
Make the project stand out:

- Time series analysis of admissions and utilization
- Correlation / regression: What drives patient satisfaction and staff morale?
- Simple predictive model (e.g. predict high refusal risk weeks or staffing needs)
- Optional: Clustering of services or staff performance
- Scenario analysis (“What if we increase beds in ICU by 10%?”)

### Day 10–11: Professional Dashboards (Most Important for Portfolio)
Build **two dashboards**:

1. **Power BI Dashboard** (primary)  
   - Executive overview (KPIs)
   - Bed utilization & refusal deep-dive
   - Staffing vs demand
   - Patient satisfaction & morale
   - Filters by service, week, event

Make the dashboards clean, interactive, and decision-oriented.

**Deliverables**:
- Power BI .pbix file + published link (if possible)
- Metabase dashboard screenshots or live link
- High-quality static visualizations for the report

### Day 12: Real-World Tools
- Simulate real-time data flow with **Kafka** (produce admission events and consume them into a dashboard)
- build a simple **Streamlit** app for interactive exploration
- Containerize the project with Docker (shows DevOps awareness)     Done

Even basic implementation of one of these is impressive.

### Day 13: Storytelling & Final Report
Create a professional portfolio package:

1. **Executive Summary** (1 page) – Key insights + recommendations
2. **Full Analysis Report** (PDF or Notion)
3. **GitHub Repository** with:
   - Clean code
   - SQL scripts
   - Dashboard files
   - Clear README (problem → approach → insights → recommendations)
4. **LinkedIn/Portfolio post** version (short story + screenshots)

#### Recommendations to include:
- Optimal staffing levels by service
- Bed capacity adjustments
- Actions to reduce refusals during peak events
- Ways to improve staff morale and patient satisfaction

### Day 14: Polish, Review & Publish
- End-to-end testing of all code
- Peer review / self-critique
- Record a 5–7 minute video walkthrough
- Publish everything on GitHub + LinkedIn + personal portfolio site

---

### Final Deliverables Checklist
- Clean multi-table PostgreSQL data model
- Power BI interactive dashboard (main visual asset)
- Professional PDF report with strong recommendations
- Well-documented GitHub repository
- Kafka simulation and Streamlit app
- Video presentation

### This project combines:
- Multi-table healthcare operations data
- Strong visual storytelling (Power BI)
- Professional tools (PostgreSQL +  Kafka)
- Clear business impact


# 🏥 Hospital Beds Management – Data Analytics Portfolio Project

**A professional end-to-end healthcare analytics project** focused on optimizing bed utilization, reducing patient refusals, improving staff morale, and increasing patient satisfaction.

**Duration**: 14 Days  
**Level**: Intermediate → Advanced  

---

## 📌 Project Overview

This project simulates a real-world hospital operations analytics request for a medium-sized hospital. The goal is to provide actionable insights that help hospital management:

- Optimize bed utilization across services
- Reduce patient refusal rates
- Improve staff morale and patient satisfaction
- Better prepare for peak periods (e.g. flu season)

The project follows a full professional analytics workflow — from raw multi-table data to clean data modeling, deep analysis, interactive dashboards, and clear business recommendations.

---

## 🗂️ Dataset

The dataset contains **4 related tables**:

| Table                  | Description                              |
|------------------------|------------------------------------------|
| `hospital_staff.csv`   | Staff information (role, service)        |
| `hospital_patients.csv`| Patient records (arrival, departure, satisfaction) |
| `hospital_service_weekly.csv` | Weekly service-level metrics (beds, admissions, refusals, morale) |
| `hospital_staff_schedule.csv` | Weekly staff presence schedule      |

---

## 🛠️ Tech Stack

| Category          | Tools                                      |
|-------------------|--------------------------------------------|
| **Database**      | PostgreSQL                                 |
| **Analysis**      | Python (pandas, seaborn, plotly), SQL      |
| **BI / Dashboard**| Power BI (primary) 
| **Advanced**      | Kafka + Debezium (CDC), Docker, Streamlit  |
| **Version Control**| Git + GitHub                              |
| **Documentation** | Markdown, PDF Executive Report             |

---

## 📅 14-Day Project Roadmap

| Days     | Focus                              | Key Deliverables                              |
|----------|------------------------------------|-----------------------------------------------|
| 1–2      | Project Setup & Data Understanding | Data Dictionary, ERD, Business Questions      |
| 3–4      | Data Cleaning & Modeling           | Clean star schema, SQL transformation scripts |
| 5–7      | Deep Exploratory Analysis          | EDA Notebook + Key Insights                   |
| 8–9      | Advanced Analysis & Modeling       | Time series, correlation, predictive insights |
| 10–11    | Professional Dashboards            | Power BI              |
| 12       | Real-World Tools                   | Kafka simulation / Streamlit app              |
| 13       | Storytelling & Reporting           | Executive Summary + Full Report               |
| 14       | Polish & Publish                   | Final GitHub repo + Video walkthrough         |

---

## 📊 Key Business Questions

- Which service has the highest patient refusal rate?
- How does staffing level affect patient satisfaction and staff morale?
- What is the impact of special events (e.g. flu) on bed utilization?
- Which services are under the highest capacity stress?
- What is the average Length of Stay (LOS) by service and age group?
- Can we predict high-refusal risk weeks?

---

## 📈 Key Metrics Tracked

- Bed Utilization Rate
- Patient Refusal Rate
- Average Length of Stay (LOS)
- Staff Presence vs Demand
- Patient Satisfaction Score
- Staff Morale Score

---

## 📁 Project Structure


- hospital-beds-management/
- ├── data/                       # Raw CSV files
- ├── sql/                        # SQL scripts (staging, cleaning, modeling)
- ├── notebooks/                  # Python EDA & analysis notebooks
- ├── dashboards/
  - ├── powerbi/                    # Power BI .pbix file
- ├── project_apps/               # docker-compose.yml + related files
- ├── streamlit/                  # Optional Streamlit app
- ├── reports/                    # Executive summary + full PDF report
- ├── docs/                       # Data dictionary, ERD, business questions
- └── README.md

---

## 🚀 How to Run the Project

### 1. Clone the repository

- git clone 
- cd hospital-beds-management


### 2. Start the infrastructure (PostgreSQL + Kafka + Debezium)

docker compose up -d

### 3. Load the data
Run the SQL scripts in the `sql/` folder to create staging tables and the analytical model.

### 4. Explore the analysis
Open the notebooks in the `notebooks/` folder.

### 5. View Dashboards
- Open the Power BI `.pbix` file

---

## 🎯 Final Deliverables

- [x] Clean multi-table PostgreSQL data model (Star Schema)
- [x] Power BI Interactive Dashboard
- [x] Professional PDF Report with recommendations
- [x] Well-documented GitHub repository
- [x] Kafka real-time simulation
- [x] Streamlit interactive app
- [x] 5–7 minute video walkthrough

---

## 💡 Key Recommendations 

- Adjust bed capacity in high-stress services (especially ICU during peak events)
- Optimize staffing levels based on demand patterns
- Implement targeted actions to reduce patient refusals during flu season
- Monitor and improve staff morale as it correlates strongly with patient satisfaction

---

## 👤 Author

**Hayder Ali**  
Data Analyst | Healthcare Analytics Enthusiast  


---

## 📄 License

This project is for educational and portfolio purposes.  
Dataset is synthetic and licensed under CC0: Public Domain.
```

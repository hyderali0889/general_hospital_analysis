from pathlib import Path

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st


ROOT_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT_DIR / "data"
CHART_COLORS = ["#087f5b", "#e76f51", "#3973ac", "#d6a532", "#7656a5"]

st.set_page_config(
    page_title="Hospital Operations Explorer",
    page_icon="H",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.markdown(
    """
    <style>
    @import url('https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=Manrope:wght@400;500;600;700;800&display=swap');
    :root {
        --ink: #17231f;
        --muted: #64716c;
        --paper: #f5f7f5;
        --line: #dce4df;
        --green: #087f5b;
        --coral: #e76f51;
    }
    html, body, [class*="css"] {
        font-family: 'Manrope', 'Segoe UI', sans-serif;
        color: var(--ink);
    }
    .stApp { background: var(--paper); }
    [data-testid="stSidebar"] {
        background: #eaf0ec;
        border-right: 1px solid var(--line);
    }
    [data-testid="stMetric"] {
        background: #ffffff;
        border: 1px solid var(--line);
        border-top: 3px solid var(--green);
        padding: 14px 16px;
        min-height: 112px;
    }
    [data-testid="stMetricLabel"] { color: var(--muted); font-size: 0.82rem; }
    [data-testid="stMetricValue"] { color: var(--ink); font-weight: 800; }
    h1, h2, h3 { letter-spacing: 0; color: var(--ink); }
    h1 { font-family: Georgia, serif; font-weight: 500; }
    .eyebrow {
        color: var(--green);
        font-family: 'DM Mono', monospace;
        font-size: 0.73rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        margin-bottom: 0.2rem;
    }
    .subtle { color: var(--muted); font-size: 0.9rem; }
    .stTabs [data-baseweb="tab-list"] { gap: 1.4rem; }
    .stTabs [data-baseweb="tab"] { height: 3rem; }
    div[data-testid="stDataFrame"] { border: 1px solid var(--line); }
    </style>
    """,
    unsafe_allow_html=True,
)


@st.cache_data
def load_data() -> tuple[pd.DataFrame, pd.DataFrame]:
    weekly = pd.read_csv(DATA_DIR / "services_weekly.csv")
    schedule = pd.read_csv(DATA_DIR / "staff_schedule.csv")
    patients = pd.read_csv(DATA_DIR / "patients.csv")

    for column in [
        "week",
        "month",
        "available_beds",
        "patients_request",
        "patients_admitted",
        "patients_refused",
        "patient_satisfaction",
        "staff_morale",
    ]:
        weekly[column] = pd.to_numeric(weekly[column], errors="coerce")

    weekly["event"] = (
        weekly["event"]
        .fillna("")
        .astype(str)
        .str.strip()
        .str.lower()
        .replace({"": "no event", "none": "no event"})
        .str.title()
    )

    schedule["present"] = pd.to_numeric(schedule["present"], errors="coerce").fillna(0)
    attendance = (
        schedule.groupby(["week", "service"], as_index=False)
        .agg(scheduled_staff=("present", "size"), present_staff=("present", "sum"))
    )
    weekly = weekly.merge(attendance, on=["week", "service"], how="left")
    weekly[["scheduled_staff", "present_staff"]] = weekly[
        ["scheduled_staff", "present_staff"]
    ].fillna(0)
    weekly["refusal_rate"] = (
        100 * weekly["patients_refused"] / weekly["patients_request"].replace(0, pd.NA)
    )
    weekly["attendance_rate"] = (
        100 * weekly["present_staff"] / weekly["scheduled_staff"].replace(0, pd.NA)
    )

    patients["arrival_date"] = pd.to_datetime(patients["arrival_date"], errors="coerce")
    patients["departure_date"] = pd.to_datetime(patients["departure_date"], errors="coerce")
    patients["length_of_stay"] = (
        patients["departure_date"] - patients["arrival_date"]
    ).dt.days
    patients = patients.loc[patients["length_of_stay"] > 0].copy()
    return weekly, patients


try:
    weekly_data, patient_data = load_data()
except (FileNotFoundError, KeyError, pd.errors.ParserError) as error:
    st.error(f"Could not load the project data: {error}")
    st.stop()

st.sidebar.markdown('<div class="eyebrow">Explore the dataset</div>', unsafe_allow_html=True)
st.sidebar.header("Filters")
all_services = sorted(weekly_data["service"].dropna().unique().tolist())
all_events = sorted(weekly_data["event"].dropna().unique().tolist())
selected_services = st.sidebar.multiselect("Services", all_services, default=all_services)
selected_events = st.sidebar.multiselect("Event type", all_events, default=all_events)
min_week = int(weekly_data["week"].min())
max_week = int(weekly_data["week"].max())
selected_weeks = st.sidebar.slider("Week range", min_week, max_week, (min_week, max_week))

st.sidebar.markdown("#### Alert thresholds")
refusal_trigger = st.sidebar.slider("Refusal rate (%)", 0, 100, 65)
attendance_trigger = st.sidebar.slider("Attendance below (%)", 0, 100, 50)
morale_trigger = st.sidebar.slider("Morale below", 0, 100, 60)

filtered = weekly_data.loc[
    weekly_data["service"].isin(selected_services)
    & weekly_data["event"].isin(selected_events)
    & weekly_data["week"].between(*selected_weeks)
].copy()
filtered_patients = patient_data.loc[patient_data["service"].isin(selected_services)].copy()

st.markdown('<div class="eyebrow">Hospital operations / interactive analysis</div>', unsafe_allow_html=True)
st.title("Capacity, access & workforce")
st.markdown(
    '<p class="subtle">Weekly service performance and patient flow, calculated from the project CSVs.</p>',
    unsafe_allow_html=True,
)

if filtered.empty:
    st.warning("No service-weeks match these filters. Expand the selection to see results.")
    st.stop()

total_requests = int(filtered["patients_request"].sum())
total_refusals = int(filtered["patients_refused"].sum())
refusal_pct = 100 * total_refusals / total_requests if total_requests else 0
avg_satisfaction = filtered["patient_satisfaction"].mean()
average_beds = filtered["available_beds"].mean()

metric_columns = st.columns(4)
metric_columns[0].metric("Patient requests", f"{total_requests:,}")
metric_columns[1].metric("Patients refused", f"{total_refusals:,}", f"{refusal_pct:.1f}% of requests", delta_color="inverse")
metric_columns[2].metric("Avg. beds per service-week", f"{average_beds:,.1f}")
metric_columns[3].metric("Avg. satisfaction (/100)", f"{avg_satisfaction:.1f}")

overview_tab, capacity_tab, workforce_tab = st.tabs(
    ["Overview", "Capacity & access", "Workforce & flow"]
)

with overview_tab:
    summary = (
        filtered.groupby("service", as_index=False)
        .agg(
            requests=("patients_request", "sum"),
            refused=("patients_refused", "sum"),
            weeks=("week", "nunique"),
            avg_satisfaction=("patient_satisfaction", "mean"),
            avg_morale=("staff_morale", "mean"),
        )
    )
    summary["refusal_pct"] = 100 * summary["refused"] / summary["requests"].replace(0, pd.NA)
    summary["high_refusal_weeks"] = (
        filtered.assign(high_refusal=filtered["refusal_rate"] >= refusal_trigger)
        .groupby("service")["high_refusal"]
        .sum()
        .reindex(summary["service"])
        .to_numpy()
    )
    summary = summary.sort_values("refused", ascending=False)

    left, right = st.columns([1.3, 1])
    with left:
        st.subheader("Refusals by service")
        refusal_chart = px.bar(
            summary.sort_values("refusal_pct"),
            x="refusal_pct",
            y="service",
            orientation="h",
            color="refusal_pct",
            color_continuous_scale=["#8dc7a8", "#e8bd62", "#df7056"],
            custom_data=["refused", "requests"],
        )
        refusal_chart.update_traces(
            hovertemplate="%{y}<br>Refusal rate: %{x:.1f}%<br>Refused: %{customdata[0]:,.0f} of %{customdata[1]:,.0f}<extra></extra>"
        )
        refusal_chart.update_layout(
            xaxis_title="Requests refused (%)",
            yaxis_title="",
            coloraxis_showscale=False,
            margin=dict(l=8, r=8, t=12, b=8),
        )
        st.plotly_chart(refusal_chart, width="stretch")
    with right:
        st.subheader("Event pressure")
        event_summary = (
            filtered.groupby("event", as_index=False)
            .agg(requests=("patients_request", "sum"), refused=("patients_refused", "sum"))
        )
        event_summary["refusal_pct"] = 100 * event_summary["refused"] / event_summary["requests"].replace(0, pd.NA)
        event_chart = px.bar(
            event_summary.sort_values("refusal_pct"),
            x="refusal_pct",
            y="event",
            orientation="h",
            color="event",
            color_discrete_sequence=CHART_COLORS,
            hover_data={"requests": True, "refused": True, "event": False},
        )
        event_chart.update_layout(
            xaxis_title="Requests refused (%)",
            yaxis_title="",
            showlegend=False,
            margin=dict(l=8, r=8, t=12, b=8),
        )
        st.plotly_chart(event_chart, width="stretch")

    st.subheader("Service watchlist")
    summary["avg_satisfaction"] = summary["avg_satisfaction"].round(1)
    summary["avg_morale"] = summary["avg_morale"].round(1)
    st.dataframe(
        summary.rename(
            columns={
                "service": "Service",
                "requests": "Requests",
                "refused": "Refused",
                "refusal_pct": "Refusal rate (%)",
                "weeks": "Weeks",
                "high_refusal_weeks": f"Weeks at/above {refusal_trigger}%",
                "avg_satisfaction": "Avg satisfaction",
                "avg_morale": "Avg morale",
            }
        ).round({"Refusal rate (%)": 1}),
        hide_index=True,
        width="stretch",
    )

with capacity_tab:
    st.subheader("Weekly demand and available beds")
    weekly_rollup = (
        filtered.groupby("week", as_index=False)
        .agg(
            requests=("patients_request", "sum"),
            beds=("available_beds", "sum"),
            admitted=("patients_admitted", "sum"),
            refused=("patients_refused", "sum"),
        )
        .sort_values("week")
    )
    demand_chart = go.Figure()
    demand_chart.add_trace(go.Scatter(x=weekly_rollup["week"], y=weekly_rollup["requests"], name="Requests", line=dict(color="#e76f51", width=3)))
    demand_chart.add_trace(go.Scatter(x=weekly_rollup["week"], y=weekly_rollup["beds"], name="Available beds", line=dict(color="#087f5b", width=2, dash="dot")))
    demand_chart.add_trace(go.Scatter(x=weekly_rollup["week"], y=weekly_rollup["admitted"], name="Admitted", line=dict(color="#3973ac", width=2)))
    demand_chart.update_layout(
        xaxis_title="Week",
        yaxis_title="Patients / beds",
        hovermode="x unified",
        legend=dict(orientation="h", y=1.12),
        margin=dict(l=8, r=8, t=32, b=8),
    )
    st.plotly_chart(demand_chart, width="stretch")

    st.subheader("Illustrative 10% bed increase")
    st.caption("Fixed-demand estimate: each added bed is assumed staffed and usable; demand and length of stay are held constant.")
    bed_scenario = filtered.assign(
        added_beds=(filtered["available_beds"] * 0.10).floordiv(1),
    )
    bed_scenario["modeled_refusals"] = (
        bed_scenario["patients_refused"] - bed_scenario["added_beds"]
    ).clip(lower=0)
    scenario = (
        bed_scenario.groupby("service", as_index=False)
        .agg(
            baseline_refusals=("patients_refused", "sum"),
            added_bed_weeks=("added_beds", "sum"),
            modeled_refusals=("modeled_refusals", "sum"),
        )
    )
    scenario["modeled_reduction_pct"] = (
        100 * (scenario["baseline_refusals"] - scenario["modeled_refusals"])
        / scenario["baseline_refusals"].replace(0, pd.NA)
    )
    st.dataframe(
        scenario.rename(
            columns={
                "service": "Service",
                "baseline_refusals": "Current refusals",
                "added_bed_weeks": "Added bed-weeks",
                "modeled_refusals": "Modeled refusals",
                "modeled_reduction_pct": "Modeled reduction (%)",
            }
        ).round({"Modeled reduction (%)": 1}),
        hide_index=True,
        width="stretch",
    )

with workforce_tab:
    st.subheader("Attendance and refusal pressure by week")
    workforce_rollup = (
        filtered.groupby("week", as_index=False)
        .agg(
            scheduled=("scheduled_staff", "sum"),
            present=("present_staff", "sum"),
            requests=("patients_request", "sum"),
            refused=("patients_refused", "sum"),
        )
        .sort_values("week")
    )
    workforce_rollup["attendance_pct"] = 100 * workforce_rollup["present"] / workforce_rollup["scheduled"].replace(0, pd.NA)
    workforce_rollup["refusal_pct"] = 100 * workforce_rollup["refused"] / workforce_rollup["requests"].replace(0, pd.NA)
    workforce_chart = go.Figure()
    workforce_chart.add_trace(go.Scatter(x=workforce_rollup["week"], y=workforce_rollup["attendance_pct"], name="Attendance", line=dict(color="#087f5b", width=3)))
    workforce_chart.add_trace(go.Scatter(x=workforce_rollup["week"], y=workforce_rollup["refusal_pct"], name="Refusal rate", line=dict(color="#e76f51", width=2), yaxis="y2"))
    workforce_chart.update_layout(
        xaxis_title="Week",
        yaxis=dict(title="Attendance (%)", range=[0, 100]),
        yaxis2=dict(title="Refusal rate (%)", overlaying="y", side="right", range=[0, 100]),
        legend=dict(orientation="h", y=1.12),
        margin=dict(l=8, r=8, t=32, b=8),
    )
    st.plotly_chart(workforce_chart, width="stretch")

    left, right = st.columns(2)
    with left:
        st.subheader("Length of stay by service")
        los_summary = (
            filtered_patients.groupby("service", as_index=False)
            .agg(
                patients=("length_of_stay", "size"),
                avg_los=("length_of_stay", "mean"),
                median_los=("length_of_stay", "median"),
            )
        )
        if not los_summary.empty:
            los_summary["illustrative_bed_days_freed"] = los_summary["patients"]
            los_chart = px.bar(
                los_summary.sort_values("avg_los"),
                x="avg_los",
                y="service",
                orientation="h",
                color="avg_los",
                color_continuous_scale=["#8dc7a8", "#3973ac"],
                hover_data={"patients": True, "median_los": ":.1f", "avg_los": ":.1f"},
            )
            los_chart.update_layout(xaxis_title="Average stay (days)", yaxis_title="", coloraxis_showscale=False, margin=dict(l=8, r=8, t=8, b=8))
            st.plotly_chart(los_chart, width="stretch")
            st.caption("One bed-day per eligible stay is an illustrative upper-bound scenario, not a discharge target.")
            st.dataframe(
                los_summary.rename(
                    columns={
                        "service": "Service",
                        "patients": "Eligible stays",
                        "avg_los": "Avg stay (days)",
                        "median_los": "Median stay (days)",
                        "illustrative_bed_days_freed": "Bed-days if each stay fell by 1 day",
                    }
                ).round({"Avg stay (days)": 1, "Median stay (days)": 1}),
                hide_index=True,
                width="stretch",
            )
        else:
            st.info("No eligible patient stays match the selected services.")

    with right:
        st.subheader("Operational alerts")
        alert_rows = filtered.assign(
            refusal_alert=filtered["refusal_rate"] >= refusal_trigger,
            attendance_alert=filtered["attendance_rate"] < attendance_trigger,
            morale_alert=filtered["staff_morale"] < morale_trigger,
            bed_gap=filtered["patients_request"] > filtered["available_beds"],
        )
        alert_summary = (
            alert_rows.groupby("service", as_index=False)
            .agg(
                weeks=("week", "nunique"),
                high_refusal_weeks=("refusal_alert", "sum"),
                low_attendance_weeks=("attendance_alert", "sum"),
                low_morale_weeks=("morale_alert", "sum"),
                weeks_demand_above_beds=("bed_gap", "sum"),
            )
        )
        alert_summary = alert_summary.rename(
            columns={
                "service": "Service",
                "weeks": "Weeks",
                "high_refusal_weeks": "High refusal",
                "low_attendance_weeks": "Low attendance",
                "low_morale_weeks": "Low morale",
                "weeks_demand_above_beds": "Demand > beds",
            }
        )
        st.dataframe(alert_summary, hide_index=True, width="stretch")
        st.caption("Triggers are configurable screening thresholds, not validated clinical staffing standards.")

st.divider()
st.markdown('<div class="eyebrow">Filtered records</div>', unsafe_allow_html=True)
st.dataframe(
    filtered.sort_values(["week", "service"]),
    hide_index=True,
    width="stretch",
)
st.download_button(
    "Download filtered service-weeks",
    data=filtered.to_csv(index=False).encode("utf-8"),
    file_name="hospital_filtered_service_weeks.csv",
    mime="text/csv",
)
st.caption("Analysis is descriptive. Bed and length-of-stay scenarios assume fixed demand and do not imply causal effects.")
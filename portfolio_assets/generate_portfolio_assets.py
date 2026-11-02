from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent


def load_font(size: int, bold=False):
    candidates = [
        "C:/Windows/Fonts/arial.ttf",
        "C:/Windows/Fonts/arialbd.ttf",
        "C:/Windows/Fonts/calibri.ttf",
        "C:/Windows/Fonts/calibrib.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size=size)
        except Exception:
            pass
    return ImageFont.load_default()


def draw_kpi_card(draw, x, y, w, h, label, value, accent, subtitle=""):
    draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(21, 30, 49), outline=(60, 82, 116), width=1)
    draw.rounded_rectangle((x + 12, y + 12, x + w - 12, y + 24), radius=8, fill=accent)
    draw.text((x + 18, y + 36), label, font=load_font(22), fill=(180, 196, 218))
    draw.text((x + 18, y + 72), value, font=load_font(42, bold=True), fill=(245, 246, 250))
    if subtitle:
        draw.text((x + 18, y + h - 28), subtitle, font=load_font(16), fill=(125, 160, 190))


def create_cover_banner(path: Path):
    img = Image.new("RGB", (1584, 396), (11, 19, 33))
    draw = ImageDraw.Draw(img)
    # Background accents
    for i in range(16):
        x = 30 + i * 94
        draw.rounded_rectangle((x, 42, x + 70, 330), radius=22, fill=(27, 40, 62))
    # left text area
    draw.text((70, 70), "Hospital Operations", font=load_font(34), fill=(153, 202, 255))
    draw.text((70, 118), "Analytics Portfolio", font=load_font(58, bold=True), fill=(240, 245, 250))
    draw.text((70, 190), "Bed Utilization • Patient Refusals • Staffing Coverage", font=load_font(28), fill=(188, 205, 220))
    draw.text((70, 240), "SQL • Python • Power BI • PostgreSQL • Streamlit", font=load_font(22), fill=(125, 160, 190))
    draw.rounded_rectangle((70, 285, 470, 330), radius=16, fill=(39, 160, 120))
    draw.text((98, 292), "Portfolio Project", font=load_font(24), fill=(255, 255, 255))

    # 3 KPI badges on right
    badges = [
        (980, 80, 220, 110, "Refusal Rate", "80.9%", (239, 83, 80), "Emergency"),
        (1215, 80, 220, 110, "Utilization", "56.6%", (46, 204, 113), "Avg service"),
        (980, 220, 455, 120, "Key Insight", "Demand > Beds", (79, 120, 255), "Across most weeks"),
    ]
    for x, y, w, h, label, value, accent, subtitle in badges:
        draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(19, 31, 51), outline=(80, 112, 154), width=1)
        draw.text((x + 20, y + 18), label, font=load_font(18), fill=(170, 190, 214))
        draw.text((x + 20, y + 48), value, font=load_font(32, bold=True), fill=(250, 250, 250))
        draw.text((x + 20, y + 82), subtitle, font=load_font(16), fill=(120, 155, 185))
    img.save(path)
    img.save(path.with_suffix('.pdf'))


def create_dashboard_mockup(path: Path):
    img = Image.new("RGB", (1600, 900), (240, 245, 250))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((40, 30, 1560, 860), radius=22, fill=(250, 252, 255), outline=(209, 221, 232), width=2)
    draw.rounded_rectangle((70, 70, 1530, 135), radius=18, fill=(15, 31, 54))
    draw.text((100, 88), "Hospital Operations Dashboard", font=load_font(30, bold=True), fill=(255, 255, 255))
    draw.text((1230, 94), "Updated: Nov 2026", font=load_font(18), fill=(177, 197, 223))

    # KPI cards
    kpis = [
        (90, 170, 260, 170, "Refusal Rate", "80.9%", "Emergency", (239, 83, 80)),
        (380, 170, 260, 170, "Avg Satisfaction", "80.0", "Patient score", (46, 204, 113)),
        (670, 170, 260, 170, "Staff Attendance", "60.0%", "Average present", (79, 120, 255)),
        (960, 170, 260, 170, "Avg LOS", "4.8 days", "Across services", (255, 193, 7)),
        (1250, 170, 260, 170, "Demand > Beds", "43/52", "General Medicine", (160, 112, 255)),
    ]
    for x, y, w, h, label, value, subtitle, accent in kpis:
        draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(255, 255, 255), outline=(220, 228, 235), width=2)
        draw.rounded_rectangle((x + 18, y + 18, x + w - 18, y + 30), radius=8, fill=accent)
        draw.text((x + 24, y + 42), label, font=load_font(19), fill=(67, 88, 111))
        draw.text((x + 24, y + 72), value, font=load_font(30, bold=True), fill=(18, 31, 42))
        draw.text((x + 24, y + 118), subtitle, font=load_font(16), fill=(95, 119, 145))

    # Left chart
    chart_x, chart_y, chart_w, chart_h = 90, 390, 700, 360
    draw.rounded_rectangle((chart_x, chart_y, chart_x + chart_w, chart_y + chart_h), radius=18, fill=(255, 255, 255), outline=(220, 228, 235), width=2)
    draw.text((chart_x + 20, chart_y + 16), "Service Refusal Rates", font=load_font(24, bold=True), fill=(23, 35, 59))
    services = ["Emergency", "General", "Surgery", "ICU"]
    values = [80.9, 45.4, 24.8, 17.9]
    max_val = 100
    for i, (label, val) in enumerate(zip(services, values)):
        bar_x = chart_x + 60 + i * 160
        bar_w = 100
        bar_h = int((val / max_val) * 200)
        y0 = chart_y + 260
        draw.rounded_rectangle((bar_x, y0 - bar_h, bar_x + bar_w, y0), radius=10, fill=(65, 105, 225))
        draw.text((bar_x + 20, y0 + 20), label, font=load_font(18), fill=(70, 88, 104))
        draw.text((bar_x + 20, y0 - bar_h - 25), f"{val}%", font=load_font(16, bold=True), fill=(35, 44, 62))

    # Right panel
    right_x, right_y, right_w, right_h = 840, 390, 650, 360
    draw.rounded_rectangle((right_x, right_y, right_x + right_w, right_y + right_h), radius=18, fill=(255, 255, 255), outline=(220, 228, 235), width=2)
    draw.text((right_x + 20, right_y + 16), "Key Insights", font=load_font(24, bold=True), fill=(23, 35, 59))
    bmi = [
        ("Emergency demand exceeded beds in 52/52 weeks", (239, 83, 80)),
        ("Flu weeks showed 78.2% refusal rate", (255, 193, 7)),
        ("Attendance averaged 60% across services", (46, 204, 113)),
        ("Patient satisfaction averaged 80/100", (79, 120, 255)),
    ]
    for idx, (text, color) in enumerate(bmi):
        y = right_y + 60 + idx * 70
        draw.rounded_rectangle((right_x + 20, y, right_x + 590, y + 42), radius=12, fill=(242, 247, 252))
        draw.rounded_rectangle((right_x + 32, y + 12, right_x + 48, y + 28), radius=6, fill=color)
        draw.text((right_x + 62, y + 9), text, font=load_font(17), fill=(34, 44, 62))

    img.save(path)
    img.save(path.with_suffix('.pdf'))


def create_kpis_summary(path: Path):
    img = Image.new("RGB", (1400, 900), (246, 250, 255))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((40, 40, 1360, 860), radius=22, fill=(255, 255, 255), outline=(210, 218, 228), width=2)
    draw.text((80, 70), "Hospital Operations KPI Summary", font=load_font(32, bold=True), fill=(24, 37, 58))
    draw.text((80, 118), "Data-driven recommendations for capacity, attendance, and patient experience", font=load_font(20), fill=(88, 104, 124))

    cards = [
        (80, 180, 350, 180, "Emergency", "80.9%", "refusal rate", (239, 83, 80)),
        (470, 180, 350, 180, "General Medicine", "45.4%", "refusal rate", (255, 193, 7)),
        (860, 180, 350, 180, "Surgery", "24.8%", "refusal rate", (46, 204, 113)),
        (80, 420, 350, 180, "ICU", "17.9%", "refusal rate", (79, 120, 255)),
        (470, 420, 350, 180, "Attendance", "60.0%", "avg weekly present", (160, 112, 255)),
        (860, 420, 350, 180, "Satisfaction", "80/100", "average score", (0, 158, 160)),
    ]
    for x, y, w, h, label, value, subtitle, accent in cards:
        draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(248, 250, 252), outline=(214, 220, 228), width=2)
        draw.rounded_rectangle((x + 20, y + 18, x + w - 20, y + 34), radius=10, fill=accent)
        draw.text((x + 26, y + 52), label, font=load_font(22), fill=(34, 40, 58))
        draw.text((x + 26, y + 92), value, font=load_font(38, bold=True), fill=(14, 25, 37))
        draw.text((x + 26, y + 132), subtitle, font=load_font(16), fill=(84, 106, 126))

    # bottom insights
    box_x, box_y, box_w, box_h = 80, 660, 1220, 140
    draw.rounded_rectangle((box_x, box_y, box_x + box_w, box_y + box_h), radius=18, fill=(13, 29, 49))
    draw.text((box_x + 28, box_y + 30), "Actionable Recommendations", font=load_font(26, bold=True), fill=(255, 255, 255))
    text = [
        "• Prioritize emergency and general medicine capacity expansion",
        "• Improve staff attendance and cross-trained surge staffing",
        "• Increase preparedness for flu-related demand spikes",
    ]
    for i, line in enumerate(text):
        draw.text((box_x + 32, box_y + 72 + i * 28), line, font=load_font(18), fill=(214, 224, 238))

    img.save(path)
    img.save(path.with_suffix('.pdf'))


def create_fiverr_cover(path: Path):
    img = Image.new("RGB", (1280, 720), (11, 17, 30))
    draw = ImageDraw.Draw(img)
    # Dark background with light highlight blocks
    for i in range(10):
        draw.rounded_rectangle((50 + i * 110, 80, 130 + i * 110, 680), radius=22, fill=(20, 36, 55))

    draw.text((80, 90), "Data Analyst & BI Developer", font=load_font(28), fill=(140, 204, 255))
    draw.text((80, 140), "Healthcare Analytics", font=load_font(54, bold=True), fill=(255, 255, 255))
    draw.text((80, 220), "Portfolio Project", font=load_font(30), fill=(192, 217, 235))
    draw.text((80, 275), "SQL • Python • Power BI • PostgreSQL • Streamlit", font=load_font(24), fill=(177, 194, 212))

    draw.rounded_rectangle((80, 345, 500, 520), radius=20, fill=(17, 90, 70))
    draw.text((110, 380), "Project Highlights", font=load_font(24, bold=True), fill=(255, 255, 255))
    text_lines = [
        "• Bed utilization analysis",
        "• Refusal rate investigation",
        "• Staffing & morale review",
        "• Executive dashboard",
    ]
    for idx, line in enumerate(text_lines):
        draw.text((110, 430 + idx * 32), line, font=load_font(18), fill=(232, 241, 248))

    # right-side stats boxes
    stats = [
        (760, 120, 430, 120, "80.9%", "Emergency refusal rate"),
        (760, 270, 430, 120, "60.0%", "Staff attendance average"),
        (760, 420, 430, 120, "56.6%", "Average utilization"),
    ]
    for x, y, w, h, value, label in stats:
        draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(18, 30, 49), outline=(80, 110, 146), width=1)
        draw.text((x + 24, y + 24), value, font=load_font(38, bold=True), fill=(255, 255, 255))
        draw.text((x + 24, y + 74), label, font=load_font(18), fill=(186, 206, 224))

    img.save(path)
    img.save(path.with_suffix('.pdf'))


def create_linkedin_banner(path: Path):
    img = Image.new("RGB", (1584, 396), (241, 246, 250))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((30, 30, 1554, 366), radius=22, fill=(10, 25, 42))
    draw.rounded_rectangle((70, 80, 650, 320), radius=20, fill=(16, 42, 68))
    draw.text((90, 90), "Hospital Operations", font=load_font(24), fill=(174, 214, 255))
    draw.text((90, 128), "Analytics Portfolio", font=load_font(42, bold=True), fill=(255, 255, 255))
    draw.text((90, 192), "Capacity • Refusals • Staffing • Patient Experience", font=load_font(22), fill=(192, 212, 230))
    draw.text((90, 236), "Power BI • SQL • Python • PostgreSQL • Streamlit", font=load_font(18), fill=(140, 173, 198))

    # data blocks on right
    blocks = [
        (820, 90, 210, 105, "80.9%", "Emergency Refusal"),
        (1060, 90, 210, 105, "60.0%", "Attendance"),
        (820, 220, 450, 110, "Demand > Beds", "Most weeks in key services"),
    ]
    for x, y, w, h, value, label in blocks:
        draw.rounded_rectangle((x, y, x + w, y + h), radius=18, fill=(20, 36, 58), outline=(74, 97, 129), width=1)
        draw.text((x + 20, y + 20), value, font=load_font(30, bold=True), fill=(255,255,255))
        draw.text((x + 20, y + 60), label, font=load_font(18), fill=(193, 214, 234))

    img.save(path)
    img.save(path.with_suffix('.pdf'))


def main():
    ROOT.mkdir(exist_ok=True)
    create_cover_banner(ROOT / "hospital_operations_cover.png")
    create_dashboard_mockup(ROOT / "dashboard_mockup.png")
    create_kpis_summary(ROOT / "kpi_summary.png")
    create_fiverr_cover(ROOT / "fiverr_cover.png")
    create_linkedin_banner(ROOT / "linkedin_banner.png")

    for file in ROOT.glob("*.png"):
        print(f"Created: {file.name}")
    for file in ROOT.glob("*.pdf"):
        print(f"Created: {file.name}")


if __name__ == "__main__":
    main()

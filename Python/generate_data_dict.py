import csv
import json
import re
from collections import Counter
from datetime import date
from pathlib import Path



# Usage
#DATA_DIR = ROOT / "data"                          Add data folder here
# OUTPUT_FILE = ROOT / "docs" / "Data_Dict.json"            Add destination json file path here

#python scripts/generate_data_dictionary.py         Run 


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data"
OUTPUT_FILE = ROOT / "docs" / "Data_Dict.json"

NULL_VALUES = {"", "na", "n/a", "null", "none", "nan"}


def infer_type(values):
    values = [value.strip() for value in values if value.strip().lower() not in NULL_VALUES]
    if not values:
        return "unknown"

    lowered = {value.lower() for value in values}
    if lowered <= {"true", "false", "yes", "no", "0", "1"}:
        return "boolean"

    try:
        for value in values:
            date.fromisoformat(value[:10])
        return "date"
    except ValueError:
        pass

    if all(re.fullmatch(r"[+-]?\d+", value) for value in values):
        return "integer"

    try:
        for value in values:
            float(value.replace(",", ""))
        return "number"
    except ValueError:
        return "string"


def describe_csv(path):
    with path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        columns = reader.fieldnames or []
        rows = list(reader)

    fields = {}
    for column in columns:
        values = [row.get(column, "") or "" for row in rows]
        non_null = [v.strip() for v in values if v.strip().lower() not in NULL_VALUES]
        samples = list(dict.fromkeys(non_null))[:5]

        fields[column] = {
            "type": infer_type(values),
            "nullable": len(non_null) < len(values),
            "null_count": len(values) - len(non_null),
            "sample_values": samples,
            "description": "",
        }

    return {
        "row_count": len(rows),
        "column_count": len(columns),
        "fields": fields,
    }


dictionary = {
    path.name: describe_csv(path)
    for path in sorted(DATA_DIR.glob("*.csv"))
}

OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
OUTPUT_FILE.write_text(json.dumps(dictionary, indent=2), encoding="utf-8")
print(f"Created {OUTPUT_FILE}")
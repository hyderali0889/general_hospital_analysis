"""Replay synthetic patient admissions through Kafka and count consumed events."""

from __future__ import annotations

import argparse
import csv
import json
import os
import random
import time
import uuid
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterator

from kafka import KafkaConsumer, KafkaProducer
from kafka.errors import KafkaError


PROJECT_ROOT = Path(__file__).resolve().parents[1]
PATIENTS_CSV = PROJECT_ROOT / "data" / "patients.csv"


def load_patients(path: Path = PATIENTS_CSV) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        required_columns = {"patient_id", "service", "arrival_date"}
        missing_columns = required_columns.difference(reader.fieldnames or [])
        if missing_columns:
            missing = ", ".join(sorted(missing_columns))
            raise ValueError(f"{path.name} is missing required columns: {missing}")
        patients = [
            row
            for row in reader
            if row.get("patient_id") and row.get("service")
        ]
    if not patients:
        raise ValueError(f"No usable patient records were found in {path}")
    return patients


def generate_events(
    patients: list[dict[str, str]], event_count: int, seed: int | None = None
) -> Iterator[dict[str, str]]:
    rng = random.Random(seed)
    for _ in range(event_count):
        patient = rng.choice(patients)
        yield {
            "event_id": str(uuid.uuid4()),
            "event_type": "patient_admitted",
            "patient_id": patient["patient_id"],
            "service": patient["service"],
            "arrival_date": patient.get("arrival_date", ""),
            "emitted_at_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        }


def create_producer(bootstrap_server: str) -> KafkaProducer:
    return KafkaProducer(
        bootstrap_servers=bootstrap_server,
        client_id="hospital-admission-simulator",
        key_serializer=lambda service: service.encode("utf-8"),
        value_serializer=lambda event: json.dumps(event).encode("utf-8"),
    )


def create_consumer(
    bootstrap_server: str,
    topic: str,
    group_id: str,
    from_beginning: bool,
) -> KafkaConsumer:
    consumer = KafkaConsumer(
        bootstrap_servers=bootstrap_server,
        client_id="hospital-admission-monitor",
        group_id=group_id,
        auto_offset_reset="earliest" if from_beginning else "latest",
        enable_auto_commit=True,
        value_deserializer=lambda payload: json.loads(payload.decode("utf-8")),
    )
    consumer.subscribe([topic])
    return consumer


def print_consumed(event: dict[str, Any], totals: Counter[str]) -> None:
    service = str(event.get("service", "unknown"))
    totals[service] += 1
    print(
        json.dumps(
            {"consumed": event, "admissions_by_service": dict(sorted(totals.items()))},
            sort_keys=True,
        ),
        flush=True,
    )


def wait_for_assignment(consumer: KafkaConsumer, timeout_seconds: float = 15) -> None:
    deadline = time.monotonic() + timeout_seconds
    while not consumer.assignment():
        consumer.poll(timeout_ms=250)
        if time.monotonic() >= deadline:
            raise TimeoutError("Kafka did not assign the admission topic to the consumer")


def publish_events(
    producer: KafkaProducer,
    topic: str,
    events: Iterator[dict[str, str]],
    interval: float,
) -> None:
    for event in events:
        metadata = producer.send(topic, key=event["service"], value=event).get(timeout=15)
        print(
            f"published event_id={event['event_id']} service={event['service']} "
            f"partition={metadata.partition} offset={metadata.offset}",
            flush=True,
        )
        if interval:
            time.sleep(interval)
    producer.flush(timeout=15)


def run_consumer(args: argparse.Namespace) -> None:
    consumer = create_consumer(
        args.bootstrap_server,
        args.topic,
        args.group_id,
        args.from_beginning,
    )
    totals: Counter[str] = Counter()
    print(f"Listening on {args.topic} at {args.bootstrap_server}; press Ctrl+C to stop.")
    try:
        for records in consumer:
            print_consumed(records.value, totals)
    except KeyboardInterrupt:
        print("\nConsumer stopped.")
    finally:
        consumer.close()


def run_demo(args: argparse.Namespace, patients: list[dict[str, str]]) -> None:
    demo_group = f"hospital-admission-demo-{uuid.uuid4()}"
    consumer = create_consumer(
        args.bootstrap_server,
        args.topic,
        demo_group,
        from_beginning=False,
    )
    producer = create_producer(args.bootstrap_server)
    totals: Counter[str] = Counter()
    try:
        wait_for_assignment(consumer)
        for event in generate_events(patients, args.events, args.seed):
            metadata = producer.send(args.topic, key=event["service"], value=event).get(
                timeout=15
            )
            print(
                f"published event_id={event['event_id']} service={event['service']} "
                f"partition={metadata.partition} offset={metadata.offset}",
                flush=True,
            )
            deadline = time.monotonic() + 15
            consumed = False
            while time.monotonic() < deadline and not consumed:
                for records in consumer.poll(timeout_ms=500).values():
                    for record in records:
                        print_consumed(record.value, totals)
                        consumed = record.value.get("event_id") == event["event_id"]
                if not consumed:
                    time.sleep(0.05)
            if not consumed:
                raise TimeoutError(f"Timed out waiting to consume {event['event_id']}")
            if args.interval:
                time.sleep(args.interval)
    finally:
        producer.close(timeout=15)
        consumer.close()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Stream synthetic hospital admission events through Kafka."
    )
    parser.add_argument(
        "--mode",
        choices=("demo", "produce", "consume"),
        default="demo",
        help="Run producer and consumer together, or start either side separately.",
    )
    parser.add_argument(
        "--bootstrap-server",
        default=os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092"),
        help="Kafka bootstrap address (default: localhost:9092).",
    )
    parser.add_argument("--topic", default="hospital.admissions")
    parser.add_argument("--group-id", default="hospital-admissions-monitor")
    parser.add_argument("--events", type=int, default=10, help="Number of events to publish.")
    parser.add_argument("--interval", type=float, default=1.0, help="Seconds between events.")
    parser.add_argument("--seed", type=int, default=None, help="Optional random seed.")
    parser.add_argument(
        "--from-beginning",
        action="store_true",
        help="Read existing topic records when starting a consumer.",
    )
    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    if args.events < 1:
        parser.error("--events must be at least 1")
    if args.interval < 0:
        parser.error("--interval cannot be negative")

    try:
        if args.mode == "consume":
            run_consumer(args)
            return

        patients = load_patients()
        events = generate_events(patients, args.events, args.seed)
        if args.mode == "produce":
            producer = create_producer(args.bootstrap_server)
            try:
                publish_events(producer, args.topic, events, args.interval)
            finally:
                producer.close(timeout=15)
        else:
            run_demo(args, patients)
    except (KafkaError, OSError, TimeoutError, ValueError) as error:
        raise SystemExit(
            f"Kafka simulation failed: {error}\n"
            "Start the Kafka service with `docker compose -f project_apps/compose.yml up -d kafka`."
        ) from error


if __name__ == "__main__":
    main()
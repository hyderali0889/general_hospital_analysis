curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d '{
    "name": "hospital-postgres-connector",
    "config": {
      "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
      "tasks.max": "1",
      "database.hostname": "postgres",
      "database.port": "5432",
      "database.user": "hospital",
      "database.password": "hospital123",
      "database.dbname": "hospital_beds",
      "topic.prefix": "hospital",
      "plugin.name": "pgoutput",
      "slot.name": "hospital_slot",
      "publication.name": "hospital_publication",
      "table.include.list": "public.patients,public.staff,public.services_weekly,public.staff_schedule",
      "schema.include.list": "public"
    }
  }'
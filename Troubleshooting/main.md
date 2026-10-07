# Metabase PostgreSQL Connection Troubleshooting

## Quick navigation

- [Problem summary](#problem-summary)
- [Root cause](#root-cause)
- [Important checks](#important-checks)
- [Copy/paste commands](#copy-paste-commands)
- [What success looks like](#what-success-looks-like)
- [If it still fails](#if-it-still-fails)

---

## Problem summary

The error:

```text
ERROR metabase.driver.util Failed to connect to Database: Connection to 127.0.0.1:5432 refused
```

usually means Metabase is trying to reach PostgreSQL from inside the Metabase container using `127.0.0.1`.

> Inside the Metabase container, `127.0.0.1` means the Metabase container itself, not the PostgreSQL container.

This is almost always a Docker networking / hostname issue, not a PostgreSQL database issue.

---

## Root cause

If PostgreSQL is running in a separate Docker container, Metabase should not point to:

```text
127.0.0.1:5432
```

It should point to the Docker service or container name, such as:

```text
postgres:5432
```

or:

```text
my-postgres:5432
```

### Important distinction

- From your Windows machine, `localhost:5432` may work because Docker publishes the port to the host.
- From inside the Metabase container, `localhost:5432` means the Metabase container itself.
- The correct target is the Docker hostname, not the local machine loopback address.

---

## Important checks

### 1) Confirm both containers are running

```bash
docker ps
```

Expected output should show both containers, for example:

```text
CONTAINER ID   IMAGE                       NAMES
xxxx           metabase/metabase          metabase
xxxx           postgres:14.21-trixie      my-postgres
```

### 2) Confirm both containers are on the same Docker network

```bash
docker inspect metabase --format '{{json .NetworkSettings.Networks}}'
docker inspect my-postgres --format '{{json .NetworkSettings.Networks}}'
```

If both are on the same network, then Metabase should use the container/service hostname, not `127.0.0.1`.

### 3) Check whether PostgreSQL is reachable from Metabase

```bash
docker exec hospital_postgres pg_isready -U hospital -d hospital_beds
```

Expected result:

```text
/var/run/postgresql:5432 - accepting connections
```

### 4) Check Metabase environment variables

```bash
docker exec hospital_metabase env | findstr MB_DB
```

Expected result:

```text
MB_DB_TYPE=postgres
MB_DB_DBNAME=hospital_beds
MB_DB_HOST=postgres
MB_DB_PORT=5432
MB_DB_USER=hospital
MB_DB_PASS=hospital123
```

### 5) Test raw TCP connectivity from the Metabase container

```bash
docker exec hospital_metabase bash -c "cat < /dev/null > /dev/tcp/postgres/5432"
```

- If this succeeds with no error, the network path is working.
- If it fails with `Connection refused`, PostgreSQL is not accepting connections from the Docker network.

---

## Copy/paste commands

### Basic container check

```bash
docker ps
```

### Docker DNS / network check

```bash
docker inspect metabase --format '{{json .NetworkSettings.Networks}}'
docker inspect my-postgres --format '{{json .NetworkSettings.Networks}}'
```

### PostgreSQL readiness check

```bash
docker exec hospital_postgres pg_isready -U hospital -d hospital_beds
```

### Metabase DB config check

```bash
docker exec hospital_metabase env | findstr MB_DB
```

### TCP reachability test from Metabase

```bash
docker exec hospital_metabase bash -c "cat < /dev/null > /dev/tcp/postgres/5432"
```

### Metabase logs

```bash
docker logs hospital_metabase --tail 100
```

---

## What success looks like

This confirms the setup is correct:

```text
MB_DB_HOST=postgres
MB_DB_PORT=5432
MB_DB_USER=hospital
MB_DB_DBNAME=hospital_beds
```

and:

```text
postgres resolves correctly from Metabase
```

and:

```text
/var/run/postgresql:5432 - accepting connections
```

This is the point where the likely remaining issue is not Docker networking but actual Metabase startup configuration or credentials.

---

## Example Docker Compose pattern

```yaml
services:
  postgres:
    image: postgres:14.21-trixie
    container_name: my-postgres
    environment:
      POSTGRES_DB: hospital_project
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: your_password
    ports:
      - "5432:5432"

  metabase:
    image: metabase/metabase:latest
    container_name: metabase
    ports:
      - "3000:3000"
    depends_on:
      - postgres
```

In Metabase, use:

```text
Host: postgres
Port: 5432
Database name: hospital_project
```

If your service/container name is `my-postgres`, then use:

```text
Host: my-postgres
```

---

## If it still fails

If the following are true:

- `MB_DB_HOST=postgres`
- `MB_DB_PORT=5432`
- PostgreSQL responds to `pg_isready`
- The Metabase container can reach `postgres:5432`

then the problem is likely one of the following:

1. Wrong database name
2. Wrong username/password
3. Metabase is still using an old startup environment variable
4. Metabase was started before the env values were corrected

### Final verification commands

```bash
docker exec hospital_metabase env | findstr MB_DB
docker exec hospital_postgres pg_isready -U hospital -d hospital_beds
docker logs hospital_metabase --tail 100
```

> At this point, do not change Docker networking or PostgreSQL settings unless the readiness check fails. The network and Metabase environment are already shown to be correct.

---

## Summary

The key point is simple:

```text
Metabase -> postgres -> 172.18.0.5
```

and not:

```text
Metabase -> 127.0.0.1:5432
```

If the checks above return the expected values, the configuration is correct and the next step is to investigate database credentials or startup state rather than Docker networking.
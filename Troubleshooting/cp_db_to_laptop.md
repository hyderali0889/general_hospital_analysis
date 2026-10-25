Great — since `hospital_beds` already exists on your laptop, you don't need to create another database. You just need to restore your backup into it.

Important: restoring into an existing database can cause conflicts if it already contains tables or data. If you need to preserve its current contents, back it up first.

## 1. On your original PC

Create the backup from your existing Docker PostgreSQL container:

```
docker exec hospital_postgres pg_dump -U postgres -d hospital_beds -Fc -f /tmp/hospital_beds.dump

docker cp hospital_postgres:/tmp/hospital_beds.dump .\hospital_beds.dump
```

Transfer `hospital_beds.dump` to your laptop.

## 2. On your laptop

First, copy the backup into your PostgreSQL container. Replace `hospital_postgres` if your container has a different name.

```
docker cp .\hospital_beds.dump hospital_postgres:/tmp/hospital_beds.dump
```

Then restore into the existing database:

```
docker exec hospital_postgres pg_restore -U postgres -d hospital_beds --clean --if-exists /tmp/hospital_beds.dump
```

Warning: `--clean --if-exists` drops existing objects that are included in the backup before restoring them. It can replace your laptop database's tables and data with the backup's contents.

## 3. Verify the database

```
docker exec -it hospital_postgres psql -U postgres -d hospital_beds -c "\dt"
```

To confirm, I need one detail: is the existing `hospital_beds` database on your laptop empty, or does it already contain tables and data you want to keep?
getent group postgres  || groupadd -g 41 postgres
getent passwd postgres || useradd -c "PostgreSQL user" -r -g postgres -d /var/lib/postgres -s /bin/false -u 41 postgres
mkdir -p /var/lib/postgres/data
chown -R postgres /var/lib/postgres
chmod 700 /var/lib/postgres/data

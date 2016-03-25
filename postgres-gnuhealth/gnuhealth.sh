#!/bin/bash
set -e

: ${GNUHEALTH_USER:=gnuhealth}
if [ "$GNUHEALTH_PASSWORD" ]; then
    PASS="PASSWORD '$GNUHEALTH_PASSWORD'"
else
    PASS="PASSWORD '$GNUHEALTH_USER'"
fi
: ${GNUHEALTH_DB:=health28}
: ${DB_ENCODING:=UTF-8}
: ${DB_DUMPFILE:=/demo.sql.gz}

# Perform all actions as user 'postgres'
export PGUSER=postgres

# Test if the gnuhealth database already exists
echo "Checking for existing database..."
INIT=$(psql -d template1 -t <<-EOSQL
        SELECT COUNT(*) from pg_database where datname = '$GNUHEALTH_DB';
EOSQL
)
INIT="$(echo "$INIT" | sed -e 's/^[ \t]*//;s/[ \t]*$//')"

if [ "${INIT}" == "0" ]; then
	echo "Creating the gnuhealth role..."
	psql <<-EOSQL
		CREATE USER $GNUHEALTH_USER WITH NOSUPERUSER NOINHERIT CREATEDB NOCREATEROLE NOREPLICATION $PASS;
	EOSQL
	echo
	echo "Creating the gnuhealth database..."
	psql <<-EOSQL
		CREATE DATABASE $GNUHEALTH_DB WITH OWNER $GNUHEALTH_USER ENCODING='$DB_ENCODING';
	EOSQL
	echo
	echo "Importing the gnuhealth database..."
	{ gosu postgres gunzip -c "$DB_DUMPFILE" | psql -d "$GNUHEALTH_DB"; }
	echo
	echo "Allowing access for the gnuhealth user from all IPs..."
	{ echo; echo "host all $GNUHEALTH_USER 0.0.0.0/0 md5"; } >> "$PGDATA"/pg_hba.conf
	echo
	echo "GNUHealth database ready for startup."
fi

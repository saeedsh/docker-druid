#!/bin/sh
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER metabase WITH PASSWORD 'metabase';
    CREATE DATABASE metabase;
    GRANT ALL PRIVILEGES ON DATABASE metabase TO metabase;
EOSQL

#!/bin/bash

# Creates user repl_user using ssl certs
if [[ $POSTGRES_REPLICATION_MODE == "master" ]]
then
    psql 'host=localhost port=5432 user=postgres sslmode=verify-ca sslcert=/opt/bitnami/postgresql/certs/postgresclientcert.pem sslkey=/opt/bitnami/postgresql/certs/postgresclientkey_dec.pem sslrootcert=/opt/bitnami/postgresql/certs/cacert.pem' -tc \
    "SELECT 1 FROM pg_roles WHERE rolname = '$POSTGRES_REPLICATION_USER'" | grep -q 1 \
    || psql 'host=localhost port=5432 user=postgres sslmode=verify-ca sslcert=/opt/bitnami/postgresql/certs/postgresclientcert.pem sslkey=/opt/bitnami/postgresql/certs/postgresclientkey_dec.pem sslrootcert=/opt/bitnami/postgresql/certs/cacert.pem' -c \
    "CREATE ROLE $POSTGRES_REPLICATION_USER WITH REPLICATION LOGIN ENCRYPTED PASSWORD '$POSTGRES_REPLICATION_PASSWORD';"
fi
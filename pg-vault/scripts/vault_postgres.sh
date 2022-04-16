#!/bin/bash

dir="$(dirname "$0")"
source "$dir/vars.sh"

export VAULT_ADDR='http://127.0.0.1:8200'
# remember to copy token
# export VAULT_TOKEN="..."

# vault server will leave in a different environment/network
vault secrets enable database

# create db config
vault write database/config/$PG_DBNAME \
	plugin_name=postgresql-database-plugin \
	allowed_roles="$ROLE_NAME" \
	connection_url="postgresql://{{username}}:{{password}}@0.0.0.0:5432/storedb?sslmode=disable" \
	username="$PG_USER" password="$PG_PASSWD"


sql_role="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"

# create role for db users
vault write database/roles/$ROLE_NAME \
	db_name=$PG_DBNAME \
	creation_statements="$sql_role" \
	default_ttl="6h" max_ttl="24h"


# to get user/password
# 
# vault read database/creds/$ROLE_NAME

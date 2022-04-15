#!/bin/bash

dir="$(dirname "$0")"
source "$dir/vars.sh"

# vault server will leave in a different environment/network
vault secrets enable database

# 'readonly' is the role name
vault write database/config/storedb \
	plugin_name=postgresql-database-plugin \
	allowed_roles="readonly" \
	connection_url="postgresql://{{username}}:{{password}}@0.0.0.0:5432/store?sslmode=disable" \
	username="postgres" password="Pass123456"


# 'readonly' is the role name
vault write database/roles/readonly \
	db_name=$PG_DBNAME \
	creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
	default_ttl="6h" max_ttl="24h"

# to get user/password
# 
# vault read database/creds/readonly

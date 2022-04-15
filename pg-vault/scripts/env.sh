#!/bin/bash

dir="$(dirname "$0")"
source "$dir/vars.sh"

export PG_HOST=0.0.0.0
export PG_PORT=5432
export PG_USER=$PG_USER
export PG_DBNAME=$PG_DBNAME

export VAULT_SECRET_PATH=database/creds/readonly

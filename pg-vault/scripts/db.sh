#!/bin/bash

dir="$(dirname "$0")"
source "$dir/vars.sh"


# docker run --name pg -p 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust -d postgres:10-alpine
docker run --rm -d -p 5432:5432 \
	-e POSTGRES_DB=$PG_DBNAME -e POSTGRES_USER=$PG_USER -e POSTGRES_PASSWORD=$PG_PASSWD \
	--name pg12 postgres:12-alpine

# echo "Creating '$PG_DBNAME' database"
# docker exec -ti pg12 createdb -U postgres $PG_DBNAME
# OR:
# docker exec -ti pg bash
# # 'store' is the db name
# createdb -U postgres store

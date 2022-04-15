
api:
	go run *.go

# These steps above should live in a different repo/service
db:
	bash scripts/db.sh

vault:
	# terminal #1
	vault server -dev
	# remember to copy token
	# export VAULT_TOKEN="..."

enable-vault-pg:
	# terminal #2
	bash scripts/vault_postgres.sh

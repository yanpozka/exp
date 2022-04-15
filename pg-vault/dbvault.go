package main

import (
	"errors"
	"fmt"
	"log"

	"github.com/hashicorp/vault/api"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func dbConnection() (*sqlx.DB, error) {
	username, passwd, err := getDBUserPass()
	if err != nil {
		return nil, err
	}

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		getOrDefault("PG_HOST", "0.0.0.0"),
		getOrDefault("PG_PORT", "5432"),
		username,
		passwd,
		getOrDefault("PG_DBNAME", "storedb"),
	)

	db, err := sqlx.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}
	if err := db.Ping(); err != nil {
		return nil, err
	}

	return db, nil
}

func getDBUserPass() (username, passwd string, err error) {
	config := &api.Config{
		Address: getOrDefault("VAULT_ADDR", "http://127.0.0.1:8222"),
	}

	var client *api.Client
	client, err = api.NewClient(config)
	if err != nil {
		return
	}

	vaultToken := getOrDefault("VAULT_TOKEN", "")
	if vaultToken == "" {
		err = errors.New("missing `VAULT_TOKEN` environment variable")
		return
	}
	client.SetToken(vaultToken)

	var secret *api.Secret
	secret, err = client.Logical().Read(getOrDefault("VAULT_SECRET_PATH", "database/creds/readonly_role"))
	if err != nil {
		return
	}

	username = secret.Data["username"].(string)
	passwd = secret.Data["password"].(string)

	log.Printf("user: %q password: %q and secret: %#v", username, passwd, secret.Data)
	return
}

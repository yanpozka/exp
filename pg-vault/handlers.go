package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/jmoiron/sqlx"
	"github.com/julienschmidt/httprouter"
)

func (*apiResource) health(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("true"))
}

type apiResource struct {
	db *sqlx.DB
}

func (a *apiResource) resource(w http.ResponseWriter, r *http.Request) {
	params, isParams := r.Context().Value(paramsCtxKey).(httprouter.Params)
	if !isParams {
		panic("Context doesn't have storeCtxKey or isn't Params type")
	}
	resourceID := params.ByName("resourceID")

	output := map[string]string{
		"id": resourceID,
	}

	// do something with the DB
	if err := a.db.Ping(); err != nil {
		panic(err)
	}

	buf, err := json.Marshal(output)

	if !writeErr(err, w, "error on Marshal output") {
		w.WriteHeader(http.StatusOK)
		if _, err := w.Write(buf); err != nil {
			log.Println(err)
		}
	}
}

func writeErr(err error, w http.ResponseWriter, message string) bool {
	if err != nil {
		log.Println(message, err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return true
	}
	return false
}

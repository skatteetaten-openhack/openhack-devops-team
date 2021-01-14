package tripsgo

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
)

func healthcheckGet(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)

	version, err := ioutil.ReadFile("version.txt")
	if err != nil {
		log.Fatal(err)
	}

	hc := &Healthcheck{Message: "Trip Service Healthcheck", Version: string(version), Status: "Healthy"}

	json.NewEncoder(w).Encode(hc)
}

// NCRRA provider adapter worker: no provider credential, endpoint or scraping logic is committed here.
package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/ncrra/platform/provider-adapter/internal/provider"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"status": "ok", "service": "provider-adapter"})
	})
	mux.HandleFunc("/readyz", func(w http.ResponseWriter, _ *http.Request) {
		enabled := os.Getenv("NCRRA_PROVIDER_INTEGRATION_ENABLED") == "true"
		w.Header().Set("Content-Type", "application/json")
		if !enabled {
			w.WriteHeader(http.StatusServiceUnavailable)
			_ = json.NewEncoder(w).Encode(map[string]any{"ready": false, "reason": "agreement-gated provider integrations remain disabled"})
			return
		}
		if err := provider.AgreementReadiness(os.Getenv("NCRRA_PROVIDER_AGREEMENTS_PATH"), time.Now().UTC()); err != nil {
			w.WriteHeader(http.StatusServiceUnavailable)
			_ = json.NewEncoder(w).Encode(map[string]any{"ready": false, "reason": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"ready": true})
	})

	port := os.Getenv("PORT")
	if port == "" { port = "8080" }
	log.Printf("provider adapter listening on :%s", port)
	log.Fatal(http.ListenAndServe(":"+port, mux))
}

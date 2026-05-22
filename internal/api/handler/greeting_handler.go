package handler

import (
	"encoding/json"
	"net/http"

	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/api/dto"
	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/ports"
)

type GreetingHandler struct {
	service ports.GreetingService
}

// NewGreetingHandler creates a new instance of GreetingHandler.
func NewGreetingHandler(service ports.GreetingService) *GreetingHandler {
	return &GreetingHandler{
		service: service,
	}
}

// GetGreeting handles GET /greeting requests.
func (h *GreetingHandler) GetGreeting(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	greeting, err := h.service.GetGreeting(r.Context())
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	response := dto.GreetingResponse{
		Message: greeting.Message,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}
}

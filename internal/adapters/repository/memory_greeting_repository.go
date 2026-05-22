package repository

import (
	"context"

	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/domain"
	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/ports"
)

type memoryGreetingRepository struct {
	message string
}

// NewMemoryGreetingRepository creates a new instance of GreetingRepository.
func NewMemoryGreetingRepository() ports.GreetingRepository {
	return &memoryGreetingRepository{
		message: "Hello from the dependency-free template!",
	}
}

func (r *memoryGreetingRepository) GetGreeting(ctx context.Context) (*domain.Greeting, error) {
	return &domain.Greeting{
		Message: r.message,
	}, nil
}

package ports

import (
	"context"

	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/app/_your_app_/core/domain"
)

// GreetingRepository is a driven port for greeting persistence.
type GreetingRepository interface {
	GetGreeting(ctx context.Context) (*domain.Greeting, error)
}

// GreetingService is a driving port for greeting-related application logic.
type GreetingService interface {
	GetGreeting(ctx context.Context) (*domain.Greeting, error)
}

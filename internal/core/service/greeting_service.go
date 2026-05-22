package service

import (
	"context"
	"fmt"

	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/domain"
	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/ports"
)

type greetingService struct {
	repo ports.GreetingRepository
}

// NewGreetingService creates a new instance of GreetingService.
func NewGreetingService(
	repo ports.GreetingRepository,
) ports.GreetingService {
	return &greetingService{
		repo: repo,
	}
}

func (s *greetingService) GetGreeting(ctx context.Context) (*domain.Greeting, error) {
	greeting, err := s.repo.GetGreeting(ctx)
	if err != nil {
		return nil, fmt.Errorf("get greeting: %w", err)
	}

	if err := greeting.Validate(); err != nil {
		return nil, fmt.Errorf("invalid greeting: %w", err)
	}

	return greeting, nil
}

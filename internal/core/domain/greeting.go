package domain

import "errors"

// Sentinel domain errors used across the application.
var (
	ErrGreetingNotFound = errors.New("greeting not found")
)

// Greeting is the core domain entity representing a greeting message.
type Greeting struct {
	Message string
}

// Validate performs domain-level validation on the Greeting entity.
func (g *Greeting) Validate() error {
	if g.Message == "" {
		return errors.New("message is required")
	}
	return nil
}

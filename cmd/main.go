package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/adapters/repository"
	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/api/handler"
	"github.com/YOUR-USER-OR-ORG-NAME/YOUR-REPO-NAME/internal/core/service"
)

func main() {
	// Initialize driven adapters (infrastructure)
	repo := repository.NewMemoryGreetingRepository()

	// Initialize core business logic (domain + service)
	greetingService := service.NewGreetingService(repo)

	// Initialize driving adapters (entry points)
	greetingHandler := handler.NewGreetingHandler(greetingService)

	// Set up standard HTTP ServeMux
	mux := http.NewServeMux()
	mux.HandleFunc("/greeting", greetingHandler.GetGreeting)

	// Configure server
	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	// Start server in a goroutine
	go func() {
		log.Println("starting server", "addr", server.Addr)
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Println("server failed to start", "error", err)
			os.Exit(1)
		}
	}()

	// Graceful shutdown: wait for interrupt signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("received shutdown signal, shutting down gracefully...")

	// Allow 10 seconds for active requests to complete
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		log.Fatal("server forced to shutdown", "error", err)
	}

	log.Println("server exited gracefully")
}

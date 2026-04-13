# Project Refactoring Plan: Clean Golang Template

## Objective
Transform the current repository into a clean, ready-to-go Golang project template by stripping out the existing "User" feature, removing all external dependencies from `go.mod`, and replacing the code with a minimal, dependency-free example feature ("Greeting"). This will perfectly demonstrate the Clean Architecture and Domain-Driven Design (DDD) principles defined in `AI_CONTEXT.md` without locking the template into specific external frameworks.

## Rules & Constraints
- **Strictly follow `AI_CONTEXT.md`**: Maintain the structural dependency rule (Adapters -> Ports <- Services -> Domain).
- **Remove "User" Feature**: Purge all files, structs, and logic related to users, logins, passwords, and tokens.
- **Zero External Dependencies**: Use the Go standard library exclusively (`net/http` for routing, `log`/`slog` for logging, standard `testing` for tests). Remove frameworks like Echo, Swagger, JWT, and Uber Mock.
- **Maintain Project Structure**: Do not delete the folder structure. Keep `cmd/`, `internal/`, `pkg/`, etc., intact.
- **Ready-to-Go Template**: The final code must compile and run flawlessly out of the box with the new example feature.

---

## Step-by-Step Implementation Guide

### Phase 1: Clean Up the Domain Layer (`core/domain`)
- [ ] **Delete User Code**: Remove `internal/app/_your_app_/core/domain/user.go` and any user-related sentinel errors in `errors.go`.
- [ ] **Create Example Entity**: Create `internal/app/_your_app_/core/domain/greeting.go`. Add a simple `Greeting` struct (e.g., `Message string`) and a basic `Validate()` method (e.g., ensuring `Message` is not empty).

### Phase 2: Clean Up the Ports Layer (`core/ports`)
- [ ] **Delete User Ports**: Remove `internal/app/_your_app_/core/ports/user.go`.
- [ ] **Delete Mocks**: Delete the entire `internal/app/_your_app_/core/ports/mock/` directory (we are removing external dependencies, including `mockgen`).
- [ ] **Create Example Ports**: Create `internal/app/_your_app_/core/ports/greeting.go`. Define a `GreetingService` interface (driving port) and a `GreetingRepository` interface (driven port).

### Phase 3: Clean Up the Service Layer (`core/service`)
- [ ] **Delete User Service**: Remove `internal/app/_your_app_/core/service/user_service.go` and its test file `user_service_test.go`.
- [ ] **Create Example Service**: Create `internal/app/_your_app_/core/service/greeting_service.go`. Implement the `GreetingService` interface, injecting the `GreetingRepository` via the constructor.
- [ ] **Write Standard Tests**: Create `greeting_service_test.go`. Use a manual struct that implements `GreetingRepository` instead of using a mocking framework.

### Phase 4: Clean Up the Adapters Layer (`adapters`)
- [ ] **Delete User DTOs**: Remove all files in `internal/app/_your_app_/adapters/dto/` (`user.go`, `login.go`, `error.go`).
- [ ] **Delete User Handler**: Remove `internal/app/_your_app_/adapters/handler/user_handler.go`.
- [ ] **Delete User Repository**: Remove `internal/app/_your_app_/adapters/repository/memory_user_repository.go`.
- [ ] **Create Example Adapters**:
  - Add `adapters/dto/greeting.go` with simple request/response structs.
  - Add `adapters/handler/greeting_handler.go` utilizing standard library `net/http` (e.g., `http.HandlerFunc`, `json.NewEncoder`).
  - Add `adapters/repository/memory_greeting_repository.go` as an in-memory implementation of `GreetingRepository`.

### Phase 5: Clean Up Shared Packages & Dependencies (`pkg` & `go.mod`)
- [ ] **Remove Auth Infrastructure**: Delete the `pkg/auth/` directory entirely (JWT and bcrypt logic).
- [ ] **Refactor Logger**: Modify `pkg/logger/logger.go` to use the standard library `log` or `log/slog` instead of the external `zerolog` package.
- [ ] **Purge `go.mod`**: Open `go.mod` and remove all external dependencies (e.g., `github.com/golang-jwt/jwt`, `github.com/rs/zerolog`, `github.com/swaggo/swag`, `golang.org/x/crypto`, `go.uber.org/mock`).
- [ ] **Tidy Modules**: Run `go mod tidy` in the terminal to clear out unused dependencies and clean `go.sum`.

### Phase 6: Rewire the Application (`cmd`)
- [ ] **Update Main**: Open `cmd/_your_app_/main.go`.
- [ ] **Remove Old Wiring**: Delete all setup logic for Echo, Swagger, JWT, and User handlers.
- [ ] **Wire New Feature**:
  - Instantiate `memory_greeting_repository`.
  - Pass the repository into `greeting_service`.
  - Pass the service into `greeting_handler`.
- [ ] **Start HTTP Server**: Use standard `http.ListenAndServe(":8080", mux)` with an `http.ServeMux` to serve the new greeting endpoints.

### Phase 7: Context Update (Optional but Recommended)
- [ ] **Update `AI_CONTEXT.md`**: Update references from `Echo` and `mockgen` to standard `net/http` and manual mocking to reflect the new dependency-free state of the template.

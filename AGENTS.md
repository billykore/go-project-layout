# AI Developer Guidance (AGENTS.md)

Welcome, AI Developer! This document serves as a set of instructions, architectural constraints, and workflow guides to help you maintain, extend, and debug this Go boilerplate repository.

---

## 1. Architectural Blueprint: Hexagonal Architecture

This project is structured around **Hexagonal Architecture** (also known as **Ports & Adapters**). The core objective is to decouple business logic from delivery mechanisms, databases, and third-party frameworks.

### The Dependency Rule

> [!IMPORTANT]
> Dependencies must only point **inward**. Inner layers must never import or depend on outer layers.

```mermaid
graph TD
    subgraph Driving Adapters [Driving Adapters (Input)]
        http[HTTP Handler / DTOs]
        cli[CLI / Cron / Queue Consumers]
    end

    subgraph Core [Clean Business Logic]
        ports[Ports / Interfaces]
        service[Services / Use Cases]
        domain[Domain / Entities]
    end

    subgraph Driven Adapters [Driven Adapters (Output)]
        repo[Repositories / Database]
        extern[External API Clients]
    end

    %% Dependencies
    http --> |calls| ports
    cli --> |calls| ports
    service --> |implements| ports
    service --> |manipulates| domain
    repo --> |implements| ports
    extern --> |implements| ports
    
    classDef inner fill:#d4edda,stroke:#28a745,stroke-width:2px;
    classDef outer fill:#fff3cd,stroke:#ffc107,stroke-width:2px;
    class domain,ports,service inner;
    class http,cli,repo,extern outer;
```

### Layer Reference & Bounds

1. **`internal/core/domain/`**:
   - **Purpose**: High-level business concepts, entities, and validation rules.
   - **Allowed Imports**: Standard library **only**. Absolutely no external libraries, databases, or frameworks (e.g., no Gorm, SQL packages, or web routers).
   - **Conventions**: Place domain-specific validation methods here (e.g., `Validate() error`). Define domain sentinel errors here (e.g., `ErrGreetingNotFound`).

2. **`internal/core/ports/`**:
   - **Purpose**: Contract definition layer containing only Go interfaces.
   - **Driving Ports (Inward)**: Interfaces implemented by services and called by handlers/APIs (e.g., `GreetingService`).
   - **Driven Ports (Outward)**: Interfaces implemented by repositories/adapters and called by services (e.g., `GreetingRepository`).
   - **Allowed Imports**: `context`, `internal/core/domain`.

3. **`internal/core/service/`**:
   - **Purpose**: Orchestrates use cases and implements driving ports.
   - **Rules**: Must only interact with dependencies through interfaces defined in `ports`. Never instantiate concrete repositories or HTTP clients directly here.
   - **Allowed Imports**: Standard library, `internal/core/domain`, `internal/core/ports`.

4. **`internal/adapters/`**:
   - **Purpose**: Implementation of driven ports (infrastructure layer). E.g., `repository/` implements DB persistence.
   - **Rules**: Free to import database packages, HTTP/gRPC client libraries, etc. Maps database/external responses back to core domain entities.

5. **`internal/api/`**:
   - **Purpose**: Implementation of driving adapters. E.g., `handler/` (web routers, controllers) and `dto/` (request/response models with JSON tags).
   - **Rules**: Translates HTTP request parameters, handles serialization/deserialization, maps request DTOs to domains, invokes core services, and converts responses or service errors to correct HTTP status codes.

6. **`cmd/`**:
   - **Composition Root**: The `cmd/main.go` file is responsible for reading configuration, instantiating database pools, creating repositories (adapters), passing them to services (core), setting up handlers (api), and starting the HTTP server with graceful shutdown.

---

## 2. Step-by-Step Workflow for Adding a Feature

When tasked with adding a new feature or domain resource (e.g., `User` or `Product`), execute the following workflow strictly:

### Step 1: Define Domain Models

Create a file under `internal/core/domain/` (e.g., `user.go`):

- Declare the main entity `struct`.
- Add validation logic via structural methods.
- Declare domain-specific error variables (e.g., `ErrUserAlreadyExists = errors.New("user already exists")`).

### Step 2: Define Ports

Add interfaces in `internal/core/ports/` (e.g., `user.go`):

- Define the service interface (driving port).
- Define the repository interface (driven port).
- Always include `context.Context` as the first argument in all contract methods.

### Step 3: Implement Core Service

Create a file under `internal/core/service/` (e.g., `user_service.go`):

- Implement the service interface.
- Keep business logic inside this service.
- Write unit tests alongside the service implementation (e.g., `user_service_test.go`).

### Step 4: Generate Mocks

If mocks are needed for unit tests:
> [!NOTE]
> The helper script [mock.sh](file:///Users/billykore/Kore/Golang/go-project-layout/scripts/mock.sh) runs `mockgen` on interfaces found in `internal/core/ports` and targets `internal/core/service/mocks` to match the project layout.

Run the mock generator command:

```bash
make mock
```

### Step 5: Implement Driven Adapters

Create repository implementations in `internal/adapters/repository/` (e.g., `postgres_user_repository.go`):

- Implement the repository interface.
- Handle database operations and mapping queries to domain entities.
- Wrap low-level database errors with context before returning (e.g., `fmt.Errorf("query user: %w", err)`).

### Step 6: Implement Driving Adapters

Create handlers and DTOs in `internal/api/` (e.g., `handler/user_handler.go` and `dto/user.go`):

- Parse incoming HTTP payloads into DTO structures.
- Map DTOs to domain objects.
- Call the service.
- Translate service and domain errors into relevant HTTP error codes (e.g., map `ErrUserAlreadyExists` to `http.StatusConflict`).

### Step 7: Wire Dependencies in main.go

Open `cmd/main.go`:

- Initialize the new repository adapter.
- Instantiate the new service, injecting the repository.
- Instantiate the new handler, injecting the service.
- Register endpoints with the HTTP router (e.g., `mux.HandleFunc("/users", userHandler.Create)`).

---

## 3. Idiomatic Code Quality Guidelines

- **Error Handling**:
  - Always return errors to the caller rather than panicking or logging/exiting in core packages.
  - Wrap errors using standard library format: `fmt.Errorf("service action failed: %w", err)`.
  - Use `errors.Is(err, target)` to check for specific errors.
- **Context Propagation**:
  - Pass `context.Context` through all service and repository calls.
  - Respect context cancellations: check `ctx.Err()` during long-running tasks.
- **Configuration Management**:
  - Never hardcode configuration parameters (ports, database credentials).
  - Use `internal/config/config.go` to load parameters from environment variables or YAML configs, and inject values or structure pointers at startup.
- **Graceful Shutdown**:
  - Ensure any new long-running processes (e.g., consumer goroutines, servers) capture exit signals (`SIGINT`, `SIGTERM`) and clean up open connections/resources gracefully.

---

## 4. Useful CLI Command Quick Reference

You can use the root `Makefile` to trigger standard build and verification routines:

```bash
# Compile the application binary
make build

# Build and run the local development server
make run

# Execute all unit tests in the workspace
make test

# Run the standard Go linter and static vet analyzer
make lint
make vet

# Generate mock files for unit tests
make mock

# Generate swagger documentation
make docs

# Perform database migrations
make migrate-create name=<migration_name>
make migrate-up dsn="postgres://user:pass@host:port/db?sslmode=disable"
make migrate-down dsn="postgres://user:pass@host:port/db?sslmode=disable"
```

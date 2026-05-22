# Go Project Layout

## Overview

This repository demonstrates a standard Go project structure following best practices and conventions used in production Go applications.

## Project Structure

This project follows a clean directory structure inspired by the standard Go project layout, adapted to implement **Hexagonal Architecture** (also known as **Ports and Adapters**).

```text
.
├── Makefile                # Automates development commands
├── README.md               # Root documentation
├── api/                    # API specifications (OpenAPI, gRPC proto definitions, etc.)
├── build/                  # Package build and CI configurations
│   ├── ci/                 # Continuous integration pipelines
│   └── package/            # Application packaging (e.g. Dockerfiles)
├── cmd/                    # Executable entry points
│   └── main.go             # Application bootstrap & dependency injection
├── configs/                # Configuration file templates (YAML, JSON, env)
├── deployments/            # Cloud deployment configurations (Kubernetes, Compose)
├── githooks/               # Git hook hooks for development checks
├── go.mod                  # Go module definition
├── internal/               # Private application code (Hexagonal Architecture)
│   ├── adapters/           # Driven adapters (external systems implementation)
│   │   └── repository/     # Data persistence adapters (Memory, DBs, etc.)
│   ├── api/                # Driving adapters (incoming client interfaces)
│   │   ├── dto/            # Data Transfer Objects for API payloads
│   │   └── handler/        # HTTP handlers / controller logic
│   └── core/               # Clean business domain logic (dependency-free)
│       ├── domain/         # Core business entities & validations
│       ├── ports/          # Boundary contracts (driving & driven interfaces)
│       └── service/        # Use cases implementing driving ports
├── pkg/                    # Reusable library code safe for external imports
├── scripts/                # Helper bash scripts invoked by Makefile
└── test/                   # External integration & end-to-end test suites
```

### `/cmd`

Contains application entrypoints.

- [cmd/main.go](file:///Users/billykore/Kore/Golang/go-project-layout/cmd/main.go) acts as the **Composition Root**. It initializes the driven repository adapters, passes them to core services, connects services to HTTP handlers, and configures the standard HTTP server. It also implements graceful shutdown handling.

### `/internal`

Contains private application and library code. The Go compiler enforces that code within `/internal` cannot be imported by external packages.

This project organizes `/internal` using **Hexagonal Architecture** to decouple core business rules from external framework dependencies, delivery mechanisms, and databases:

#### 1. Core (`/internal/core`)

The innermost layer of the architecture, completely free of external dependencies (imports are restricted to the Go standard library).

- **`domain/`** ([greeting.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/core/domain/greeting.go)): Contains the domain models/entities and core validations.
- **`ports/`** ([greeting.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/core/ports/greeting.go)): Defines boundaries via interfaces.
  - *Driving Ports* (Services): Inward-facing interfaces that expose core business logic to entrypoints.
  - *Driven Ports* (Repositories): Outward-facing interfaces representing storage, external APIs, etc.
- **`service/`** ([greeting_service.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/core/service/greeting_service.go)): Implements driving ports, orchestrating application-level use cases.

#### 2. Adapters (`/internal/adapters`)

Infrastructure-specific implementations of the *Driven Ports*.

- **`repository/`** ([memory_greeting_repository.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/adapters/repository/memory_greeting_repository.go)): Implements data persistence and storage interfaces defined in `ports`.

#### 3. API (`/internal/api`)

Entrypoints or *Driving Adapters* that receive requests and translate them to core logic.

- **`handler/`** ([greeting_handler.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/api/handler/greeting_handler.go)): Handles HTTP/gRPC transport, validation, serialization, and maps actions to core services.
- **`dto/`** ([greeting.go](file:///Users/billykore/Kore/Golang/go-project-layout/internal/api/dto/greeting.go)): Houses request/response Data Transfer Objects.

---

### `/pkg`

Public helper libraries. Other projects can import files under `pkg/` as they represent general-purpose libraries decoupled from the business domain.

---

### `/scripts`

Automation bash scripts that keep the root `Makefile` clean and readable:

- `build.sh`: Builds the executable binaries.
- `run.sh`: Builds and runs the application.
- `test.sh`: Executes the unit test suite.
- `vet.sh`: Runs the `go vet` lint checker.
- `lint.sh`: Runs static linting checks.
- `clean.sh`: Cleans up local build outputs.
- `docs.sh`: Generates swagger or API documentation.
- `mock.sh`: Automates mock generation for interface testing.
- `migrate.sh`: Executes database schema migrations.
- `help.sh`: Generates helper menus.

---

### `/build` and `/deployments`

- **`/build/ci/`**: Workflows for continuous integration engines (like GitHub Actions, GitLab CI).
- **`/build/package/`**: Dockerfiles and packaging assets.
- **`/deployments/`**: Kubernetes manifests, docker-compose setups, or Helm charts.

---

### `/test`

External test files, integration testing templates, and mock fixtures.

## Best Practices

- Keep `internal/` for code that should not be exported
- Use `pkg/` for reusable packages
- Place main functions in `/cmd`
- Use meaningful directory names
- Keep related functionality together
- Avoid circular dependencies
- Write clear documentation for public packages

## Building and Running

You can use the root `Makefile` to trigger standard tasks:

```bash
# Build the application binary
make build

# Run the local server
make run

# Run all tests
make test

# Run the linter
make lint
```

Or run Go commands directly:

```bash
# Build the application
go build ./cmd/main.go

# Run the application
go run ./cmd/main.go

# Run tests
go test ./...
```

## AI Developer Guidance

For development instructions and architectural constraints tailored for AI coding assistants, see the **[AGENTS.md](file:///Users/billykore/Kore/Golang/go-project-layout/AGENTS.md)** guide.

## Dependencies

- Go 1.26 or higher recommended
- `golangci-lint` (optional, for running lint checks)
- `mockgen` (optional, for generating mock files)

## License

Add your license information here.

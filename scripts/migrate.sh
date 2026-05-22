#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Check if migrate is installed
if ! command -v migrate &> /dev/null; then
    echo "Error: 'migrate' tool (golang-migrate) is not installed."
    echo "Please install it following the instructions at https://github.com/golang-migrate/migrate/tree/master/cmd/migrate"
    exit 1
fi

MIGRATIONS_DIR="db/migrations"

# Make sure migrations directory exists
mkdir -p "$MIGRATIONS_DIR"

COMMAND="${1:-}"
DSN="${2:-}"
NAME="${3:-}"

case "$COMMAND" in
    create)
        if [ -z "$NAME" ]; then
            echo "Error: migration name is required for 'create'."
            exit 1
        fi
        echo "Creating new migration: $NAME"
        migrate create -ext sql -dir "$MIGRATIONS_DIR" -seq "$NAME"
        ;;
    up)
        if [ -z "$DSN" ]; then
            echo "Error: database DSN is required for 'up'."
            exit 1
        fi
        echo "Running up migrations..."
        migrate -path "$MIGRATIONS_DIR" -database "$DSN" up ${NAME:+"$NAME"}
        ;;
    down)
        if [ -z "$DSN" ]; then
            echo "Error: database DSN is required for 'down'."
            exit 1
        fi
        echo "Running down migrations..."
        migrate -path "$MIGRATIONS_DIR" -database "$DSN" down ${NAME:+"$NAME"}
        ;;
    *)
        echo "Usage: $0 [create|up|down] [dsn] [name/steps]"
        exit 1
        ;;
esac
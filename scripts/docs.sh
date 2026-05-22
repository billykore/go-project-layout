#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Check if swag is installed
if ! command -v swag &> /dev/null; then
    echo "Error: 'swag' tool is not installed."
    echo "Please install it by running: go install github.com/swaggo/swag/cmd/swag@latest"
    exit 1
fi

echo "Formatting swagger documentation..."
swag fmt

echo "Generating swagger documentation..."
swag init -g cmd/main.go -o api/swagger --parseDependency --parseInternal

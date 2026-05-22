#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Check if golangci-lint is installed
if ! command -v golangci-lint &> /dev/null; then
    echo "Error: 'golangci-lint' is not installed."
    echo "Please install it following the instructions at https://golangci-lint.run/welcome/install/"
    exit 1
fi

echo "Running golangci-lint..."
golangci-lint run -c .golangci.yml ./...

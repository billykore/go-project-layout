#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

echo "Running go vet..."
go vet ./...

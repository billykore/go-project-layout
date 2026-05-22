#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Usage: ./scripts/build.sh [BUILD_DIR] [APP_NAME]
BUILD_DIR="${1:-./bin}"
APP_NAME="${2:-main}"

# Ensure build directory exists
mkdir -p "$BUILD_DIR"

echo "Building application..."
go build -mod=mod -o "${BUILD_DIR}/${APP_NAME}" "./cmd/main.go"
echo "Build completed. Binary is located at ${BUILD_DIR}/${APP_NAME}"

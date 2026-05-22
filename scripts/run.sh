#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Usage: ./scripts/run.sh [BUILD_DIR] [APP_NAME]
BUILD_DIR="${1:-./bin}"
APP_NAME="${2:-main}"
BINARY="${BUILD_DIR}/${APP_NAME}"

if [ ! -f "$BINARY" ]; then
    echo "Warning: Binary '$BINARY' not found. Attempting to build..."
    ./scripts/build.sh "$BUILD_DIR" "$APP_NAME"
fi

echo "Running application: $BINARY..."
exec "$BINARY"

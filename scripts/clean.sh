#!/bin/bash

# Exit immediately if a command exits with a non-zero status,
# an unset variable is referenced, or any command in a pipeline fails.
set -euo pipefail

# Resolve the project root directory
cd "$(dirname "$0")/.."

# Usage: ./scripts/clean.sh [BUILD_DIR]
BUILD_DIR="${1:-./bin}"

if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning up build artifacts in $BUILD_DIR..."
    rm -rf "$BUILD_DIR"
else
    echo "Nothing to clean. Build directory '$BUILD_DIR' does not exist."
fi

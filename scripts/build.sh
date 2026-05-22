#!/bin/bash
# Usage: ./scripts/build.sh [BUILD_DIR] [APP_NAME]
BUILD_DIR="${1:-./bin}"
APP_NAME="${2:-main}"
go build -mod=mod -o "${BUILD_DIR}/${APP_NAME}" "./cmd/main.go"
echo "Build completed. Binary is located at ${BUILD_DIR}/${APP_NAME}"

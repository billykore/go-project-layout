#!/bin/bash
# Usage: ./scripts/run.sh [BUILD_DIR] [APP_NAME]
BUILD_DIR="${1:-./bin}"
APP_NAME="${2:-main}"
"${BUILD_DIR}/${APP_NAME}"

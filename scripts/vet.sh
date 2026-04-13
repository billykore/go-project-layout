#!/bin/bash
# Usage: ./scripts/vet.sh [APP_NAME]
APP_NAME="${1:-_your_app_}"
go vet ./... "./internal/app/${APP_NAME}/..."

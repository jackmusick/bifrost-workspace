#!/bin/bash

# Bifrost Workspace - Stop Development Services

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

echo "🛑 Stopping Bifrost Development Environment..."
echo ""

# Stop all Docker services
echo "🐳 Stopping Docker services (Azurite + API + Client)..."
docker-compose down

echo ""
echo "✅ All services stopped"
echo ""
echo "💡 To remove all data (including Azurite storage):"
echo "   docker-compose down -v"
echo ""

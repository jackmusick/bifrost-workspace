#!/bin/bash

# Bifrost Workspace - Start Development Environment
# Starts: Azurite (storage) + API (workflows engine) + Client (web interface)

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Starting Bifrost Development Environment..."
echo ""

# Download latest bifrost type stubs from GitHub releases
echo "📥 Downloading latest Bifrost type stubs..."
TYPES_URL="https://github.com/jackmusick/bifrost-api/releases/latest/download/bifrost.pyi"
if curl -sSfL "$TYPES_URL" -o bifrost.pyi; then
    echo "   ✅ Type stubs downloaded"
else
    echo "   ⚠️  Warning: Failed to download type stubs (continuing anyway)"
fi
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  Warning: .env file not found!"
    echo "   Please copy .env.example to .env and configure your credentials."
    echo ""
    read -p "Do you want to create .env from .env.example now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp .env.example .env
        echo "✅ Created .env file. Please edit it with your credentials before continuing."
        exit 1
    else
        echo "❌ Cannot start without .env file. Exiting."
        exit 1
    fi
fi

# Start all services (will pull images if needed)
echo ""
echo "🐳 Starting Docker services (Azurite + API + Client)..."
docker compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."

# Wait for API
echo "   Checking API..."
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:7071/api/health > /dev/null 2>&1; then
        echo "   ✅ API ready"
        break
    fi
    attempt=$((attempt + 1))
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo "   ⚠️  Warning: API not responding after 30s"
    echo "   Check logs: docker-compose logs api"
fi

# Wait for Client
echo "   Checking Client..."
max_attempts=20
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:4280 > /dev/null 2>&1; then
        echo "   ✅ Client ready"
        break
    fi
    attempt=$((attempt + 1))
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo "   ⚠️  Warning: Client not responding after 20s"
    echo "   Check logs: docker-compose logs client"
fi

echo ""
echo "✅ All services started!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Access the application:"
echo "   • Web Interface:  http://localhost:4280"
echo "   • API:            http://localhost:7071"
echo ""
echo "🐛 Debugging workflows:"
echo "   1. Set breakpoints in your Python workflow files"
echo "   2. Press F5 in VS Code (or use 'Attach to Docker Functions' config)"
echo "   3. Trigger your workflow from the web interface"
echo ""
echo "📊 View logs:"
echo "   • All:      docker compose logs -f"
echo "   • API:      docker compose logs -f api"
echo "   • Client:   docker compose logs -f client"
echo ""
echo "🛑 Stop services:"
echo "   • ./stop.sh"
echo "   • docker compose down"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

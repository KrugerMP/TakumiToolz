#!/bin/bash

# Script to start both Takumi.Web and Taukimi.Api together

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting TakumiToolz Development Environment...${NC}"

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Paths to both projects
API_PATH="$PROJECT_ROOT/src/Taukimi.Api"
WEB_PATH="$PROJECT_ROOT/src/Takumi.Web"

# Function to kill background processes on exit
cleanup() {
    echo -e "\n${YELLOW}Shutting down...${NC}"
    kill $API_PID $WEB_PID 2>/dev/null
    wait $API_PID $WEB_PID 2>/dev/null
    echo -e "${GREEN}All services stopped.${NC}"
    exit 0
}

# Trap Ctrl+C and call cleanup function
trap cleanup INT TERM

# Start the API in the background
echo -e "${GREEN}Starting Taukimi.Api on http://localhost:5087 and https://localhost:7075${NC}"
cd "$API_PATH"
dotnet run --launch-profile http &
API_PID=$!

# Give the API a moment to start
sleep 2

# Start the Web application in the foreground
echo -e "${GREEN}Starting Takumi.Web on http://localhost:5183 and https://localhost:7101${NC}"
cd "$WEB_PATH"
dotnet run --launch-profile https &
WEB_PID=$!

# Wait for both processes
wait $API_PID $WEB_PID

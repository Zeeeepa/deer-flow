#!/bin/bash

# Start both of DeerFlow's backend and web UI server.
# If the user presses Ctrl+C, kill them both.

if [ "$1" = "--dev" -o "$1" = "-d" -o "$1" = "dev" -o "$1" = "development" ]; then
  echo -e "Starting DeerFlow in [DEVELOPMENT] mode...\n"
  uv run server.py --reload & SERVER_PID=$!
  cd web && pnpm dev & WEB_PID=$!
  trap "kill $SERVER_PID $WEB_PID" SIGINT SIGTERM
  wait
else
  echo -e "Starting DeerFlow in [PRODUCTION] mode...\n"
  
  # Build the frontend first if .next directory doesn't exist or is empty
  if [ ! -d "web/.next" ] || [ -z "$(ls -A web/.next 2>/dev/null)" ]; then
    echo "Building frontend..."
    cd web && pnpm install && pnpm build && cd ..
  fi
  
  # Start backend server in background
  uv run server.py & SERVER_PID=$!
  
  # Start frontend server
  cd web && pnpm start & WEB_PID=$!
  
  # Set up trap to kill both processes on exit
  trap "kill $SERVER_PID $WEB_PID" SIGINT SIGTERM
  wait
fi

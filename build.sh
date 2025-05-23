#!/bin/bash

# Build script for DeerFlow
# This script builds the frontend and ensures all dependencies are installed

echo "Building DeerFlow..."

# Install frontend dependencies and build
echo "Installing frontend dependencies..."
cd web && pnpm install

echo "Building frontend..."
pnpm build

echo "Build complete! You can now run './bootstrap.sh' to start DeerFlow in production mode."


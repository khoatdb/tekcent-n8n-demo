#!/bin/bash
# Build script for TekcentDemo Sitecore solution (Linux/macOS)
# This script builds the entire solution using dotnet build

echo "==============================================="
echo "Building TekcentDemo Sitecore Solution"
echo "==============================================="

# Set solution file path
SOLUTION_FILE="TekcentDemo.sln"

# Check if solution file exists
if [ ! -f "$SOLUTION_FILE" ]; then
    echo "Solution file not found: $SOLUTION_FILE"
    exit 1
fi

echo "Restoring NuGet packages..."
dotnet restore "$SOLUTION_FILE"
if [ $? -ne 0 ]; then
    echo "Package restore failed"
    exit 1
fi

echo "Building solution in Debug configuration..."
dotnet build "$SOLUTION_FILE" --configuration Debug --no-restore
if [ $? -ne 0 ]; then
    echo "Debug build failed"
    exit 1
fi

echo "Building solution in Release configuration..."
dotnet build "$SOLUTION_FILE" --configuration Release --no-restore
if [ $? -ne 0 ]; then
    echo "Release build failed"
    exit 1
fi

echo "==============================================="
echo "Build completed successfully!"
echo "==============================================="
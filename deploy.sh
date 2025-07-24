#!/bin/bash
# Deployment script for Postfix Calculator (RPN)
# Author: Jimmy Lin

echo "🚀 Starting Postfix Calculator deployment..."

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Remove any orphaned containers
echo "🧹 Cleaning up orphaned containers..."
docker container prune -f 2>/dev/null || true

# Build and start the application
echo "🔨 Building and starting application..."
docker-compose up --build -d

# Wait for the application to start
echo "⏳ Waiting for application to start..."
sleep 10

# Check if the application is running
echo "🔍 Checking application status..."
if curl -f http://localhost:3000/ >/dev/null 2>&1; then
    echo "✅ Application is running successfully!"
    echo "🌐 Access your Postfix Calculator at: http://localhost:3000"
else
    echo "❌ Application failed to start. Checking logs..."
    docker-compose logs web
fi

echo "📊 Container status:"
docker-compose ps

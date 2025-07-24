#!/bin/bash
# Docker entrypoint script for RPN Calculator
# Author: Jimmy Lin
# Handles database setup and application startup for Dokploy deployment

set -e

echo "🚀 Starting RPN Calculator..."

# Generate secret key if not provided
if [ -z "$SECRET_KEY_BASE" ]; then
  echo "📝 Generating SECRET_KEY_BASE..."
  export SECRET_KEY_BASE=$(bundle exec rails secret)
fi

# Ensure database exists and is migrated
echo "🗄️  Setting up database..."
bundle exec rails db:create db:migrate RAILS_ENV=production

# Precompile assets if needed (in case they weren't built in Docker image)
if [ ! -d "public/assets" ]; then
  echo "🎨 Precompiling assets..."
  bundle exec rails assets:precompile RAILS_ENV=production
fi

# Create necessary directories
mkdir -p tmp/pids tmp/cache tmp/sockets

echo "✅ Setup complete! Starting Rails server..."

# Execute the main command
exec "$@"

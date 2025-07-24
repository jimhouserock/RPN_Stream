# Multi-stage Dockerfile for RPN Calculator Rails Application
# Optimized for production deployment with Dokploy

# Stage 1: Build environment
FROM ruby:3.2.3-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    nodejs \
    npm \
    git

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./

# Install gems without deployment mode first
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Create ruby3.2 symlink for compatibility
RUN ln -sf /usr/local/bin/ruby /usr/local/bin/ruby3.2

# Copy application code
COPY . .

# Precompile assets with temporary secret key
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

# Stage 2: Production runtime
FROM ruby:3.2.3-alpine AS runtime

# Install runtime dependencies
RUN apk add --no-cache \
    sqlite \
    tzdata \
    bash \
    curl

# Create app user for security
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder --chown=appuser:appgroup /app /app
COPY --from=builder --chown=appuser:appgroup /usr/local/bundle /usr/local/bundle

# Copy and setup entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create ruby3.2 symlink for runtime compatibility
RUN ln -sf /usr/local/bin/ruby /usr/local/bin/ruby3.2

# Create necessary directories
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log storage && \
    chown -R appuser:appgroup tmp log storage

# Switch to app user
USER appuser

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Set entrypoint and default command
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
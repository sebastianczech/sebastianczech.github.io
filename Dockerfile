FROM ruby:3.2-slim

# Install essential Linux packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock
COPY Gemfile* ./

# Install bundler and Jekyll dependencies
RUN gem install bundler && \
    bundle install

# Copy the rest of the application
COPY . .

# Expose port 4000
EXPOSE 4000

# Set environment variables
ENV JEKYLL_ENV=development
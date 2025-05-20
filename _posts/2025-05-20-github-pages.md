---
layout: post
title: GitHub pages
categories: hosting
tags: hosting
---

When I started using GitHub Pages, I used default approach (deploy from branch), which is defined in repository -> settings -> pages. This is the simplest way to host a static website, but it has some limitations. 

Recently I added custom workflows, which allows for more flexibility and control over the deployment process. More details can be found in the [GitHub documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages). In my solution I used Docker to build the Jekyll site and GitHub Actions to automate the deployment process.

Besides that I prepared Docker compose file, which allows to run the Jekyll site locally. This is a great way to test changes before pushing them to the repository. The Docker compose file is available in the repository:

```yaml
services:
  # Development service with live reload
  jekyll-dev:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/srv/jekyll
      - ./_site:/srv/jekyll/_site
    ports:
      - "4000:4000"
    command: >
      bash -c "bundle install &&
      bundle exec jekyll serve --host 0.0.0.0 --livereload"

  # Build service for production
  jekyll-build:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/srv/jekyll
      - ./_site:/srv/jekyll/_site
    command: >
      bash -c "bundle install &&
      bundle exec jekyll build"
```

Docker image is built using Dockerfile, which is also available in the repository. The Dockerfile uses the official Jekyll image as a base and installs the required dependencies:

```dockerfile
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
```

I hope this information will be helpful for you. You can find the complete code in my [GitHub repository](https://github.com/sebastianczech/sebastianczech.github.io).

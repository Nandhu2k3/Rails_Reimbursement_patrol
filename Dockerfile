# Base: modern Ubuntu so apt works reliably
FROM ubuntu:20.04

# Non-interactive apt
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies for building Ruby, running Rails, and Postgres
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      curl \
      ca-certificates \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      libpq-dev \
      nodejs && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install rbenv + ruby-build so we can compile Ruby 2.5.3
ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH="${RBENV_ROOT}/bin:${PATH}"

RUN git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" && \
    mkdir -p "${RBENV_ROOT}/plugins" && \
    git clone https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"

# Build and select Ruby 2.5.3, install Bundler
RUN rbenv install 2.5.3 && \
    rbenv global 2.5.3 && \
    gem install bundler -v "~>2" && \
    rbenv rehash

# Ensure shims are on PATH for all subsequent commands
ENV PATH="${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}"

# App directory
WORKDIR /app

# Install gems (production only)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the rest of the app
COPY . .

# Rails environment
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets
RUN bundle exec rake assets:precompile

# Puma listens on 3000; Render maps $PORT and puma.rb reads it
EXPOSE 3000

# Start Puma with your existing config
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
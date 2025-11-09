FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# System deps for building Ruby 2.5.3 and running Rails + Postgres
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      autoconf \
      bison \
      git \
      curl \
      ca-certificates \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      libyaml-dev \
      libffi-dev \
      libgdbm-dev \
      libncurses5-dev \
      libncursesw5-dev \
      libpq-dev \
      nodejs \
      patch && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# rbenv + ruby-build
ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:${PATH}"

RUN git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" && \
    mkdir -p "${RBENV_ROOT}/plugins" && \
    git clone https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"

# Build Ruby 2.5.3 (limited parallelism so it doesn't die on small instances)
RUN MAKEOPTS="-j2" rbenv install 2.5.3 && \
    rbenv global 2.5.3 && \
    rbenv rehash && \
    gem install bundler -v "~>2"

# From this point, `ruby`, `gem`, `bundle` all point to Ruby 2.5.3 via rbenv shims

WORKDIR /app

# Install gems (production only)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the rest of the app
COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets
RUN bundle exec rake assets:precompile

# Puma/Render: Puma listens on 3000; Render provides $PORT, puma.rb uses it
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
# Use Ruby 2.5.3 (assignment requirement)
FROM ruby:2.5.3

# EOL Debian mirror fix + system dependencies
# Old ruby images point to deb.debian.org/security.debian.org which no longer
# serve this distro; we switch to archive.debian.org then install deps.
RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's/security.debian.org/archive.debian.org/g' \
           /etc/apt/sources.list || true

RUN apt-get -o Acquire::Check-Valid-Until=false update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

# App directory
WORKDIR /app

# Install gems (production only)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the application
COPY . .

# Rails env
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets
RUN bundle exec rake assets:precompile

# Puma will listen on 3000 (Render passes PORT, puma.rb reads it)
EXPOSE 3000

# Start Puma with your config
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
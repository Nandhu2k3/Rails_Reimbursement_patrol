# Use Ruby 2.5.3 to match the assignment
FROM ruby:2.5.3

# Install system dependencies (no yarn here)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems (production only)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the rest of the app
COPY . .

# Rails env
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets
RUN bundle exec rake assets:precompile

# Puma listens on 3000 (Render maps $PORT -> 3000 via puma.rb)
EXPOSE 3000

# Start Puma with your config
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
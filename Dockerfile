FROM ruby:2.5.3

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy app
COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production

# Precompile assets
RUN bundle exec rake assets:precompile

EXPOSE 3000

# Use your puma.rb
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
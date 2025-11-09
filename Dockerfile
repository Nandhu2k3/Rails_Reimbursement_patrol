FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

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

ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH="${RBENV_ROOT}/bin:${PATH}"

RUN git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" && \
    mkdir -p "${RBENV_ROOT}/plugins" && \
    git clone https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"

# ⬇️ limit parallelism so Ruby 2.5.3 build doesn't die
RUN MAKEOPTS="-j2" rbenv install 2.5.3 && \
    rbenv global 2.5.3 && \
    gem install bundler -v "~>2" && \
    rbenv rehash

ENV PATH="${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}"

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
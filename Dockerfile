FROM ruby:3.3.0-slim-bookworm

ARG PACKAGES="curl libsqlite3-0 libvips build-essential git pkg-config nodejs"
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y $PACKAGES \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN gem install rails 

WORKDIR /app
COPY Gemfile* /app
RUN bundle install

CMD rails s -b '0.0.0.0'

FROM ruby:3.3.0-slim-bookworm
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y curl libsqlite3-0 libvips build-essential git pkg-config nodejs \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives
# RUN apt-get update -qq \
#     && apt-get install --no-install-recommends -y build-essential git libvips pkg-config nodejs
RUN gem install rails 

WORKDIR /app
COPY Gemfile* /app
RUN bundle install

CMD rails s -b '0.0.0.0'

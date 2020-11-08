FROM ruby:2.7.2-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        build-essential \
        libmagickwand-dev \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle install --jobs=4 --retry=3 && \
    rm -rf /usr/local/bundle/cache

COPY . .

CMD ["sh"]
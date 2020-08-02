FROM ruby:2.5.8
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y build-essential libpq-dev postgresql-client \
  && apt-get install -y nodejs yarn \
  && apt-get install -y imagemagick vim

RUN gem install rails -v "6.0.2"
RUN mkdir /app
WORKDIR /app

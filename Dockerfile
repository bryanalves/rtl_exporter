FROM ruby:2.7

MAINTAINER Bryan Alves <bryanalves@gmail.com>

WORKDIR /usr/src/app

COPY . .

RUN bundle install

CMD ["ruby", "main.rb"]

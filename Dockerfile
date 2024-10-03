FROM ruby:3.1-alpine

RUN gem install sapphire-chess

CMD ["sapphire-chess"]

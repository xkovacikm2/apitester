FROM ruby

WORKDIR /app
COPY . .
RUN gem install bundler
RUN bundle install
CMD ruby api-tester.rb
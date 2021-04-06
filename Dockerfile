FROM ruby:2.7.0

WORKDIR /app
ENV BUNDLE_PATH /gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

ENTRYPOINT ["bin/rails"]
CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000

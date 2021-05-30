FROM ruby:3.0.1

# Some ruby gems have non ascii characters, triggering "invalid multibyte char (US-ASCII)" errors
ENV LC_ALL=C.UTF-8 
ENV RAILS_ROOT /usr/src/app

RUN apt-get update -qq \
  && apt-get upgrade -qq \
  && apt-get clean

WORKDIR /usr/src/app

COPY Gemfile* ./

RUN bundle install

COPY . /usr/src/app

EXPOSE 3000

# based on rails 4 changed the way it boots up so we need to create entrypoints
# (https://edgeguides.rubyonrails.org/4_0_release_notes.html#railties-notable-changes) 
# https://stackoverflow.com/questions/14841575/rails-4-doesnt-detect-application/14954255
#RUN ["rake", "rails:update:bin"]

# sucessfully start the node.
RUN ["rm","-f","tmp/pids/server.pid"]

# Start the main process.
# this is achieved via the docker-compose.yml file, so that we can run 
# different rake and workers via the same container
CMD ["rails", "server", "-b", "0.0.0.0"]
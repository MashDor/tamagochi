# Use the official Ruby image from the DockerHub
FROM ruby:3.3

# Set the 'app' as the working directory inside the image
WORKDIR /app

# Copy the Gemfile and Gemfile.lock from the host to the working directory inside the image
COPY Gemfile Gemfile.lock ./

# Install bundler and gems
RUN gem install bundler && bundle install

# Copy the rest of the Rails app
COPY . .

# Start the main process (puma server by default for Rails)
CMD ["rails", "server", "-b", "0.0.0.0"]

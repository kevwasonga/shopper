# Fix for Ruby 3.0.0 and Rails 6.1 Logger compatibility issue
require 'logger'

# Ensure Logger constant is available to ActiveSupport
unless defined?(::Logger)
  ::Logger = Logger
end

# Fix for Rails 6.1.3 and Ruby 3.0.0 Logger compatibility issue
# This addresses the "uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger" error

require 'logger'

# Ensure the Logger constant is available in the ActiveSupport::LoggerThreadSafeLevel module
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger unless defined?(Logger)
  end
end

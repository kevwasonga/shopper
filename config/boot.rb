ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Fix for Rails 6.1.3 and Ruby 3.0.0 Logger compatibility
require 'logger'

# Monkey patch to fix ActiveSupport Logger issue
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger unless defined?(Logger)
  end
end

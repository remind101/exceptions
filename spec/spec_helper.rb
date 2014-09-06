require 'bundler/setup'
Bundler.require :default, :test

RSpec.configure do |config|
  config.order = 'random'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

Exceptions.configure do |config|
  config.backend = Exceptions::Backends::Null
end

def backend
  Exceptions.configuration.backend
end

def boom
  StandardError.new("Boom")
end

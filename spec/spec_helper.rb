require 'bundler/setup'
Bundler.require :default, :test

RSpec.configure do |config|
  config.order = 'random'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.around(:each) do |example|
    if backend = example.metadata[:backend]
      with_backend(BACKENDS[backend]) do
        example.run
      end
    else
      example.run
    end
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

BACKENDS = {
  honeybadger: Exceptions::Backends::Honeybadger.new,
  rollbar:     Exceptions::Backends::Rollbar.new,
  multi:       Exceptions::Backends::Multi.new(Exceptions::Backends::Null.new),
  logger:      Exceptions::Backends::Logger.new
}

Exceptions.configure do |config|
  config.backend = BACKENDS[:multi]
end

def with_backend(backend)
  old = Exceptions.configuration.backend
  Exceptions.configuration.backend = backend
  yield
ensure
  Exceptions.configuration.backend = old
end

def backend
  Exceptions.configuration.backend
end

def boom
  StandardError.new("Boom")
end

require 'exceptions/version'
require 'exceptions/configuration'
require 'exceptions/result'
require 'exceptions/backend'

require 'rack/exceptions'

module Exceptions
  module Backends
    autoload :Null,        'exceptions/backends/null'
    autoload :Raiser,      'exceptions/backends/raiser'
    autoload :Multi,       'exceptions/backends/multi'
    autoload :Logger,      'exceptions/backends/logger'
    autoload :LogResult,   'exceptions/backends/log_result'
    autoload :Honeybadger, 'exceptions/backends/honeybadger'
  end

  class << self
    # Public: Forwards the exception to the configured backend.
    #
    # exception - An Exception object.
    # options   - A Hash of options to pass to the backend.
    #
    # Returns a Result object.
    def notify(exception, options = {})
      backend.notify exception, options
    end

    # Public: Set the context.
    #
    # Returns nothing.
    def context(ctx)
      backend.context ctx
    end

    # Public: Clear the context.
    #
    # Returns nothing.
    def clear_context
      backend.clear_context
    end

    # Public: Notify a rack exception.
    #
    # Returns a Result object.
    def rack_exception(exception, env)
      backend.rack_exception exception, env
    end

    # Public: The configuration object.
    #
    # Returns a Configuration instance.
    def configuration
      @configuration ||= Configuration.new
    end

    # Public: Configure the configuration.
    #
    # Yields the Configuration object.
    def configure
      yield configuration
    end

    private

    def backend
      configuration.backend
    end
  end
end

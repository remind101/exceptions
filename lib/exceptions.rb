require 'exceptions/version'
require 'exceptions/configuration'
require 'exceptions/backend'
require 'exceptions/backends'

module Exceptions
  class << self
    # Public: Forwards the exception to the configured backend.
    #
    # exception - An Exception object.
    #
    # Returns a Result object.
    def notify(exception)
      backend.notify exception
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
